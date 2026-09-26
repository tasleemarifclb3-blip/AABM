import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'app_database.dart';
import 'workflow_service.dart';
import 'sync_foundation.dart';
import 'backup_io.dart' if (dart.library.html) 'backup_io_stub.dart';

/// Creates a portable JSON backup of the AABM local data.
///
/// Native platforms write to the application-support directory by default
/// (or to a user-selected folder). Web downloads the backup through the
/// browser because a web application cannot silently write to its app folder.
class BackupService {
  static const String _latestBackupTable = 'aabm_latest_backup';

  static Future<void> _ensureLatestBackupTable(AppDatabase db) async {
    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_latestBackupTable (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        created_at TEXT NOT NULL,
        file_name TEXT NOT NULL,
        payload BLOB NOT NULL
      )
    ''');
  }

  static const _driftTables = <String>[
    'households',
    'household_charge_histories',
    'household_months',
    'household_payments',
    'household_concessions',
    'household_concession_allocations',
    'payment_allocations',
    'opening_balance_payment_allocations',
    'opening_balance_concession_allocations',
    'household_status_histories',
    'financial_transactions',
    'manual_balances',
    'zakaat_beneficiaries',
    'zakaat_disbursements',
    'fund_adjustments',
  ];

  static const _workflowTables = <String>[
    'ledger_opening_balances',
    'qarza_parentage',
    'qarza_conditions',
    'qarza_waivers',
    'aabm_approval_requests',
    'aabm_approval_settings',
  ];

  static Future<Map<String, dynamic>> buildBackup(AppDatabase db) async {
    await WorkflowService.ensureTables(db);
    final tables = <String, dynamic>{};

    for (final table in [..._driftTables, ..._workflowTables]) {
      final rows = await db.customSelect('SELECT * FROM "$table"').get();
      tables[table] = rows.map((row) {
        final map = <String, dynamic>{};
        for (final entry in row.data.entries) {
          map[entry.key] = _jsonValue(entry.value);
        }
        return map;
      }).toList();
    }

    return <String, dynamic>{
      'format': 'AABM_BACKUP',
      'version': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'databaseSchemaVersion': 13,
      'tables': tables,
    };
  }

  static dynamic _jsonValue(dynamic value) {
    if (value is DateTime) return value.toIso8601String();
    if (value is Uint8List) return base64Encode(value);
    if (value is List<int>) return base64Encode(value);
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), _jsonValue(v)));
    }
    if (value is Iterable) return value.map(_jsonValue).toList();
    return value;
  }

  static Future<String?> backup(
    AppDatabase db, {
    bool chooseLocation = false,
    bool updateLatest = true,
  }) async {
    final data = await buildBackup(db);
    final bytes = Uint8List.fromList(
      utf8.encode(const JsonEncoder.withIndent('  ').convert(data)),
    );
    final fileName = 'aabm_backup_${_stamp(DateTime.now())}.json';

    // Always keep an application-local copy of the latest user backup. This
    // is deliberately outside the accounting tables, so a local data wipe
    // does not destroy the last recovery point. Safety backups created just
    // before a restore do not replace this latest user-selected backup.
    if (updateLatest) {
      await _ensureLatestBackupTable(db);
      await db.customStatement('''
        INSERT INTO $_latestBackupTable(id, created_at, file_name, payload)
        VALUES (1, ?, ?, ?)
        ON CONFLICT(id) DO UPDATE SET
          created_at = excluded.created_at,
          file_name = excluded.file_name,
          payload = excluded.payload
      ''', [DateTime.now().toUtc().toIso8601String(), fileName, bytes]);
    }

    return saveNativeBackup(
      bytes: bytes,
      fileName: fileName,
      chooseLocation: chooseLocation,
    );
  }

  static Future<Uint8List?> latestBackupBytes(AppDatabase db) async {
    await _ensureLatestBackupTable(db);
    final rows = await db.customSelect(
      'SELECT payload FROM $_latestBackupTable WHERE id = 1 LIMIT 1',
    ).get();
    if (rows.isEmpty) return null;
    final value = rows.first.data['payload'];
    if (value is Uint8List) return value;
    if (value is List<int>) return Uint8List.fromList(value);
    if (value is String) return Uint8List.fromList(utf8.encode(value));
    return null;
  }

  static Future<String?> latestBackupInfo(AppDatabase db) async {
    await _ensureLatestBackupTable(db);
    final rows = await db.customSelect(
      'SELECT created_at, file_name FROM $_latestBackupTable WHERE id = 1 LIMIT 1',
    ).get();
    if (rows.isEmpty) return null;
    final created = rows.first.data['created_at']?.toString() ?? '';
    final name = rows.first.data['file_name']?.toString() ?? 'Latest backup';
    return '$name|$created';
  }


  static const _restoreOrder = <String>[
    'households',
    'household_charge_histories',
    'household_months',
    'household_payments',
    'household_concessions',
    'household_concession_allocations',
    'payment_allocations',
    'opening_balance_payment_allocations',
    'opening_balance_concession_allocations',
    'household_status_histories',
    'financial_transactions',
    'manual_balances',
    'zakaat_beneficiaries',
    'zakaat_disbursements',
    'fund_adjustments',
    'ledger_opening_balances',
    'qarza_parentage',
    'qarza_conditions',
    'qarza_waivers',
    'aabm_approval_requests',
    'aabm_approval_settings',
  ];

  static const _dateColumns = <String>{
    'joined_date',
    'effective_from',
    'effective_to',
    'payment_date',
    'concession_date',
    'event_date',
    'transaction_date',
    'updated_at',
    'disbursement_date',
  };

  static const _blobColumns = <String>{
    'recipient_signature',
    'accountant_signature',
  };

  static const _boolColumns = <String>{'is_active'};

  /// Lets the user select a JSON AABM backup and returns its bytes.
  /// The current file_picker API is used directly so this works on Android,
  /// Windows and Web without dart:io or dart:html imports in this file.
  static Future<Uint8List?> pickBackupBytes() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (file == null) return null;
    return await file.readAsBytes();
  }

  static Map<String, dynamic> parseBackup(Uint8List bytes) {
    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map) {
      throw const FormatException('The selected file is not an AABM backup.');
    }
    final data = Map<String, dynamic>.from(
      decoded.map((key, value) => MapEntry(key.toString(), value)),
    );
    if (data['format'] != 'AABM_BACKUP') {
      throw const FormatException('Invalid AABM backup format.');
    }
    if (data['version'] != 1) {
      throw FormatException('Unsupported AABM backup version: ${data['version']}');
    }
    if (data['databaseSchemaVersion'] != 13) {
      throw FormatException(
        'This backup belongs to database schema ${data['databaseSchemaVersion']}, '
        'but this app uses schema 13.',
      );
    }
    final tables = data['tables'];
    if (tables is! Map) {
      throw const FormatException('Backup contains no table data.');
    }
    for (final table in _restoreOrder) {
      final rows = tables[table];
      if (rows != null && rows is! List) {
        throw FormatException('Invalid data for table: $table');
      }
    }
    return data;
  }

  static Map<String, int> backupCounts(Map<String, dynamic> backup) {
    final tables = Map<String, dynamic>.from(backup['tables'] as Map);
    final result = <String, int>{};
    for (final table in _restoreOrder) {
      final rows = tables[table];
      if (rows is List && rows.isNotEmpty) result[table] = rows.length;
    }
    return result;
  }

  /// Restores the selected backup into the local Drift database.
  ///
  /// Validation is completed before the transaction starts. Existing local
  /// accounting/workflow data and local sync bookkeeping are then replaced.
  /// The permanent device ID is preserved. No Firestore records are deleted.
  static Future<void> restore(AppDatabase db, Map<String, dynamic> backup) async {
    final tables = Map<String, dynamic>.from(backup['tables'] as Map);
    await WorkflowService.ensureTables(db);
    await SyncFoundation.initialize(db);
    await _ensureLatestBackupTable(db);
    final resetToken = await SyncFoundation.getState(db, 'global_reset_token');

    await db.transaction(() async {
      // Child-first deletion because the Drift schema uses foreign keys.
      for (final table in _restoreOrder.reversed) {
        await db.customStatement('DELETE FROM "$table"');
      }

      // Restore parents before children so foreign keys are valid.
      for (final table in _restoreOrder) {
        final rawRows = tables[table];
        if (rawRows is! List || rawRows.isEmpty) continue;
        final rows = rawRows
            .map((row) => Map<String, dynamic>.from(row as Map))
            .toList();
        final columns = await _tableColumns(db, table);
        for (final row in rows) {
          final names = row.keys.where(columns.contains).toList();
          if (names.isEmpty) continue;
          final placeholders = List.filled(names.length, '?').join(', ');
          final quotedNames = names.map((name) => '"$name"').join(', ');
          final values = <dynamic>[];
          for (final name in names) {
            values.add(_restoreValue(table, name, row[name]));
          }
          await db.customStatement(
            'INSERT INTO "$table" ($quotedNames) VALUES ($placeholders)',
            values,
          );
        }
      }

      // A restored local database must not replay the old device's sync
      // queue. The device identity itself is intentionally preserved.
      await db.customStatement('DELETE FROM aabm2_sync_outbox');
      await db.customStatement('DELETE FROM aabm2_sync_received');
      await db.customStatement('DELETE FROM aabm2_sync_conflicts');
      await db.customStatement('DELETE FROM aabm2_sync_failures');
      await db.customStatement('DELETE FROM aabm2_sync_state');
      await db.customStatement('DELETE FROM aabm2_sync_map');
    });

    await SyncFoundation.initialize(db);
    if (resetToken != null && resetToken.isNotEmpty) {
      await SyncFoundation.setState(db, 'global_reset_token', resetToken);
    }
  }

  static Future<Set<String>> _tableColumns(
    AppDatabase db,
    String table,
  ) async {
    final rows = await db.customSelect('PRAGMA table_info("$table")').get();
    return rows.map((r) => r.read<String>('name')).toSet();
  }

  static dynamic _restoreValue(String table, String column, dynamic value) {
    if (value == null) return null;

    if (_blobColumns.contains(column)) {
      if (value is String) return Uint8List.fromList(base64Decode(value));
      if (value is List) return Uint8List.fromList(value.cast<int>());
    }

    if (_boolColumns.contains(column)) {
      if (value is bool) return value ? 1 : 0;
      if (value is num) return value != 0 ? 1 : 0;
      if (value is String) return value.toLowerCase() == 'true' ? 1 : 0;
    }

    if (_dateColumns.contains(column)) {
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
    }

    return value;
  }

  static String _stamp(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}'
      '${d.month.toString().padLeft(2, '0')}'
      '${d.day.toString().padLeft(2, '0')}_'
      '${d.hour.toString().padLeft(2, '0')}'
      '${d.minute.toString().padLeft(2, '0')}'
      '${d.second.toString().padLeft(2, '0')}';
}

