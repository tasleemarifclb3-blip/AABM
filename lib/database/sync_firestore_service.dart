import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drift/drift.dart' show Variable;

import '../firebase_options.dart';
import 'app_database.dart';
import 'sync_foundation.dart';
import 'workflow_service.dart';
import 'data_management_service.dart';

/// AABM Firebase synchronization engine, version 7 with approval repair.
///
/// Design goals:
/// - Drift/SQLite remains the local accounting source of truth.
/// - Existing records are bootstrapped once and then tracked by row hashes.
/// - No deletion is inferred merely because a remote device has not seen a row.
/// - A remote change is marked received ONLY after it has been applied locally.
/// - Failed changes remain retryable.
/// - Local scanning uses one mapping query per table instead of one query per row.
/// - Firestore uploads use batches.
/// - Android and Chrome use the same implementation.
class SyncFirestoreService {
  SyncFirestoreService._();

  static AppDatabase? _db;
  static Timer? _timer;
  static bool _running = false;
  static bool _initialized = false;
  static bool _authReady = false;
  static final Set<String> _applyingRemoteChanges = <String>{};

  static const String collectionName = 'aabm_sync_changes';
  static const String controlCollectionName = 'aabm_sync_control';
  static const String globalResetDocument = 'global_reset';
  static const int protocolVersion = 10;
  static const Duration retryInterval = Duration(seconds: 5);
  static const Duration firstSyncDelay = Duration(seconds: 5);
  static const int pageSize = 300;
  static const int uploadBatchSize = 400;

  static firestore.FirebaseFirestore get _firestore => firestore.FirebaseFirestore.instance;

  /// Parents come before children. Workflow side tables are included because
  /// they affect accounting behaviour and must travel with their transactions.
  static const List<String> _tables = <String>[
    'households',
    'household_charge_histories',
    'household_months',
    'household_payments',
    'household_concessions',
    'financial_transactions',
    'manual_balances',
    'zakaat_beneficiaries',
    'fund_adjustments',
    'zakaat_disbursements',
    'payment_allocations',
    'opening_balance_payment_allocations',
    'household_concession_allocations',
    'opening_balance_concession_allocations',
    'household_status_histories',
    'ledger_opening_balances',
    'qarza_parentage',
    'qarza_conditions',
    'qarza_waivers',
    'aabm_approval_request',
    'aabm_approval_settings',
  ];

  static final Map<String, _TableMeta> _metaCache = <String, _TableMeta>{};

  static Future<void> initialize(AppDatabase db) async {
    _db = db;
    await SyncFoundation.initialize(db);
    await WorkflowService.ensureTables(db);
    await _ensureSupportTables(db);
    await _upgradeLocalSyncStateForApprovalFix(db);

    await _ensureFirebaseAuth(db);

    // Protocol 10 unifies the active mapping/approval transport while preserving
    // the Firestore server-time cursor behaviour.
    // Reset the cursors once when upgrading so the first run can reconcile
    // older events before using the new server-time cursor.
    final storedProtocol = await SyncFoundation.getState(db, 'sync_protocol_version');
    if (storedProtocol != protocolVersion.toString()) {
      await SyncFoundation.setState(db, 'last_remote_sync_at', '');
      await SyncFoundation.setState(db, 'last_approval_sync_at', '');
    }
    await SyncFoundation.setState(db, 'sync_protocol_version', protocolVersion.toString());

    if (!_initialized) {
      _initialized = true;
      _timer?.cancel();
      _timer = Timer.periodic(retryInterval, (_) => unawaited(syncNow()));
    }

    // Never block the first application frame on the network. Give the UI a
    // short head-start, then perform the first full synchronization.
    Future<void>.delayed(firstSyncDelay, () {
      unawaited(syncNow());
    });
  }

  static Future<void> dispose() async {
    _timer?.cancel();
    _timer = null;
    _initialized = false;
  }

  static Future<SyncStatus> syncNow() async {
    final db = _db;
    if (db == null) return const SyncStatus.offline('Sync service not initialized.');
    if (_running) return const SyncStatus.busy();

    _running = true;
    final started = DateTime.now();
    try {
      await _ensureSupportTables(db);

      // Authentication is retried on EVERY cycle. A temporary Firebase/auth
      // failure must never permanently disable synchronization for this app
      // session.
      if (!await _ensureFirebaseAuth(db)) {
        final message = await SyncFoundation.getState(db, 'last_sync_error') ??
            'Firebase authentication is not available.';
        return SyncStatus.offline(message);
      }

      // A global wipe is checked before any download or upload. This prevents
      // an offline device with old pending transactions from re-uploading
      // deleted accounting data after the administrator has wiped Firebase.
      await _applyGlobalResetIfNeeded(db);

      // Remote errors must not prevent local changes from being uploaded.
      // This is particularly important when an older remote record has a
      // dependency that cannot yet be resolved.
      String? remoteError;
      try {
        await _downloadRemote(db);
      } catch (e) {
        remoteError = e.toString();
        await SyncFoundation.setState(db, 'last_remote_sync_error', remoteError);
      }

      String? scanError;
      try {
        scanError = await _scanLocalDatabase(db);
      } catch (e) {
        scanError = e.toString();
        await SyncFoundation.setState(db, 'last_scan_error', scanError);
      }

      // Always attempt the outbox even if download/scan encountered an
      // unrelated problem. Pending changes remain retryable until committed.
      await _uploadPending(db);

      try {
        await _downloadRemote(db);
      } catch (e) {
        remoteError ??= e.toString();
        await SyncFoundation.setState(db, 'last_remote_sync_error', remoteError);
      }

      // Approval events are workflow state, not accounting rows. Their feed
      // must not depend solely on the time cursor because the existing
      // createdAt values come from device clocks. A laptop clock that is behind
      // the phone can otherwise make a brand-new approval fall behind the
      // phone's cursor and never be seen. Reconcile the approval event stream
      // independently once per cycle.
      try {
        await _downloadApprovalBackfill(db);
      } catch (e) {
        remoteError ??= e.toString();
        await SyncFoundation.setState(db, 'last_remote_approval_sync_error', remoteError);
      }

      final elapsed = DateTime.now().difference(started).inMilliseconds;
      await SyncFoundation.setState(db, 'last_sync_at', DateTime.now().toUtc().toIso8601String());
      await SyncFoundation.setState(db, 'last_sync_duration_ms', elapsed.toString());

      final problem = remoteError ?? scanError;
      if (problem != null) {
        await SyncFoundation.setState(db, 'last_sync_error', problem);
        return SyncStatus.error(problem);
      }

      await SyncFoundation.setState(db, 'last_sync_error', '');
      return const SyncStatus.success();
    } catch (e) {
      await SyncFoundation.setState(db, 'last_sync_error', e.toString());
      return SyncStatus.error(e.toString());
    } finally {
      _running = false;
    }
  }

  static Future<bool> _ensureFirebaseAuth(AppDatabase db) async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      _authReady = FirebaseAuth.instance.currentUser != null;
      if (_authReady) {
        await SyncFoundation.setState(db, 'last_sync_error', '');
        return true;
      }

