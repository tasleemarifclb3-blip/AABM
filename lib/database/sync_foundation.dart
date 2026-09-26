import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import 'app_database.dart';

/// Fresh synchronization storage used by the rewritten AABM sync engine.
///
/// Every table name is prefixed with aabm2_. Existing sync tables are not read.
/// This intentionally makes the rewrite independent of all previous sync
/// mappings, cursors, outbox rows, and approval mappings.
class SyncFoundation {
  SyncFoundation._();

  static const String _deviceTable = 'aabm2_sync_device';
  static const String _outboxTable = 'aabm2_sync_outbox';
  static const String _receivedTable = 'aabm2_sync_received';
  static const String _mapTable = 'aabm2_sync_map';
  static const String _stateTable = 'aabm2_sync_state';
  static const String _failureTable = 'aabm2_sync_failures';
  static const String _conflictTable = 'aabm2_sync_conflicts';

  static Future<void> initialize(AppDatabase db) async {
    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_deviceTable (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        device_id TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    final device = await db.customSelect(
      'SELECT device_id FROM $_deviceTable WHERE id = 1 LIMIT 1',
    ).get();
    if (device.isEmpty) {
      await db.customStatement('''
        INSERT INTO $_deviceTable(id, device_id, created_at) VALUES (1, ?, ?)
      ''', [_id(), DateTime.now().toUtc().toIso8601String()]);
    }

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_outboxTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        change_id TEXT NOT NULL UNIQUE,
        entity TEXT NOT NULL,
        record_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        payload TEXT NOT NULL,
        actor_username TEXT,
        device_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        attempts INTEGER NOT NULL DEFAULT 0,
        last_error TEXT,
        state TEXT NOT NULL DEFAULT 'PENDING'
      )
    ''');
    await db.customStatement('''
      CREATE INDEX IF NOT EXISTS aabm2_outbox_state
      ON $_outboxTable(state, id)
    ''');

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_receivedTable (
        change_id TEXT PRIMARY KEY NOT NULL,
        received_at TEXT NOT NULL,
        source_device_id TEXT
      )
    ''');

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_mapTable (
        entity TEXT NOT NULL,
        source_device_id TEXT NOT NULL,
        source_record_id TEXT NOT NULL,
        local_record_id TEXT NOT NULL,
        row_hash TEXT NOT NULL,
        deleted INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL,
        PRIMARY KEY(entity, source_device_id, source_record_id)
      )
    ''');
    await db.customStatement('''
      CREATE INDEX IF NOT EXISTS aabm2_map_local
      ON $_mapTable(entity, local_record_id, deleted)
    ''');

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_stateTable (
        key TEXT PRIMARY KEY NOT NULL,
        value TEXT
      )
    ''');

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_failureTable (
        change_id TEXT PRIMARY KEY NOT NULL,
        attempts INTEGER NOT NULL DEFAULT 0,
        last_error TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_conflictTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity TEXT NOT NULL,
        record_id TEXT NOT NULL,
        local_change_id TEXT,
        remote_change_id TEXT,
        local_payload TEXT,
        remote_payload TEXT,
        detected_at TEXT NOT NULL
      )
    ''');
  }

  static Future<String> getDeviceId(AppDatabase db) async {
    await initialize(db);
    final rows = await db.customSelect(
      'SELECT device_id FROM $_deviceTable WHERE id = 1 LIMIT 1',
    ).get();
    if (rows.isEmpty) throw StateError('AABM sync device ID is unavailable.');
    return rows.first.data['device_id'].toString();
  }

  static Future<String> enqueueChange(
    AppDatabase db, {
    required String entity,
    required String recordId,
    required String operation,
    required Map<String, dynamic> payload,
    String? actorUsername,
  }) async {
    await initialize(db);
    final changeId = _id();
    final deviceId = await getDeviceId(db);
    await db.customStatement('''
      INSERT INTO $_outboxTable
      (change_id, entity, record_id, operation, payload, actor_username,
       device_id, created_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      changeId,
      entity,
      recordId,
      operation,
      jsonEncode(payload),
      actorUsername,
      deviceId,
      DateTime.now().toUtc().toIso8601String(),
    ]);
    return changeId;
  }

  static Future<List<Map<String, dynamic>>> getPendingChanges(
    AppDatabase db, {
    int limit = 200,
  }) async {
    await initialize(db);
    final rows = await db.customSelect('''
      SELECT id, change_id, entity, record_id, operation, payload,
             actor_username, device_id, created_at, attempts
      FROM $_outboxTable
      WHERE state = 'PENDING'
      ORDER BY id ASC LIMIT ?
    ''', variables: [Variable<int>(limit)]).get();
    return rows.map((r) => <String, dynamic>{
      'id': r.data['id'],
      'changeId': r.data['change_id'],
      'entity': r.data['entity'],
      'recordId': r.data['record_id'],
      'operation': r.data['operation'],
      'payload': jsonDecode(r.data['payload'].toString()),
      'actorUsername': r.data['actor_username'],
      'deviceId': r.data['device_id'],
      'createdAt': r.data['created_at'],
      'attempts': r.data['attempts'],
    }).toList();
  }

  static Future<bool> hasPendingChange(
    AppDatabase db, {
    required String entity,
    required String sourceDeviceId,
    required String sourceRecordId,
  }) async {
    // A pending event belongs to both the source identity and the local
    // device that owns the outbox row. Both are checked to avoid suppressing
    // a legitimate event from another device that happens to use the same id.
    final rows = await db.customSelect('''
      SELECT id FROM $_outboxTable
      WHERE state = 'PENDING' AND entity = ? AND record_id = ? AND device_id = ? LIMIT 1
    ''', variables: [
      Variable<String>(entity),
      Variable<String>(sourceRecordId),
      Variable<String>(sourceDeviceId),
    ]).get();
    return rows.isNotEmpty;
  }

  static Future<void> markUploaded(AppDatabase db, String changeId) async {
    await db.customStatement('''
      UPDATE $_outboxTable SET state = 'SYNCED', last_error = NULL WHERE change_id = ?
    ''', [changeId]);
  }

  static Future<void> markFailed(
    AppDatabase db, {
    required String changeId,
    required String error,
  }) async {
    await db.customStatement('''
      UPDATE $_outboxTable
      SET attempts = attempts + 1, last_error = ?
      WHERE change_id = ?
    ''', [error, changeId]);
  }

  static Future<bool> hasReceived(AppDatabase db, String changeId) async {
    final rows = await db.customSelect(
      'SELECT change_id FROM $_receivedTable WHERE change_id = ? LIMIT 1',
      variables: [Variable<String>(changeId)],
    ).get();
    return rows.isNotEmpty;
  }

  static Future<void> markReceived(
    AppDatabase db, {
    required String changeId,
    String? sourceDeviceId,
  }) async {
    await db.customStatement('''
      INSERT OR IGNORE INTO $_receivedTable(change_id, received_at, source_device_id)
      VALUES (?, ?, ?)
    ''', [changeId, DateTime.now().toUtc().toIso8601String(), sourceDeviceId]);
  }

  static Future<void> clearReceived(AppDatabase db, String changeId) async {
    await db.customStatement('DELETE FROM $_receivedTable WHERE change_id = ?', [changeId]);
  }

  static Future<void> setState(AppDatabase db, String key, String value) async {
    await db.customStatement('''
      INSERT INTO $_stateTable(key, value) VALUES (?, ?)
      ON CONFLICT(key) DO UPDATE SET value = excluded.value
    ''', [key, value]);
  }

  static Future<String?> getState(AppDatabase db, String key) async {
    final rows = await db.customSelect(
      'SELECT value FROM $_stateTable WHERE key = ? LIMIT 1',
      variables: [Variable<String>(key)],
    ).get();
    return rows.isEmpty ? null : rows.first.data['value']?.toString();
  }

  static Future<void> recordFailure(AppDatabase db, String changeId, String error) async {
    await db.customStatement('''
      INSERT INTO $_failureTable(change_id, attempts, last_error, updated_at)
      VALUES (?, 1, ?, ?)
      ON CONFLICT(change_id) DO UPDATE SET
        attempts = $_failureTable.attempts + 1,
        last_error = excluded.last_error,
        updated_at = excluded.updated_at
    ''', [changeId, error, DateTime.now().toUtc().toIso8601String()]);
    await setState(db, 'last_remote_error', error);
  }

  static Future<void> clearFailure(AppDatabase db, String changeId) async {
    await db.customStatement('DELETE FROM $_failureTable WHERE change_id = ?', [changeId]);
  }

  static Future<void> addConflict(
    AppDatabase db, {
    required String entity,
    required String recordId,
    String? localChangeId,
    String? remoteChangeId,
    Map<String, dynamic>? localPayload,
    Map<String, dynamic>? remotePayload,
  }) async {
    await db.customStatement('''
      INSERT INTO $_conflictTable
      (entity, record_id, local_change_id, remote_change_id,
       local_payload, remote_payload, detected_at)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      entity,
      recordId,
      localChangeId,
      remoteChangeId,
      localPayload == null ? null : jsonEncode(localPayload),
      remotePayload == null ? null : jsonEncode(remotePayload),
      DateTime.now().toUtc().toIso8601String(),
    ]);
  }

  static Future<Map<String, dynamic>?> findMapping(
    AppDatabase db, {
    required String entity,
    required String sourceDeviceId,
    required String sourceRecordId,
  }) async {
    final rows = await db.customSelect('''
      SELECT entity, source_device_id, source_record_id, local_record_id,
             row_hash, deleted, updated_at
      FROM $_mapTable
      WHERE entity = ? AND source_device_id = ? AND source_record_id = ?
      LIMIT 1
    ''', variables: [
      Variable<String>(entity),
      Variable<String>(sourceDeviceId),
      Variable<String>(sourceRecordId),
    ]).get();
    return rows.isEmpty ? null : Map<String, dynamic>.from(rows.first.data);
  }

  static Future<Map<String, dynamic>?> findMappingByLocalId(
    AppDatabase db,
    String entity,
    String localRecordId,
  ) async {
    final rows = await db.customSelect('''
      SELECT entity, source_device_id, source_record_id, local_record_id,
             row_hash, deleted, updated_at
      FROM $_mapTable
      WHERE entity = ? AND local_record_id = ? AND deleted = 0
      ORDER BY CASE WHEN source_device_id = (SELECT device_id FROM $_deviceTable WHERE id=1)
                    THEN 0 ELSE 1 END, updated_at DESC
      LIMIT 1
    ''', variables: [Variable<String>(entity), Variable<String>(localRecordId)]).get();
    return rows.isEmpty ? null : Map<String, dynamic>.from(rows.first.data);
  }

  static Future<void> upsertMapping(
    AppDatabase db, {
    required String entity,
    required String sourceDeviceId,
    required String sourceRecordId,
    required String localRecordId,
    required String rowHash,
    bool deleted = false,
  }) async {
    await db.customStatement('''
      INSERT INTO $_mapTable
      (entity, source_device_id, source_record_id, local_record_id,
       row_hash, deleted, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(entity, source_device_id, source_record_id) DO UPDATE SET
        local_record_id = excluded.local_record_id,
        row_hash = excluded.row_hash,
        deleted = excluded.deleted,
        updated_at = excluded.updated_at
    ''', [
      entity,
      sourceDeviceId,
      sourceRecordId,
      localRecordId,
      rowHash,
      deleted ? 1 : 0,
      DateTime.now().toUtc().toIso8601String(),
    ]);
  }

  static Future<List<Map<String, dynamic>>> mappingsForEntity(AppDatabase db, String entity) async {
    final rows = await db.customSelect('''
      SELECT entity, source_device_id, source_record_id, local_record_id,
             row_hash, deleted, updated_at
      FROM $_mapTable WHERE entity = ?
    ''', variables: [Variable<String>(entity)]).get();
    return rows.map((r) => Map<String, dynamic>.from(r.data)).toList();
  }

  static String _id() {
    final r = Random.secure();
    final bytes = List<int>.generate(16, (_) => r.nextInt(256));
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0,8)}-${hex.substring(8,12)}-${hex.substring(12,16)}-${hex.substring(16,20)}-${hex.substring(20)}';
  }
}