      _authReady = false;
      await SyncFoundation.setState(
        db,
        'last_sync_error',
        'Firebase authentication did not produce a signed-in user.',
      );
      return false;
    } catch (e, stack) {
      _authReady = false;
      final message = 'Firebase authentication: $e';
      await SyncFoundation.setState(db, 'last_sync_error', message);
      debugPrint('[AABM SYNC] $message');
      debugPrint('$stack');
      return false;
    }
  }

  // -------------------------------------------------------------------------
  // GLOBAL DATABASE RESET
  // -------------------------------------------------------------------------

  static Future<String> deleteEntireDatabase(AppDatabase db) async {
    await SyncFoundation.initialize(db);
    await WorkflowService.ensureTables(db);
    if (!await _ensureFirebaseAuth(db)) {
      throw StateError('Firebase authentication is not available. The global delete was not performed.');
    }

    final deviceId = await SyncFoundation.getDeviceId(db);
    final token = '${DateTime.now().toUtc().toIso8601String()}__$deviceId';

    // Publish the reset marker first. Any device that is offline now will see
    // this marker before it is allowed to upload its old outbox when it next
    // reconnects.
    await _firestore.collection(controlCollectionName).doc(globalResetDocument).set({
      'token': token,
      'requestedAt': firestore.FieldValue.serverTimestamp(),
      'requestedByDevice': deviceId,
      'scope': 'AABM_ACCOUNTING_DATABASE',
    });

    // Delete every accounting sync event from Firebase. The reset marker is
    // intentionally retained as control metadata; without it an offline
    // device could resurrect the deleted database when it reconnects.
    while (true) {
      final snapshot = await _firestore.collection(collectionName).limit(450).get();
      if (snapshot.docs.isEmpty) break;
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      if (snapshot.docs.length < 450) break;
    }

    // Wipe this device immediately as well. Other devices perform the same
    // operation when they observe the reset marker during their next sync.
    await DataManagementService.deleteAllData(db);
    await SyncFoundation.setState(db, 'global_reset_token', token);
    await SyncFoundation.setState(db, 'last_remote_sync_at', '');
    await SyncFoundation.setState(db, 'last_approval_sync_at', '');
    return 'The entire synchronized AABM database has been deleted from Firebase. All other devices will clear their local accounting data on their next sync.';
  }

  static Future<void> _applyGlobalResetIfNeeded(AppDatabase db) async {
    final doc = await _firestore
        .collection(controlCollectionName)
        .doc(globalResetDocument)
        .get();
    if (!doc.exists) return;
    final data = doc.data() ?? <String, dynamic>{};
    final token = data['token']?.toString() ?? '';
    if (token.isEmpty) return;

    final applied = await SyncFoundation.getState(db, 'global_reset_token');
    if (applied == token) return;

    debugPrint('[AABM SYNC] Applying global database reset $token');
    await DataManagementService.deleteAllData(db);
    await SyncFoundation.setState(db, 'global_reset_token', token);
    await SyncFoundation.setState(db, 'last_remote_sync_at', '');
    await SyncFoundation.setState(db, 'last_approval_sync_at', '');
  }

  // -------------------------------------------------------------------------
  // SUPPORT TABLES
  // -------------------------------------------------------------------------

  static Future<void> _ensureSupportTables(AppDatabase db) async {
    await SyncFoundation.initialize(db);

    // V5's scanner used sync_record_map while SyncFoundation already owned the
    // aabm2_sync_map used by workflow code. Migrate the useful V5 mappings once
    // so existing transactions keep their stable source identities instead of
    // being re-created as brand-new records on the first repaired sync cycle.
    final legacy = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'sync_record_map' LIMIT 1",
    ).get();
    if (legacy.isEmpty) return;

    await db.customStatement('''
      INSERT OR IGNORE INTO aabm2_sync_map
        (entity, source_device_id, source_record_id, local_record_id,
         row_hash, deleted, updated_at)
      SELECT entity, source_device_id, source_record_id, local_record_id,
             row_hash, deleted, updated_at
      FROM sync_record_map
      WHERE entity NOT IN ('cheque_approvals', 'approval_settings')
    ''');
  }

  static Future<void> _upgradeLocalSyncStateForApprovalFix(AppDatabase db) async {
    // The current approval model is aabm_approval_requests. Legacy
    // approval tables are not part of this schema and
    // must never be queried during startup or synchronization.
    await SyncFoundation.setState(db, 'approval_sync_identity_v10', '1');
  }

  // -------------------------------------------------------------------------
  // LOCAL SCAN
  // -------------------------------------------------------------------------

  static Future<String?> _scanLocalDatabase(AppDatabase db) async {
    final localDevice = await SyncFoundation.getDeviceId(db);
    final failures = <String>[];

    for (final table in _tables) {
      // Approval entities are written directly to the outbox by
      // WorkflowService. Scanning them as ordinary Drift tables would create
      // duplicate events and can race with approval state changes.
      if (table == 'aabm_approval_request' || table == 'aabm_approval_settings') {
        continue;
      }
      try {
        await _scanLocalTable(db, table, localDevice);
      } catch (e, stack) {
        failures.add('$table: $e');
        debugPrint('[AABM SYNC] Local scan failed for $table: $e');
        debugPrint('$stack');
      }
    }

    final error = failures.isEmpty ? null : failures.join(' | ');
    await SyncFoundation.setState(db, 'last_scan_error', error ?? '');
    return error;
  }

  static Future<void> _scanLocalTable(
    AppDatabase db,
    String table,
    String localDevice,
  ) async {
    final meta = await _getTableMeta(db, table);
    if (meta == null || meta.primaryKeys.length != 1) return;
    final pk = meta.primaryKeys.single;

    final rows = await db.customSelect('SELECT * FROM "$table"').get();
    final mappingsRows = await db.customSelect(
      '''SELECT source_device_id, source_record_id, local_record_id, row_hash, deleted
         FROM aabm2_sync_map WHERE entity = ?''',
      variables: [Variable<String>(table)],
    ).get();

    final byLocalId = <String, Map<String, dynamic>>{};
    for (final row in mappingsRows) {
      final localId = row.read<String>('local_record_id');
      final existing = byLocalId[localId];
      if (existing == null ||
          (existing['source_device_id']?.toString() != localDevice &&
              row.read<String>('source_device_id') == localDevice)) {
        byLocalId[localId] = row.data;
      }
    }

    final seen = <String>{};
    for (final row in rows) {
      final localId = _keyString(row.data[pk]);
      if (localId == null) continue;
      seen.add(localId);

      final payload = Map<String, dynamic>.from(row.data);
      final hash = _hashPayload(payload);
      final existing = byLocalId[localId];

      if (existing == null) {
        await _createLocalMapAndQueue(
          db,
          entity: table,
          sourceDeviceId: localDevice,
          sourceRecordId: localId,
          localRecordId: localId,
          hash: hash,
          payload: payload,
        );
        continue;
      }

      final existingHash = existing['row_hash']?.toString();
      final deleted = existing['deleted'] == 1;
      if (!deleted && existingHash == hash) continue;

      if (deleted) {
        await db.customStatement(
          '''DELETE FROM aabm2_sync_map
             WHERE entity = ? AND source_device_id = ? AND source_record_id = ?''',
          [table, existing['source_device_id'], existing['source_record_id']],
        );
        await _createLocalMapAndQueue(
          db,
          entity: table,
          sourceDeviceId: localDevice,
          sourceRecordId: localId,
          localRecordId: localId,
          hash: hash,
          payload: payload,
        );
        continue;
      }

      final sourceDevice = existing['source_device_id'].toString();
      final sourceRecord = existing['source_record_id'].toString();
      if (await _hasPendingForLogicalRecord(db, table, sourceDevice, sourceRecord)) {
        continue;
      }

      final syncPayload = await _withForeignKeyMetadata(db, table, payload);
      await db.transaction(() async {
        await SyncFoundation.enqueueChange(
          db,
          entity: table,
          recordId: sourceRecord,
          operation: 'UPDATE',
          payload: <String, dynamic>{
            ...syncPayload,
            '_sync_source_device': sourceDevice,
            '_sync_source_record': sourceRecord,
          },
          actorUsername: _usernameFromRow(row.data),
        );
        await _updateMapHash(db, table, sourceDevice, sourceRecord, hash);
      });
    }

    // Explicit local deletions are propagated only for identities that already
    // existed in the local sync map. Missing rows on a fresh device are never
    // interpreted as deletions.
    for (final mapping in mappingsRows) {
      if (mapping.read<int>('deleted') == 1) continue;
      final localId = mapping.read<String>('local_record_id');
      if (seen.contains(localId)) continue;

      final sourceDevice = mapping.read<String>('source_device_id');
      final sourceRecord = mapping.read<String>('source_record_id');
      if (await _hasPendingForLogicalRecord(db, table, sourceDevice, sourceRecord)) continue;

      await db.transaction(() async {
        await SyncFoundation.enqueueChange(
          db,
          entity: table,
          recordId: sourceRecord,
          operation: 'DELETE',
          payload: <String, dynamic>{
            '_sync_source_device': sourceDevice,
            '_sync_source_record': sourceRecord,
            'deletedLocalRecordId': localId,
          },
        );
        await _markMapDeleted(db, table, sourceDevice, sourceRecord);
      });
    }
  }

  static Future<void> _createLocalMapAndQueue(
    AppDatabase db, {
    required String entity,
    required String sourceDeviceId,
    required String sourceRecordId,
    required String localRecordId,
    required String hash,
    required Map<String, dynamic> payload,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final syncPayload = await _withForeignKeyMetadata(db, entity, payload);

    // Mapping and outbox creation must succeed or fail together. Otherwise a
    // crash after mapping insertion can make the next scan believe the row was
    // already queued and silently lose the CREATE event.
    await db.transaction(() async {
      await db.customStatement(
        '''INSERT INTO aabm2_sync_map
           (entity, source_device_id, source_record_id, local_record_id, row_hash, deleted, updated_at)
           VALUES (?, ?, ?, ?, ?, 0, ?)
           ON CONFLICT(entity, source_device_id, source_record_id) DO UPDATE SET
             local_record_id = excluded.local_record_id,
             row_hash = excluded.row_hash,
             deleted = 0,
             updated_at = excluded.updated_at''',
        [entity, sourceDeviceId, sourceRecordId, localRecordId, hash, now],
      );
      await SyncFoundation.enqueueChange(
        db,
        entity: entity,
        recordId: sourceRecordId,
        operation: 'CREATE',
        payload: <String, dynamic>{
          ...syncPayload,
          '_sync_source_device': sourceDeviceId,
          '_sync_source_record': sourceRecordId,
        },
        actorUsername: _usernameFromRow(payload),
      );
    });
  }

  static Future<Map<String, dynamic>> _withForeignKeyMetadata(
    AppDatabase db,
    String entity,
    Map<String, dynamic> payload,
  ) async {
    final result = Map<String, dynamic>.from(payload);
    final metadata = <String, dynamic>{};
    final fks = await db.customSelect('PRAGMA foreign_key_list("$entity")').get();

    for (final fk in fks) {
      final from = fk.read<String>('from');
      final toTable = fk.read<String>('table');
      final value = payload[from];
      final localRecordId = _keyString(value);
      if (localRecordId == null) continue;

      final rows = await db.customSelect(
        '''SELECT source_device_id, source_record_id, deleted
           FROM aabm2_sync_map
           WHERE entity = ? AND local_record_id = ?
           ORDER BY deleted ASC
           LIMIT 1''',
        variables: [
          Variable<String>(toTable),
          Variable<String>(localRecordId),
        ],
      ).get();

      if (rows.isEmpty) continue;
      final row = rows.first;
      if (row.read<int>('deleted') == 1) continue;
      metadata[from] = <String, dynamic>{
        'sourceDeviceId': row.read<String>('source_device_id'),
        'sourceRecordId': row.read<String>('source_record_id'),
      };
    }

    if (metadata.isNotEmpty) result['_sync_fk'] = metadata;
    return result;
  }

  // -------------------------------------------------------------------------
  // UPLOAD
  // -------------------------------------------------------------------------

  static Future<void> _uploadPending(AppDatabase db) async {
    while (true) {
      final changes = await SyncFoundation.getPendingChanges(
        db,
        limit: uploadBatchSize,
      );
      if (changes.isEmpty) return;

      try {
        final batch = _firestore.batch();
        for (final change in changes) {
          final changeId = change['changeId'] as String;
          batch.set(
            _firestore.collection(collectionName).doc(changeId),
            <String, dynamic>{
              'protocolVersion': protocolVersion,
              'changeId': changeId,
              'entity': change['entity'],
              'recordId': change['recordId'],
              'operation': change['operation'],
              'payload': change['payload'],
              'actorUsername': change['actorUsername'],
              'sourceDeviceId': change['deviceId'],
              'createdAt': firestore.FieldValue.serverTimestamp(),
            },
          );
        }
        await batch.commit();
        for (final change in changes) {
          await SyncFoundation.markUploaded(db, change['changeId'] as String);
        }
      } catch (batchError) {
        debugPrint('[AABM SYNC] Batch upload failed; isolating records: $batchError');
        for (final change in changes) {
          final changeId = change['changeId'] as String;
          try {
            await _firestore.collection(collectionName).doc(changeId).set(
              <String, dynamic>{
                'protocolVersion': protocolVersion,
                'changeId': changeId,
                'entity': change['entity'],
                'recordId': change['recordId'],
                'operation': change['operation'],
                'payload': change['payload'],
                'actorUsername': change['actorUsername'],
                'sourceDeviceId': change['deviceId'],
                'createdAt': firestore.FieldValue.serverTimestamp(),
              },
            );
            await SyncFoundation.markUploaded(db, changeId);
          } catch (e) {
            await SyncFoundation.markFailed(
              db,
              changeId: changeId,
              error: e.toString(),
            );
            debugPrint('[AABM SYNC] Upload failed for $changeId: $e');
          }
        }
      }
    }
  }

  // -------------------------------------------------------------------------
  // DOWNLOAD
  // -------------------------------------------------------------------------

  static Future<void> _downloadRemote(AppDatabase db) async {
    final last = await SyncFoundation.getState(db, 'last_remote_sync_at');
    final cursor = last == null ? null : DateTime.tryParse(last)?.toUtc();
    final lowerBound = cursor == null
        ? null
        : firestore.Timestamp.fromDate(
            cursor.subtract(const Duration(minutes: 2)),
          );

    firestore.Query<Map<String, dynamic>> query = _firestore
        .collection(collectionName)
        .orderBy('createdAt')
        .limit(pageSize);
    if (lowerBound != null) {
      query = query.where('createdAt', isGreaterThanOrEqualTo: lowerBound);
    }

    firestore.DocumentSnapshot<Map<String, dynamic>>? lastDoc;
    DateTime? newestSeen;

    while (true) {
      var pageQuery = query;
      if (lastDoc != null) {
        pageQuery = pageQuery.startAfterDocument(lastDoc);
      }
      final snapshot = await pageQuery.get();
      if (snapshot.docs.isEmpty) break;

      final docs = snapshot.docs.toList()..sort(_compareRemoteDocs);
      for (final doc in docs) {
        final data = doc.data() ?? <String, dynamic>{};
        final changeId = (data['changeId'] ?? doc.id).toString();
        final created = _timestampToDate(data['createdAt']);
        if (created != null &&
            (newestSeen == null || created.isAfter(newestSeen!))) {
          newestSeen = created;
        }
        if (await _isQuarantined(db, changeId)) {
          debugPrint('[AABM SYNC] Skipping quarantined remote change $changeId');
          continue;
        }
        try {
          await _applyRemoteChange(db, data, changeId);
          await _clearRemoteFailure(db, changeId);
        } catch (e) {
          await _recordRemoteFailure(db, changeId, e.toString());
          debugPrint('[AABM SYNC] Remote change $changeId failed: $e');
        }
      }

      lastDoc = snapshot.docs.last;
      if (snapshot.docs.length < pageSize) break;
    }

    if (newestSeen != null) {
      await SyncFoundation.setState(
        db,
        'last_remote_sync_at',
        newestSeen!.toUtc().toIso8601String(),
      );
    }

    await _retryFailedRemote(db);
  }

  static Future<void> _downloadApprovalBackfill(AppDatabase db) async {
    final repairDone = await SyncFoundation.getState(db, 'aabm_approval_entity_repair_v1') == '1';
    final last = repairDone
        ? await SyncFoundation.getState(db, 'last_approval_sync_at')
        : null;
    final cursor = last == null || last.isEmpty ? null : DateTime.tryParse(last)?.toUtc();
    final lowerBound = cursor == null
        ? null
        : firestore.Timestamp.fromDate(cursor.subtract(const Duration(minutes: 10)));

    DateTime? newestSeen;
    const approvalEntities = <String>[
      'aabm_approval_request',
      'aabm_approval_settings',
    ];

    for (final approvalEntity in approvalEntities) {
      firestore.DocumentSnapshot<Map<String, dynamic>>? lastDoc;

      while (true) {
        // Query each entity separately and filter the timestamp client-side.
        // This avoids requiring a composite Firestore index for entity + time.
        firestore.Query<Map<String, dynamic>> query = _firestore
            .collection(collectionName)
            .where('entity', isEqualTo: approvalEntity)
            .limit(pageSize);
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc!);
        }

        final snapshot = await query.get();
        if (snapshot.docs.isEmpty) break;

        final docs = snapshot.docs.toList()..sort(_compareRemoteDocs);
        for (final doc in docs) {
          final data = doc.data();
          final changeId = (data['changeId'] ?? doc.id).toString();
          final created = _timestampToDate(data['createdAt']);
          if (lowerBound != null &&
              created != null &&
              created.isBefore(lowerBound.toDate())) {
            continue;
          }
          if (created != null &&
              (newestSeen == null || created.isAfter(newestSeen!))) {
            newestSeen = created;
          }
          if (await _isQuarantined(db, changeId)) {
            debugPrint('[AABM SYNC] Skipping quarantined approval change $changeId');
            continue;
          }
          try {
            await _applyRemoteChange(db, data, changeId);
            await _clearRemoteFailure(db, changeId);
          } catch (e) {
            await _recordRemoteFailure(db, changeId, e.toString());
            debugPrint('[AABM SYNC] Approval change $changeId failed: $e');
          }
        }

        lastDoc = snapshot.docs.last;
        if (snapshot.docs.length < pageSize) break;
      }
    }

    if (newestSeen != null) {
      await SyncFoundation.setState(
        db,
        'last_approval_sync_at',
        newestSeen!.toUtc().toIso8601String(),
      );
    }
    await SyncFoundation.setState(db, 'aabm_approval_entity_repair_v1', '1');
  }

  static const int _maxRemoteApplyAttempts = 5;

  static Future<bool> _isQuarantined(AppDatabase db, String changeId) async {
    final rows = await db.customSelect(
      'SELECT attempts FROM aabm2_sync_failures WHERE change_id = ? LIMIT 1',
      variables: [Variable<String>(changeId)],
    ).get();
    return rows.isNotEmpty && ((rows.first.data['attempts'] as num?)?.toInt() ?? 0) >= _maxRemoteApplyAttempts;
  }

  static Future<void> _recordRemoteFailure(
    AppDatabase db,
    String changeId,
    String error,
  ) async {
    await db.customStatement(
      '''INSERT INTO aabm2_sync_failures
         (change_id, last_error, attempts, updated_at)
         VALUES (?, ?, 1, ?)
         ON CONFLICT(change_id) DO UPDATE SET
           last_error = excluded.last_error,
           attempts = aabm2_sync_failures.attempts + 1,
           updated_at = excluded.updated_at''',
      [changeId, error, DateTime.now().toUtc().toIso8601String()],
    );
  }

  static Future<void> _clearRemoteFailure(
    AppDatabase db,
    String changeId,
  ) async {
    await db.customStatement(
      'DELETE FROM aabm2_sync_failures WHERE change_id = ?',
      [changeId],
    );
  }

  static Future<void> _retryFailedRemote(AppDatabase db) async {
    final rows = await db.customSelect(
      'SELECT change_id, attempts FROM aabm2_sync_failures WHERE attempts < ? ORDER BY updated_at ASC LIMIT 5',
      variables: [Variable<int>(_maxRemoteApplyAttempts)],
    ).get();

    for (final row in rows) {
      final changeId = row.data['change_id']?.toString() ?? '';
      if (changeId.isEmpty) continue;
      try {
        final doc = await _firestore.collection(collectionName).doc(changeId).get();
        if (!doc.exists) {
          await _clearRemoteFailure(db, changeId);
          continue;
        }
        final data = doc.data() ?? <String, dynamic>{};
        await _applyRemoteChange(db, data, changeId);
        await _clearRemoteFailure(db, changeId);
      } catch (e) {
        await _recordRemoteFailure(db, changeId, e.toString());
        debugPrint('[AABM SYNC] Retry failed for remote change $changeId: $e');
      }
    }

    // Quarantine permanently failing events instead of hammering Firebase and
    // SQLite on every five-second cycle. The row remains available for later
    // diagnostics but is no longer retried automatically.
    await db.customStatement(
      '''UPDATE aabm2_sync_failures
         SET last_error = last_error || ' [QUARANTINED AFTER MAX RETRIES]'
         WHERE attempts >= ?
           AND last_error NOT LIKE '%[QUARANTINED AFTER MAX RETRIES]%' ''',
      [_maxRemoteApplyAttempts],
    );
  }

  static int _compareRemoteDocs(
    firestore.DocumentSnapshot<Map<String, dynamic>> a,
    firestore.DocumentSnapshot<Map<String, dynamic>> b,
  ) {
    final ad = a.data() ?? <String, dynamic>{};
    final bd = b.data() ?? <String, dynamic>{};
    final at = _timestampToDate(ad['createdAt']);
    final bt = _timestampToDate(bd['createdAt']);
    final timeCompare = (at ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(
      bt ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
    if (timeCompare != 0) return timeCompare;

    final ai = _tables.indexOf(ad['entity']?.toString() ?? '');
    final bi = _tables.indexOf(bd['entity']?.toString() ?? '');
    if (ai != bi) return (ai < 0 ? 999 : ai).compareTo(bi < 0 ? 999 : bi);
    return (ad['changeId']?.toString() ?? a.id).compareTo(bd['changeId']?.toString() ?? b.id);
  }

static Future<void> _applyRemoteChange(
    AppDatabase db,
    Map<String, dynamic> data,
    String changeId,
  ) async {
    final sourceDevice = (data['sourceDeviceId'] ?? '').toString();
    final ownDevice = await SyncFoundation.getDeviceId(db);

    final entity = (data['entity'] ?? '').toString();
    final recordId = (data['recordId'] ?? '').toString();
    final operation = (data['operation'] ?? '').toString().toUpperCase();
    final rawPayload = data['payload'];

    // Older builds could mark an approval event as received even though the
    // corresponding local approval row was never created. Re-open those
    // receipts when the stable workflow mapping is missing. This is especially
    // important for aabm_approval_request: the previous sync engine did not
    // recognize that entity and therefore consumed its Firestore event.
    if (await SyncFoundation.hasReceived(db, changeId)) {
      if (entity == 'aabm_approval_request' && rawPayload is Map) {
        final approvalPayload = Map<String, dynamic>.from(rawPayload);
        final stable = approvalPayload['_aabm_source_record']?.toString() ?? recordId;
        final source = approvalPayload['_aabm_source_device']?.toString() ?? sourceDevice;
        final mapped = await _findMapBySource(
          db,
          'aabm_approval_request',
          source,
          stable,
        );
        if (mapped != null && mapped['deleted'] != 1) return;
        await _clearReceivedChange(db, changeId);
      } else if (entity == 'aabm_approval_settings') {
        // The setting event may also have been consumed by the previous engine.
        // Let the timestamp-aware handler reconcile it again.
        await _clearReceivedChange(db, changeId);
      } else {
        return;
      }
    }

    if (sourceDevice.isEmpty || entity.isEmpty || recordId.isEmpty || rawPayload is! Map) {
      // Malformed/legacy document: mark it consumed so it doesn't block the
      // whole feed forever.
      await SyncFoundation.markReceived(db, changeId: changeId, sourceDeviceId: sourceDevice);
      return;
    }
    if (!_tables.contains(entity)) {
      await SyncFoundation.markReceived(db, changeId: changeId, sourceDeviceId: sourceDevice);
      return;
    }

    // Own changes are already applied locally. They only need deduplication.
    if (sourceDevice == ownDevice) {
      await SyncFoundation.markReceived(db, changeId: changeId, sourceDeviceId: sourceDevice);
      return;
    }

    // One-approver workflow entities are handled separately because
    // WorkflowService writes them directly to the SyncFoundation outbox.
    if (entity == 'aabm_approval_settings') {
      await _applyRemoteAabmApprovalSettings(db, rawPayload, changeId, sourceDevice);
      return;
    }
    if (entity == 'aabm_approval_request') {
      await _applyRemoteAabmApprovalRequest(db, data, changeId);
      return;
    }

    final incoming = _encodeMap(Map<String, dynamic>.from(rawPayload));
    final logicalSourceDevice = _syncMeta(incoming, 'source_device')?.toString() ?? sourceDevice;
    final logicalRecordId = _syncMeta(incoming, 'source_record')?.toString() ?? recordId;
    _removeSyncMeta(incoming, 'source_device');
    _removeSyncMeta(incoming, 'source_record');
    _removeSyncMeta(incoming, 'logical_record');
    _removeSyncMeta(incoming, 'transaction_source_device');
    _removeSyncMeta(incoming, 'transaction_source_record');

    if (await _hasPendingForLogicalRecord(db, entity, logicalSourceDevice, logicalRecordId)) {
      await SyncFoundation.addConflict(
        db,
        entity: entity,
        recordId: logicalRecordId,
        localChangeId: await _pendingChangeId(db, entity, logicalSourceDevice, logicalRecordId),
        remoteChangeId: changeId,
        remotePayload: incoming,
      );
      // A conflict is a successfully consumed remote event. Otherwise the
      // same event would create duplicate conflict rows forever.
      await SyncFoundation.markReceived(db, changeId: changeId, sourceDeviceId: sourceDevice);
      return;
    }

    try {
      await db.transaction(() async {
        final meta = await _getTableMeta(db, entity);
        if (meta == null || meta.primaryKeys.length != 1) {
          throw StateError('Unsupported sync table: $entity');
        }
        final pk = meta.primaryKeys.single;
        final map = await _findMapBySource(db, entity, logicalSourceDevice, logicalRecordId);

        if (operation == 'DELETE') {
          if (map != null) {
            final localId = map['local_record_id'].toString();
            await db.customStatement(
              'DELETE FROM "$entity" WHERE "$pk" = ?',
              [_sqlValue(localId)],
            );
            await _markMapDeleted(db, entity, logicalSourceDevice, logicalRecordId);
          }
          return;
        }

        final values = await _resolveForeignKeys(
          db,
          entity,
          incoming,
          logicalSourceDevice,
        );
        _coerceRemoteDateTimeValues(entity, values);
        final existingLocalId = map?['local_record_id']?.toString();

        if (existingLocalId != null) {
          values.remove(pk);

          // A remote row can have a different local integer id but the same
          // business key as an existing local row. household_months is the
          // current schema's only composite UNIQUE key. Resolve that collision
          // BEFORE issuing UPDATE, rather than waiting for SQLite to throw.
          final conflictId = await _findUniqueConflictLocalId(
            db,
            entity,
            pk,
            values,
          );

          var targetLocalId = existingLocalId;
          if (conflictId != null && conflictId != existingLocalId) {
            if (entity == 'household_months') {
              await _mergeHouseholdMonthRows(
                db,
                oldLocalId: existingLocalId,
                canonicalLocalId: conflictId,
              );
              targetLocalId = conflictId;
            } else {
              // Defensive fallback for future UNIQUE keys. Keep the existing
              // row intact and apply the remote values to the row that owns the
              // unique business key.
              targetLocalId = conflictId;
            }
          }

          if (values.isNotEmpty) {
            final columns = values.keys.toList();
            final assignments = columns.map((c) => '"$c" = ?').join(', ');
            final args = columns.map((c) => _sqlValue(values[c])).toList();
            args.add(_sqlValue(targetLocalId));
            await db.customStatement(
              'UPDATE "$entity" SET $assignments WHERE "$pk" = ?',
              args,
            );
          }

          await _repointMapping(
            db,
            entity,
            logicalSourceDevice,
            logicalRecordId,
            targetLocalId,
            _hashPayload(incoming),
          );
        } else {
          final sourcePk = values.remove(pk);
          final columns = values.keys.toList();
          final args = columns.map((c) => _sqlValue(values[c])).toList();
          String localId;

          try {
            if (_isAutoIncrementIntegerPk(meta, pk)) {
              final placeholders = List<String>.filled(columns.length, '?').join(', ');
              await db.customStatement(
                'INSERT INTO "$entity" (${columns.map((c) => '"$c"').join(', ')}) VALUES ($placeholders)',
                args,
              );
              final inserted = await db.customSelect('SELECT last_insert_rowid() AS id').getSingle();
              localId = inserted.data['id'].toString();
            } else {
              if (sourcePk == null) throw StateError('Missing primary key for $entity/$logicalRecordId');
              columns.add(pk);
              args.add(_sqlValue(sourcePk));
              final placeholders = List<String>.filled(columns.length, '?').join(', ');
              await db.customStatement(
                'INSERT INTO "$entity" (${columns.map((c) => '"$c"').join(', ')}) VALUES ($placeholders)',
                args,
              );
              localId = sourcePk.toString();
            }
          } on Exception catch (e) {
            if (!_isUniqueConstraintError(e)) rethrow;
            final conflictId = await _findUniqueConflictLocalId(
              db,
              entity,
              pk,
              values,
              primaryKeyValue: sourcePk,
            );
            if (conflictId == null) rethrow;
            localId = conflictId;
            // The row already exists locally under another source identity.
            // Treat it as the same logical row instead of creating a duplicate.
            final updateColumns = values.keys.toList();
            if (updateColumns.isNotEmpty) {
              final assignments = updateColumns.map((c) => '"$c" = ?').join(', ');
              final updateArgs = updateColumns.map((c) => _sqlValue(values[c])).toList();
              updateArgs.add(_sqlValue(localId));
              await db.customStatement(
                'UPDATE "$entity" SET $assignments WHERE "$pk" = ?',
                updateArgs,
              );
            }
          }

          await db.customStatement(
            '''INSERT OR REPLACE INTO aabm2_sync_map
               (entity, source_device_id, source_record_id, local_record_id, row_hash, deleted, updated_at)
               VALUES (?, ?, ?, ?, ?, 0, ?)''',
            [
              entity,
              logicalSourceDevice,
              logicalRecordId,
              localId,
              _hashPayload(incoming),
              DateTime.now().toUtc().toIso8601String(),
            ],
          );
        }
      });

      // CRITICAL: only mark received after the local transaction succeeded.
      await SyncFoundation.markReceived(db, changeId: changeId, sourceDeviceId: sourceDevice);
    } catch (e) {
      await SyncFoundation.setState(db, 'last_apply_error', '$entity/$logicalRecordId: $e');
      rethrow;
    }
  }

  static Future<void> _applyRemoteAabmApprovalSettings(
    AppDatabase db,
    dynamic rawPayload,
    String changeId,
    String sourceDevice,
  ) async {
    if (rawPayload is! Map) {
      await SyncFoundation.markReceived(
        db,
        changeId: changeId,
        sourceDeviceId: sourceDevice,
      );
      return;
    }

    final incoming = _encodeMap(Map<String, dynamic>.from(rawPayload));
    final approver = incoming['approver_username']?.toString().trim() ?? '';
    final updatedAt = incoming['updated_at']?.toString() ?? '';
    if (approver.isEmpty || updatedAt.isEmpty) {
      await SyncFoundation.markReceived(
        db,
        changeId: changeId,
        sourceDeviceId: sourceDevice,
      );
      return;
    }

    final remoteTime = DateTime.tryParse(updatedAt);
    final localRows = await db.customSelect(
      'SELECT updated_at FROM aabm_approval_settings WHERE id = 1 LIMIT 1',
    ).get();
    final localTime = localRows.isEmpty
        ? null
        : DateTime.tryParse(localRows.first.data['updated_at']?.toString() ?? '');

    if (localRows.isEmpty ||
        remoteTime == null ||
        localTime == null ||
        remoteTime.isAfter(localTime)) {
      await db.customStatement(
        '''INSERT INTO aabm_approval_settings(id, approver_username, updated_at)
           VALUES (1, ?, ?)
           ON CONFLICT(id) DO UPDATE SET
             approver_username = excluded.approver_username,
             updated_at = excluded.updated_at''',
        [approver, updatedAt],
      );
    }

    await SyncFoundation.markReceived(
      db,
      changeId: changeId,
      sourceDeviceId: sourceDevice,
    );
  }

  static Future<void> _applyRemoteAabmApprovalRequest(
    AppDatabase db,
    Map<String, dynamic> data,
    String changeId,
  ) async {
    final sourceDevice = (data['sourceDeviceId'] ?? '').toString();
    final ownDevice = await SyncFoundation.getDeviceId(db);
    final rawPayload = data['payload'];
    final operation = (data['operation'] ?? '').toString().toUpperCase();

    if (sourceDevice.isEmpty || rawPayload is! Map) {
      await SyncFoundation.markReceived(
        db,
        changeId: changeId,
        sourceDeviceId: sourceDevice,
      );
      return;
    }
    if (sourceDevice == ownDevice) {
      await SyncFoundation.markReceived(
        db,
        changeId: changeId,
        sourceDeviceId: sourceDevice,
      );
      return;
    }
    if (await SyncFoundation.hasReceived(db, changeId)) return;

    final incoming = _encodeMap(Map<String, dynamic>.from(rawPayload));
    final sourceTable = incoming['source_table']?.toString().trim() ?? '';
    final rawTransactionId = incoming['transaction_id'];
    final parentDevice = incoming['_aabm_parent_device']?.toString().trim() ?? '';
    final parentRecord = incoming['_aabm_parent_record']?.toString().trim() ?? '';
    final logicalSourceDevice =
        incoming['_aabm_source_device']?.toString().trim().isNotEmpty == true
            ? incoming['_aabm_source_device']!.toString().trim()
            : (parentDevice.isNotEmpty ? parentDevice : sourceDevice);
    final logicalRecordId =
        incoming['_aabm_source_record']?.toString().trim().isNotEmpty == true
            ? incoming['_aabm_source_record']!.toString().trim()
            : (data['recordId'] ?? '').toString();

    if (sourceTable.isEmpty ||
        rawTransactionId == null ||
        parentDevice.isEmpty ||
        parentRecord.isEmpty ||
        logicalRecordId.isEmpty) {
      await SyncFoundation.markReceived(
        db,
        changeId: changeId,
        sourceDeviceId: sourceDevice,
      );
      return;
    }

    try {
      await db.transaction(() async {
        if (operation == 'DELETE') {
          final existingMap = await _findMapBySource(
            db,
            'aabm_approval_request',
            logicalSourceDevice,
            logicalRecordId,
          );
          var deletedLocalRow = false;

          if (existingMap != null && existingMap['deleted'] != 1) {
            final localId = int.tryParse(existingMap['local_record_id']?.toString() ?? '');
            if (localId != null) {
              await db.customStatement(
                'DELETE FROM aabm_approval_requests WHERE id = ?',
                [localId],
              );
              deletedLocalRow = true;
            }
          }

          // Repair path for approvals created by an older sync build: the
          // local row may exist even though its active aabm2_sync_map entry is
          // missing. The source table + local transaction id is still the
          // authoritative local business key.
          if (!deletedLocalRow) {
            final localTransactionId = int.tryParse(rawTransactionId.toString());
            if (localTransactionId != null) {
              await db.customStatement(
                'DELETE FROM aabm_approval_requests WHERE source_table = ? AND transaction_id = ?',
                [sourceTable, localTransactionId],
              );
            }
          }

          if (existingMap != null) {
            await _markMapDeleted(
              db,
              'aabm_approval_request',
              logicalSourceDevice,
              logicalRecordId,
            );
          }
          return;
        }

        Map<String, dynamic>? parentMap = await _findMapBySource(
          db,
          sourceTable,
          parentDevice,
          parentRecord,
        );

        final remoteTransactionKey = _keyString(rawTransactionId);
        if (parentMap == null || parentMap['deleted'] == 1) {
          if (remoteTransactionKey != null) {
            final meta = await _getTableMeta(db, sourceTable);
            if (meta != null && meta.primaryKeys.length == 1) {
              final pk = meta.primaryKeys.single;
              final rows = await db.customSelect(
                'SELECT "$pk" FROM "$sourceTable" WHERE "$pk" = ${_sqlLiteral(_sqlValue(rawTransactionId))} LIMIT 1',
              ).get();
              if (rows.isNotEmpty) {
                parentMap = <String, dynamic>{
                  'local_record_id': rows.first.data[pk].toString(),
                  'source_device_id': parentDevice,
                  'source_record_id': parentRecord,
                  'deleted': 0,
                };
              }
            }
          }
        }

        if (parentMap == null || parentMap['deleted'] == 1) {
          parentMap = await _ensureRemoteDependency(
            db,
            entity: sourceTable,
            sourceDevice: parentDevice,
            sourceRecordId: parentRecord,
          );
        }

        final localTransactionId = _coerceForOriginal(
          parentMap['local_record_id'].toString(),
          rawTransactionId,
        );
        final requestedAt = incoming['requested_at']?.toString() ??
            DateTime.now().toUtc().toIso8601String();
        final approvedAt = incoming['approved_at']?.toString();
        final rejectedAt = incoming['rejected_at']?.toString();

        final existingRows = await db.customSelect(
          '''SELECT * FROM aabm_approval_requests
             WHERE source_table = ? AND transaction_id = ? LIMIT 1''',
          variables: [
            Variable<String>(sourceTable),
            Variable<int>(int.tryParse(localTransactionId.toString()) ?? -1),
          ],
        ).get();

        Map<String, dynamic> finalRow;
        if (existingRows.isEmpty) {
          await db.customStatement(
            '''INSERT INTO aabm_approval_requests
               (source_table, transaction_id, status, requested_by, requested_at,
                approved_by, approved_at, rejected_by, rejected_at, rejection_reason)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
            [
              sourceTable,
              localTransactionId,
              incoming['status']?.toString() ?? 'PENDING',
              incoming['requested_by']?.toString() ?? '',
              requestedAt,
              incoming['approved_by']?.toString(),
              approvedAt,
              incoming['rejected_by']?.toString(),
              rejectedAt,
              incoming['rejection_reason']?.toString(),
            ],
          );
        } else {
          final local = Map<String, dynamic>.from(existingRows.first.data);
          final localStatus = local['status']?.toString() ?? 'PENDING';
          final remoteStatus = incoming['status']?.toString() ?? 'PENDING';
          final localRequestedAt = DateTime.tryParse(local['requested_at']?.toString() ?? '');
          final remoteRequestedAt = DateTime.tryParse(requestedAt);
          final localApprovedAt = DateTime.tryParse(local['approved_at']?.toString() ?? '');
          final remoteApprovedAt = DateTime.tryParse(approvedAt ?? '');
          final localRejectedAt = DateTime.tryParse(local['rejected_at']?.toString() ?? '');
          final remoteRejectedAt = DateTime.tryParse(rejectedAt ?? '');

          final merged = <String, dynamic>{
            'requested_by': local['requested_by'],
            'requested_at': local['requested_at'],
            'status': localStatus,
            'approved_by': local['approved_by'],
            'approved_at': local['approved_at'],
            'rejected_by': local['rejected_by'],
            'rejected_at': local['rejected_at'],
            'rejection_reason': local['rejection_reason'],
          };

          if (remoteRequestedAt != null &&
              (localRequestedAt == null || remoteRequestedAt.isAfter(localRequestedAt))) {
            merged['requested_by'] = incoming['requested_by']?.toString() ?? '';
            merged['requested_at'] = requestedAt;
          }

          if (remoteStatus == 'APPROVED' &&
              (localStatus != 'APPROVED' ||
                  (remoteApprovedAt != null &&
                      (localApprovedAt == null || remoteApprovedAt.isAfter(localApprovedAt))))) {
            merged['status'] = 'APPROVED';
            merged['approved_by'] = incoming['approved_by']?.toString();
            merged['approved_at'] = approvedAt;
            merged['rejected_by'] = null;
            merged['rejected_at'] = null;
            merged['rejection_reason'] = null;
          } else if (remoteStatus == 'REJECTED' &&
              localStatus != 'APPROVED' &&
              (localStatus != 'REJECTED' ||
                  (remoteRejectedAt != null &&
                      (localRejectedAt == null || remoteRejectedAt.isAfter(localRejectedAt))))) {
            merged['status'] = 'REJECTED';
            merged['rejected_by'] = incoming['rejected_by']?.toString();
            merged['rejected_at'] = rejectedAt;
            merged['rejection_reason'] = incoming['rejection_reason']?.toString();
            merged['approved_by'] = null;
            merged['approved_at'] = null;
          }

          await db.customStatement(
            '''UPDATE aabm_approval_requests SET
               requested_by = ?, requested_at = ?, status = ?,
               approved_by = ?, approved_at = ?, rejected_by = ?,
               rejected_at = ?, rejection_reason = ?
               WHERE id = ?''',
            [
              merged['requested_by'],
              merged['requested_at'],
              merged['status'],
              merged['approved_by'],
              merged['approved_at'],
              merged['rejected_by'],
              merged['rejected_at'],
              merged['rejection_reason'],
              local['id'],
            ],
          );
        }

        finalRow = (await db.customSelect(
          '''SELECT * FROM aabm_approval_requests
             WHERE source_table = ? AND transaction_id = ? LIMIT 1''',
          variables: [
            Variable<String>(sourceTable),
            Variable<int>(int.tryParse(localTransactionId.toString()) ?? -1),
          ],
        ).getSingle()).data;

        final hash = _hashPayload(<String, dynamic>{
          ...finalRow,
          'transaction_id': logicalRecordId,
        });
        await _repointMapping(
          db,
          'aabm_approval_request',
          logicalSourceDevice,
          logicalRecordId,
          finalRow['id'].toString(),
          hash,
        );
      });

      await SyncFoundation.markReceived(
        db,
        changeId: changeId,
        sourceDeviceId: sourceDevice,
      );
    } catch (e) {
      await SyncFoundation.setState(
        db,
        'last_apply_error',
        'aabm_approval_request/$logicalRecordId: $e',
      );
      rethrow;
    }
  }

  // -------------------------------------------------------------------------
  // FOREIGN KEYS / TABLE METADATA
  // -------------------------------------------------------------------------

  static Future<_TableMeta?> _getTableMeta(AppDatabase db, String table) async {
    final cached = _metaCache[table];
    if (cached != null) return cached;

    final info = await db.customSelect('PRAGMA table_info("$table")').get();
    if (info.isEmpty) return null;
    final columns = info.map((r) => r.read<String>('name')).toList();
    final pkRows = info.where((r) => r.read<int>('pk') > 0).toList()
      ..sort((a, b) => a.read<int>('pk').compareTo(b.read<int>('pk')));
    final meta = _TableMeta(
      columns: columns,
      primaryKeys: pkRows.map((r) => r.read<String>('name')).toList(),
      integerPrimaryKey: pkRows.length == 1 &&
          pkRows.single.read<String>('name') == 'id' &&
          pkRows.single.read<String>('type').toUpperCase().contains('INT'),
    );
    _metaCache[table] = meta;
    return meta;
  }

  static bool _isAutoIncrementIntegerPk(_TableMeta meta, String pk) {
    return meta.integerPrimaryKey && pk == 'id';
  }

  static Future<Map<String, dynamic>?> _findMapBySource(
    AppDatabase db,
    String entity,
    String sourceDevice,
    String sourceId,
  ) async {
    final rows = await db.customSelect(
      '''SELECT source_device_id, source_record_id, local_record_id, row_hash, deleted
         FROM aabm2_sync_map
         WHERE entity = ? AND source_device_id = ? AND source_record_id = ?
         LIMIT 1''',
      variables: [
        Variable<String>(entity),
        Variable<String>(sourceDevice),
        Variable<String>(sourceId),
      ],
    ).get();
    return rows.isEmpty ? null : rows.first.data;
  }

  static bool _isUniqueConstraintError(Object error) {
    return error.toString().toLowerCase().contains('unique constraint failed');
  }

  static Future<void> _mergeHouseholdMonthRows(
    AppDatabase db, {
    required String oldLocalId,
    required String canonicalLocalId,
  }) async {
    if (oldLocalId == canonicalLocalId) return;

    // household_months has two dependent allocation tables. Move those child
    // rows to the canonical month before removing the duplicate month row.
    // Neither allocation table has a UNIQUE key on household_month_id, so this
    // re-parenting is deterministic and preserves the existing transactions.
    await db.customStatement(
      'UPDATE "payment_allocations" SET "household_month_id" = ? '
      'WHERE "household_month_id" = ?',
      [_sqlValue(canonicalLocalId), _sqlValue(oldLocalId)],
    );
    await db.customStatement(
      'UPDATE "household_concession_allocations" SET "household_month_id" = ? '
      'WHERE "household_month_id" = ?',
      [_sqlValue(canonicalLocalId), _sqlValue(oldLocalId)],
    );

    await db.customStatement(
      'DELETE FROM "household_months" WHERE "id" = ?',
      [_sqlValue(oldLocalId)],
    );
  }

  static Future<String?> _findUniqueConflictLocalId(
    AppDatabase db,
    String entity,
    String pk,
    Map<String, dynamic> values, {
    dynamic primaryKeyValue,
  }) async {
    // If the INSERT failed because the primary-key value already exists,
    // resolve that exact row first. This is important for side tables such as
    // qarza_parentage and qarza_conditions, where the primary key is the
    // business/document number and was removed from `values` before INSERT.
    if (primaryKeyValue != null) {
      final rows = await db.customSelect(
        'SELECT "$pk" FROM "$entity" WHERE "$pk" = ${_sqlLiteral(_sqlValue(primaryKeyValue))} LIMIT 1',
      ).get();
      if (rows.isNotEmpty) return rows.first.data[pk]?.toString();
    }

    // Drift declares the only application-level UNIQUE key currently in the
    // database explicitly on HouseholdMonths. Resolve it directly first.
    // This avoids relying on SQLite's generated auto-index metadata, which can
    // differ between native SQLite and sqlite3.wasm on the web.
    if (entity == 'household_months' &&
        values.containsKey('household_id') &&
        values.containsKey('year') &&
        values.containsKey('month')) {
      final householdId = _sqlLiteral(_sqlValue(values['household_id']));
      final year = _sqlLiteral(_sqlValue(values['year']));
      final month = _sqlLiteral(_sqlValue(values['month']));
      final rows = await db.customSelect(
        'SELECT "$pk" FROM "household_months" '
        'WHERE "household_id" = $householdId '
        'AND "year" = $year AND "month" = $month LIMIT 1',
      ).get();
      if (rows.isNotEmpty) return rows.first.data[pk]?.toString();
    }

    final indexes = await db.customSelect('PRAGMA index_list("$entity")').get();
    for (final index in indexes) {
      if (index.read<int>('unique') != 1) continue;
      final indexName = index.read<String>('name');
      final columns = await db.customSelect('PRAGMA index_info("$indexName")').get();
      if (columns.isEmpty) continue;
      final names = columns
          .map((r) => r.data['name']?.toString())
          .whereType<String>()
          .toList();
      if (names.isEmpty || names.any((name) => !values.containsKey(name))) continue;

      final args = <dynamic>[];
      var usable = true;
      for (final name in names) {
        final value = values[name];
        if (value == null) {
          // SQLite UNIQUE permits multiple NULLs, so a NULL-containing key
          // cannot identify the conflicting row reliably.
          usable = false;
          break;
        }
        args.add(_sqlValue(value));
      }
      if (!usable) continue;

      final literalPredicates = <String>[];
      for (var i = 0; i < names.length; i++) {
        literalPredicates.add('"${names[i]}" = ${_sqlLiteral(args[i])}');
      }

      final rows = await db.customSelect(
        'SELECT "$pk" FROM "$entity" WHERE ${literalPredicates.join(' AND ')} LIMIT 1',
      ).get();
      if (rows.isNotEmpty) return rows.first.data[pk]?.toString();
    }
    return null;
  }

  static String _sqlLiteral(dynamic value) {
    if (value == null) return 'NULL';
    if (value is bool) return value ? '1' : '0';
    if (value is num) return value.toString();
    if (value is Uint8List) {
      final hex = value.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      return "X'$hex'";
    }
    final text = value.toString().replaceAll("'", "''");
    return "'$text'";
  }

  static Future<void> _repointMapping(
    AppDatabase db,
    String entity,
    String sourceDevice,
    String sourceId,
    String localId,
    String hash,
  ) async {
    await db.customStatement(
      '''INSERT OR REPLACE INTO aabm2_sync_map
         (entity, source_device_id, source_record_id, local_record_id, row_hash, deleted, updated_at)
         VALUES (?, ?, ?, ?, ?, 0, ?)''',
      [entity, sourceDevice, sourceId, localId, hash, DateTime.now().toUtc().toIso8601String()],
    );
  }

  static Future<void> _updateMapHash(
    AppDatabase db,
    String entity,
    String sourceDevice,
    String sourceId,
    String hash,
  ) async {
    await db.customStatement(
      '''UPDATE aabm2_sync_map
         SET row_hash = ?, deleted = 0, updated_at = ?
         WHERE entity = ? AND source_device_id = ? AND source_record_id = ?''',
      [hash, DateTime.now().toUtc().toIso8601String(), entity, sourceDevice, sourceId],
    );
  }

  static Future<void> _markMapDeleted(
    AppDatabase db,
    String entity,
    String sourceDevice,
    String sourceId,
  ) async {
    await db.customStatement(
      '''UPDATE aabm2_sync_map SET deleted = 1, updated_at = ?
         WHERE entity = ? AND source_device_id = ? AND source_record_id = ?''',
      [DateTime.now().toUtc().toIso8601String(), entity, sourceDevice, sourceId],
    );
  }

  static Future<bool> _hasPendingForLogicalRecord(
    AppDatabase db,
    String entity,
    String sourceDevice,
    String sourceId,
  ) async {
    final rows = await db.customSelect(
      '''SELECT payload FROM aabm2_sync_outbox
         WHERE entity = ? AND record_id = ? AND state = 'PENDING'
         ORDER BY id DESC''',
      variables: [Variable<String>(entity), Variable<String>(sourceId)],
    ).get();
    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.read<String>('payload'));
        if (decoded is Map && _syncMeta(Map<String, dynamic>.from(decoded), 'source_device')?.toString() == sourceDevice) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  static Future<String?> _pendingChangeId(
    AppDatabase db,
    String entity,
    String sourceDevice,
    String sourceId,
  ) async {
    final rows = await db.customSelect(
      '''SELECT change_id, payload FROM aabm2_sync_outbox
         WHERE entity = ? AND record_id = ? AND state = 'PENDING'
         ORDER BY id DESC''',
      variables: [Variable<String>(entity), Variable<String>(sourceId)],
    ).get();
    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.read<String>('payload'));
        if (decoded is Map && _syncMeta(Map<String, dynamic>.from(decoded), 'source_device')?.toString() == sourceDevice) {
          return row.read<String>('change_id');
        }
      } catch (_) {}
    }
    return null;
  }

  static Future<Map<String, dynamic>> _resolveForeignKeys(
    AppDatabase db,
    String entity,
    Map<String, dynamic> source,
    String sourceDevice,
  ) async {
    final result = Map<String, dynamic>.from(source);
    final rawFk = source['_sync_fk'] ?? source['__sync_fk'];
    final fkMetadata = rawFk is Map
        ? Map<String, dynamic>.from(rawFk)
        : <String, dynamic>{};
    result.remove('_sync_fk'); result.remove('__sync_fk');

    final fks = await db.customSelect('PRAGMA foreign_key_list("$entity")').get();

    for (final fk in fks) {
      final from = fk.read<String>('from');
      final toTable = fk.read<String>('table');
      final value = result[from];
      if (value == null) continue;

      final metadata = fkMetadata[from];
      var dependencyDevice = sourceDevice;
      var dependencyRecordId = _keyString(value);
      if (metadata is Map) {
        dependencyDevice = metadata['sourceDeviceId']?.toString() ?? dependencyDevice;
        dependencyRecordId = metadata['sourceRecordId']?.toString() ?? dependencyRecordId;
      }
      if (dependencyRecordId == null) continue;

      Map<String, dynamic> mapped;
      try {
        mapped = await _ensureRemoteDependency(
          db,
          entity: toTable,
          sourceDevice: dependencyDevice,
          sourceRecordId: dependencyRecordId,
        );
      } catch (_) {
        final fallback = await _findAnyMapByLocalId(
          db,
          toTable,
          dependencyRecordId,
        );
        if (fallback == null) rethrow;
        mapped = fallback;
      }

      result[from] = _coerceForOriginal(
        mapped['local_record_id'].toString(),
        value,
      );
    }

    return result;
  }

  static dynamic _coerceForOriginal(String localId, dynamic originalValue) {
    if (originalValue is int) {
      return int.tryParse(localId) ?? (double.tryParse(localId)?.toInt() ?? localId);
    }
    if (originalValue is double) {
      return double.tryParse(localId) ?? localId;
    }
    if (originalValue is num) {
      final parsed = num.tryParse(localId);
      return parsed ?? localId;
    }
    if (originalValue is bool) {
      final lower = localId.toLowerCase();
      if (lower == '1' || lower == 'true') return true;
      if (lower == '0' || lower == 'false') return false;
    }
    return localId;
  }

  static Future<void> _clearReceivedChange(AppDatabase db, String changeId) async {
    await db.customStatement(
      'DELETE FROM aabm2_sync_received WHERE change_id = ?',
      [changeId],
    );
  }

  static Future<Map<String, dynamic>?> _findAnyMapByLocalId(
    AppDatabase db,
    String entity,
    String localId,
  ) async {
    final rows = await db.customSelect(
      '''SELECT source_device_id, source_record_id, local_record_id,
                row_hash, deleted
         FROM aabm2_sync_map
         WHERE entity = ? AND local_record_id = ? AND deleted = 0
         ORDER BY updated_at DESC LIMIT 1''',
      variables: [
        Variable<String>(entity),
        Variable<String>(localId),
      ],
    ).get();
    return rows.isEmpty ? null : rows.first.data;
  }

  static Future<Map<String, dynamic>> _ensureRemoteDependency(
    AppDatabase db, {
    required String entity,
    required String sourceDevice,
    required String sourceRecordId,
  }) async {
    final existing = await _findMapBySource(db, entity, sourceDevice, sourceRecordId);
    if (existing != null && existing['deleted'] != 1) return existing;

    final guardKey = '$entity|$sourceDevice|$sourceRecordId';
    if (!_applyingRemoteChanges.add(guardKey)) {
      throw StateError('Circular synchronization dependency: $guardKey');
    }

    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .where('entity', isEqualTo: entity)
          .get();

      final candidates = <firestore.DocumentSnapshot<Map<String, dynamic>>>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final topRecord = data['recordId']?.toString();
        final topDevice = data['sourceDeviceId']?.toString() ?? '';
        final payload = data['payload'];
        final payloadMap = payload is Map
            ? Map<String, dynamic>.from(payload)
            : <String, dynamic>{};
        final payloadRecord = _syncMeta(payloadMap, 'source_record')?.toString();
        final payloadDevice = _syncMeta(payloadMap, 'source_device')?.toString();

        final recordMatches = topRecord == sourceRecordId || payloadRecord == sourceRecordId;
        if (!recordMatches) continue;

        // Prefer an exact source-device match. If old V2 records do not carry
        // the source markers inside payload, their top-level sourceDeviceId is
        // still authoritative.
        final deviceMatches = topDevice == sourceDevice || payloadDevice == sourceDevice;
        if (deviceMatches) {
          candidates.insert(0, doc);
        } else {
          candidates.add(doc);
        }
      }

      if (candidates.isEmpty) {
        throw StateError('Remote parent not available in Firebase: $entity/$sourceRecordId');
      }

      // Remove duplicate candidate references while preserving the preferred
      // exact-device ordering above.
      final uniqueCandidates = <String, firestore.DocumentSnapshot<Map<String, dynamic>>>{};
      for (final doc in candidates) {
        uniqueCandidates[doc.id] = doc;
      }
      final orderedCandidates = uniqueCandidates.values.toList();

      for (final doc in orderedCandidates) {
        final data = doc.data() ?? <String, dynamic>{};
        if (data.isEmpty) continue;
        final operation = (data['operation'] ?? '').toString().toUpperCase();
        if (operation == 'DELETE') continue;
        final changeId = (data['changeId'] ?? doc.id).toString();
        // Older V3 builds could record a change as received before the local
        // row was actually created. If the requested mapping is still absent,
        // make that stale receipt replayable.
        final preMap = await _findMapBySource(db, entity, sourceDevice, sourceRecordId);
        if (preMap == null || preMap['deleted'] == 1) {
          await _clearReceivedChange(db, changeId);
        }
        try {
          await _applyRemoteChange(db, data, changeId);
        } catch (_) {
          continue;
        }

        final possible = <Map<String, dynamic>>[];
        final requestedMap = await _findMapBySource(db, entity, sourceDevice, sourceRecordId);
        if (requestedMap != null && requestedMap['deleted'] != 1) possible.add(requestedMap);

        final payload = data['payload'];
        var actualDevice = data['sourceDeviceId']?.toString() ?? sourceDevice;
        var actualRecord = data['recordId']?.toString() ?? sourceRecordId;
        if (payload is Map) {
          actualDevice = _syncMeta(Map<String, dynamic>.from(payload), 'source_device')?.toString() ?? actualDevice;
          actualRecord = _syncMeta(Map<String, dynamic>.from(payload), 'source_record')?.toString() ?? actualRecord;
        }
        final actualMap = await _findMapBySource(db, entity, actualDevice, actualRecord);
        if (actualMap != null && actualMap['deleted'] != 1) possible.add(actualMap);
        if (possible.isNotEmpty) return possible.first;
      }

      throw StateError('Remote dependency could not be applied: $entity/$sourceRecordId');
    } finally {
      _applyingRemoteChanges.remove(guardKey);
    }
  }

  // -------------------------------------------------------------------------
  // SERIALIZATION
  // -------------------------------------------------------------------------

  /// Reads new legal sync metadata names while remaining compatible with
  /// legacy Firestore documents that used the forbidden __...__ field names.
  static dynamic _syncMeta(Map<String, dynamic> map, String key) {
    return map['_sync_$key'] ?? map['__sync_$key'];
  }

  static void _removeSyncMeta(Map<String, dynamic> map, String key) {
    map.remove('_sync_$key');
    map.remove('__sync_$key');
  }

  static Map<String, dynamic> _encodeMap(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, _encodeValue(value)));
  }

  static dynamic _encodeValue(dynamic value) {
    if (value == null || value is String || value is num || value is bool) return value;
    if (value is DateTime) return value.toUtc().toIso8601String();
    if (value is Uint8List) return <String, dynamic>{'_bytes_base64': base64Encode(value)};
    if (value is List<int>) return <String, dynamic>{'_bytes_base64': base64Encode(value)};
    if (value is List) return value.map(_encodeValue).toList();
    if (value is Map) return value.map((k, v) => MapEntry(k.toString(), _encodeValue(v)));
    return value.toString();
  }

  /// Convert DateTime values serialized for Firestore back to Drift's
  /// default SQLite representation before raw SQL INSERT/UPDATE statements.
  ///
  /// Drift's default dateTime() storage is an INTEGER Unix timestamp in
  /// seconds. Our Firestore payload deliberately uses ISO-8601 strings, so
  /// they must be converted back on the receiving device. Do this by table
  /// and column rather than by guessing from arbitrary strings, because a
  /// normal TextColumn may legitimately contain an ISO-looking string.
  static void _coerceRemoteDateTimeValues(
    String entity,
    Map<String, dynamic> values,
  ) {
    const dateColumns = <String, Set<String>>{
      'households': {'joined_date'},
      'household_charge_histories': {'effective_from', 'effective_to'},
      'household_payments': {'payment_date'},
      'household_concessions': {'concession_date'},
      'household_status_histories': {'event_date'},
      'financial_transactions': {'transaction_date'},
      'manual_balances': {'updated_at'},
      'zakaat_disbursements': {'disbursement_date'},
      'fund_adjustments': {'transaction_date'},
    };

    final columns = dateColumns[entity];
    if (columns == null) return;

    for (final column in columns) {
      final value = values[column];
      if (value == null || value is num) continue;

      if (value is DateTime) {
        values[column] = value.toUtc().millisecondsSinceEpoch ~/ 1000;
        continue;
      }

      final parsed = DateTime.tryParse(value.toString());
      if (parsed != null) {
        values[column] = parsed.toUtc().millisecondsSinceEpoch ~/ 1000;
      }
    }
  }

  static dynamic _sqlValue(dynamic value) {
    if (value is Map && value['_bytes_base64'] is String) {
      return base64Decode(value['_bytes_base64'] as String);
    }
    // Read legacy payloads that used the old marker, but never write that
    // marker back to Firestore. Firestore rejects field names beginning and
    // ending with double underscores.
    if (value is Map && value['__bytes__'] is String) {
      return base64Decode(value['__bytes__'] as String);
    }
    if (value is Map || value is List) {
      return jsonEncode(value);
    }
    return value;
  }

  static String? _keyString(dynamic value) {
    if (value == null) return null;
    if (value is Uint8List) return base64Encode(value);
    return value.toString();
  }

  static String? _usernameFromRow(Map<String, dynamic> row) {
    final value = row['username'];
    return value?.toString();
  }

  /// 32-bit FNV-1a. JavaScript-safe for Chrome and deterministic across devices.
  static String _hashPayload(Map<String, dynamic> payload) {
    final canonical = jsonEncode(_canonicalize(payload));
    var hash = 0x811c9dc5;
    for (final byte in utf8.encode(canonical)) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }

  static dynamic _canonicalize(dynamic value) {
    if (value is Map) {
      final keys = value.keys.map((e) => e.toString()).toList()
        ..removeWhere((key) => key.startsWith('_sync_') || key.startsWith('_aabm_'))
        ..sort();
      return <String, dynamic>{for (final key in keys) key: _canonicalize(value[key])};
    }
    if (value is List) return value.map(_canonicalize).toList();
    return value;
  }

  static firestore.Timestamp _firestoreTimestamp(dynamic value) {
    if (value is firestore.Timestamp) return value;
    if (value is DateTime) return firestore.Timestamp.fromDate(value.toUtc());
    final parsed = DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now().toUtc();
    return firestore.Timestamp.fromDate(parsed.toUtc());
  }

  static DateTime? _timestampToDate(dynamic value) {
    if (value is firestore.Timestamp) return value.toDate().toUtc();
    if (value is DateTime) return value.toUtc();
    if (value is String) return DateTime.tryParse(value)?.toUtc();
    return null;
  }
}

class _TableMeta {
  final List<String> columns;
  final List<String> primaryKeys;
  final bool integerPrimaryKey;

  const _TableMeta({
    required this.columns,
    required this.primaryKeys,
    required this.integerPrimaryKey,
  });
}

class SyncStatus {
  final bool ok;
  final bool busy;
  final String? message;

  const SyncStatus._(this.ok, this.busy, this.message);
  const SyncStatus.success() : this._(true, false, null);
  const SyncStatus.busy() : this._(true, true, null);
  const SyncStatus.offline(String message) : this._(false, false, message);
  const SyncStatus.error(String message) : this._(false, false, message);
}
