import 'package:drift/drift.dart';

import 'app_database.dart';
import 'sync_foundation.dart';

/// Clean, single-approver workflow layer.
///
/// Approval state is stored independently from the accounting tables.
class WorkflowService {
  WorkflowService._();

  static const String _approvalTable = 'aabm_approval_requests';
  static const String _settingsTable = 'aabm_approval_settings';
  static const String _defaultApprover = 'Mushtaq';
  static const String _approvalEntity = 'aabm_approval_request';
  static const String _settingsEntity = 'aabm_approval_settings';

  static Future<void> ensureTables(AppDatabase db) async {
    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS ledger_opening_balances (
        account TEXT PRIMARY KEY NOT NULL,
        amount REAL NOT NULL DEFAULT 0,
        balance_type TEXT NOT NULL DEFAULT 'CREDIT'
      )
    ''');
    final openingColumns = await db.customSelect(
      'PRAGMA table_info(ledger_opening_balances)',
    ).get();
    if (openingColumns.isNotEmpty &&
        !openingColumns.any((r) => r.read<String>('name') == 'balance_type')) {
      await db.customStatement(
        "ALTER TABLE ledger_opening_balances ADD COLUMN balance_type TEXT NOT NULL DEFAULT 'CREDIT'",
      );
    }

    // Singleton configuration for the currently active approver.
    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_settingsTable (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        approver_username TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.customStatement('''
      INSERT OR IGNORE INTO $_settingsTable(id, approver_username, updated_at)
      VALUES (1, ?, ?)
    ''', [_defaultApprover, DateTime.now().toUtc().toIso8601String()]);

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS qarza_parentage (
        document_number TEXT PRIMARY KEY NOT NULL,
        parentage TEXT NOT NULL DEFAULT ''
      )
    ''');
    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS qarza_conditions (
        document_number TEXT PRIMARY KEY NOT NULL,
        conditions TEXT NOT NULL DEFAULT ''
      )
    ''');
    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS qarza_waivers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        waiver_number TEXT NOT NULL UNIQUE,
        waiver_date TEXT NOT NULL,
        borrower_name TEXT NOT NULL,
        original_qarza_number TEXT NOT NULL,
        amount REAL NOT NULL,
        username TEXT NOT NULL,
        remarks TEXT NOT NULL DEFAULT ''
      )
    ''');

    // NEW approval table: exactly one approver, no legacy approver columns.
    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS $_approvalTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source_table TEXT NOT NULL,
        transaction_id INTEGER NOT NULL,
        status TEXT NOT NULL CHECK (status IN ('PENDING','APPROVED','REJECTED')),
        requested_by TEXT NOT NULL,
        requested_at TEXT NOT NULL,
        approved_by TEXT,
        approved_at TEXT,
        rejected_by TEXT,
        rejected_at TEXT,
        rejection_reason TEXT,
        UNIQUE(source_table, transaction_id)
      )
    ''');
  }

  static Future<double> openingBalance(AppDatabase db, String account) async {
    await ensureTables(db);
    final rows = await db.customSelect(
      'SELECT amount, balance_type FROM ledger_opening_balances WHERE account = ?',
      variables: [Variable<String>(account)],
    ).get();
    if (rows.isEmpty) return 0;
    final amount = _number(rows.first.data['amount']);
    return rows.first.data['balance_type']?.toString() == 'DEBIT' ? -amount : amount;
  }

  static Future<double> totalOpeningBalance(AppDatabase db, Iterable<String> accounts) async {
    var total = 0.0;
    for (final account in accounts) {
      total += await openingBalance(db, account);
    }
    return total;
  }

  static Future<void> setOpeningBalance(
    AppDatabase db,
    String account,
    double amount, {
    String balanceType = 'CREDIT',
  }) async {
    await ensureTables(db);
    final type = balanceType.toUpperCase() == 'DEBIT' ? 'DEBIT' : 'CREDIT';
    await db.customStatement('''
      INSERT INTO ledger_opening_balances(account, amount, balance_type)
      VALUES (?, ?, ?)
      ON CONFLICT(account) DO UPDATE SET
        amount = excluded.amount,
        balance_type = excluded.balance_type
    ''', [account, amount, type]);
  }

  static Future<String> parentage(AppDatabase db, String documentNumber) async {
    await ensureTables(db);
    final rows = await db.customSelect(
      'SELECT parentage FROM qarza_parentage WHERE document_number = ?',
      variables: [Variable<String>(documentNumber)],
    ).get();
    return rows.isEmpty ? '' : rows.first.data['parentage']?.toString() ?? '';
  }

  static Future<void> setParentage(AppDatabase db, String documentNumber, String parentage) async {
    await ensureTables(db);
    await db.customStatement('''
      INSERT INTO qarza_parentage(document_number, parentage)
      VALUES (?, ?)
      ON CONFLICT(document_number) DO UPDATE SET parentage = excluded.parentage
    ''', [documentNumber, parentage]);
  }

  static Future<void> removeParentage(AppDatabase db, String documentNumber) async {
    await ensureTables(db);
    await db.customStatement(
      'DELETE FROM qarza_parentage WHERE document_number = ?',
      [documentNumber],
    );
  }

  static Future<String> conditions(AppDatabase db, String documentNumber) async {
    await ensureTables(db);
    final rows = await db.customSelect(
      'SELECT conditions FROM qarza_conditions WHERE document_number = ?',
      variables: [Variable<String>(documentNumber)],
    ).get();
    return rows.isEmpty ? '' : rows.first.data['conditions']?.toString() ?? '';
  }

  static Future<void> setConditions(AppDatabase db, String documentNumber, String conditions) async {
    await ensureTables(db);
    await db.customStatement('''
      INSERT INTO qarza_conditions(document_number, conditions)
      VALUES (?, ?)
      ON CONFLICT(document_number) DO UPDATE SET conditions = excluded.conditions
    ''', [documentNumber, conditions]);
  }

  static Future<void> removeConditions(AppDatabase db, String documentNumber) async {
    await ensureTables(db);
    await db.customStatement(
      'DELETE FROM qarza_conditions WHERE document_number = ?',
      [documentNumber],
    );
  }

  static Future<String> nextWaiverNumber(AppDatabase db) async {
    await ensureTables(db);
    final rows = await db.customSelect(
      "SELECT waiver_number FROM qarza_waivers WHERE waiver_number LIKE 'QW-%'",
    ).get();
    var highest = 0;
    for (final row in rows) {
      final value = row.data['waiver_number']?.toString() ?? '';
      final n = int.tryParse(value.startsWith('QW-') ? value.substring(3) : '');
      if (n != null && n > highest) highest = n;
    }
    return 'QW-${(highest + 1).toString().padLeft(6, '0')}';
  }

  static Future<void> createQarzaWaiver(
    AppDatabase db, {
    required String waiverNumber,
    required DateTime date,
    required String borrowerName,
    required String originalQarzaNumber,
    required double amount,
    required String username,
    required String remarks,
  }) async {
    await ensureTables(db);
    if (amount <= 0) {
      throw StateError('Waiver amount must be greater than zero.');
    }
    final outstanding = await qarzaOutstandingForBorrower(db, borrowerName);
    if (amount > outstanding + .005) {
      throw StateError(
        "Waiver cannot exceed the borrower's outstanding Qarza of ₹${outstanding.toStringAsFixed(2)}.",
      );
    }
    final zakaatAvailable = await availableZakaatForWaiver(db);
    if (amount > zakaatAvailable + .005) {
      throw StateError(
        'Qarza waiver cannot exceed available Zakaat of ₹${zakaatAvailable.toStringAsFixed(2)}.',
      );
    }
    await db.customStatement('''
      INSERT INTO qarza_waivers
      (waiver_number, waiver_date, borrower_name, original_qarza_number,
       amount, username, remarks)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      waiverNumber,
      date.toIso8601String(),
      borrowerName.trim(),
      originalQarzaNumber.trim(),
      amount,
      username.trim(),
      remarks.trim(),
    ]);
  }

  static Future<List<QarzaWaiver>> qarzaWaivers(AppDatabase db) async {
    await ensureTables(db);
    final rows = await db.customSelect(
      'SELECT * FROM qarza_waivers ORDER BY waiver_date ASC, id ASC',
    ).get();
    return rows.map((r) => QarzaWaiver(
      id: _int(r.data['id']) ?? 0,
      waiverNumber: r.data['waiver_number']?.toString() ?? '',
      date: DateTime.tryParse(r.data['waiver_date']?.toString() ?? '') ?? DateTime.now(),
      borrowerName: r.data['borrower_name']?.toString() ?? '',
      originalQarzaNumber: r.data['original_qarza_number']?.toString() ?? '',
      amount: _number(r.data['amount']),
      username: r.data['username']?.toString() ?? '',
      remarks: r.data['remarks']?.toString() ?? '',
    )).toList();
  }

  static Future<double> waivedForBorrower(AppDatabase db, String borrowerName) async {
    await ensureTables(db);
    final rows = await db.customSelect('''
      SELECT COALESCE(SUM(amount), 0) AS total
      FROM qarza_waivers WHERE lower(borrower_name) = lower(?)
    ''', variables: [Variable<String>(borrowerName.trim())]).get();
    return _number(rows.first.data['total']);
  }

  /// Zakaat allocation available for a Qarza waiver. Unlike a normal cash
  /// expenditure, the waiver does not reduce total cash; it only reallocates
  /// part of the Zakaat fund against the Qarza receivable.
  ///
  /// Pending/rejected approval-required Zakaat disbursements are excluded,
  /// matching the application's accounting rules.
  static Future<double> availableZakaatForWaiver(
    AppDatabase db, {
    int? excludeWaiverId,
  }) async {
    await ensureTables(db);
    final opening = await openingBalance(db, 'ZAKAAT');
    final blocked = await nonEffectiveKeys(db);

    var received = 0.0;
    final financial = await db.select(db.financialTransactions).get();
    for (final row in financial) {
      final category = row.category.toUpperCase();
      if (category == 'ZK' || category == 'ZAKAAT') received += row.amount;
    }

    var spent = 0.0;
    final disbursements = await db.select(db.zakaatDisbursements).get();
    for (final row in disbursements) {
      if (blocked.contains('zakaat_disbursements:${row.id}')) continue;
      spent += row.amount;
    }

    var waived = 0.0;
    final waivers = await qarzaWaivers(db);
    for (final waiver in waivers) {
      if (excludeWaiverId != null && waiver.id == excludeWaiverId) continue;
      waived += waiver.amount;
    }

    final balance = opening + received - spent - waived;
    return balance < 0 ? 0 : balance;
  }

  static Future<double> qarzaOutstandingForBorrower(
    AppDatabase db,
    String borrowerName, {
    int? excludeWaiverId,
  }) async {
    await ensureTables(db);
    final rows = await db.select(db.fundAdjustments).get();
    final blocked = await nonEffectiveKeys(db);
    final key = borrowerName.trim().toLowerCase();
    var outstanding = 0.0;
    for (final row in rows) {
      if (blocked.contains('fund_adjustments:${row.id}')) continue;
      if ((row.partyName ?? '').trim().toLowerCase() != key) continue;
      if (row.adjustmentType == 'QARZA_DISBURSEMENT') outstanding += row.amount;
      if (row.adjustmentType == 'QARZA_RECOVERY') outstanding -= row.amount;
    }
    for (final waiver in await qarzaWaivers(db)) {
      if (excludeWaiverId != null && waiver.id == excludeWaiverId) continue;
      if (waiver.borrowerName.trim().toLowerCase() == key) outstanding -= waiver.amount;
    }
    return outstanding < 0 ? 0 : outstanding;
  }

  static Future<void> updateQarzaWaiver(
    AppDatabase db, {
    required int id,
    required DateTime date,
    required double amount,
    required String remarks,
  }) async {
    await ensureTables(db);
    if (amount <= 0) {
      throw StateError('Waiver amount must be greater than zero.');
    }
    final rows = await db.customSelect(
      'SELECT borrower_name FROM qarza_waivers WHERE id = ? LIMIT 1',
      variables: [Variable<int>(id)],
    ).get();
    if (rows.isEmpty) throw StateError('Qarza waiver not found.');
    final borrower = rows.first.data['borrower_name']?.toString() ?? '';
    final outstanding = await qarzaOutstandingForBorrower(
      db,
      borrower,
      excludeWaiverId: id,
    );
    if (amount > outstanding + .005) {
      throw StateError(
        "Waiver cannot exceed the borrower's outstanding Qarza of ₹${outstanding.toStringAsFixed(2)}.",
      );
    }
    final zakaatAvailable = await availableZakaatForWaiver(
      db,
      excludeWaiverId: id,
    );
    if (amount > zakaatAvailable + .005) {
      throw StateError(
        'Qarza waiver cannot exceed available Zakaat of ₹${zakaatAvailable.toStringAsFixed(2)}.',
      );
    }
    await db.customStatement('''
      UPDATE qarza_waivers SET waiver_date = ?, amount = ?, remarks = ? WHERE id = ?
    ''', [date.toIso8601String(), amount, remarks.trim(), id]);
  }

  static Future<void> deleteQarzaWaiver(AppDatabase db, int id) async {
    await ensureTables(db);
    await db.customStatement('DELETE FROM qarza_waivers WHERE id = ?', [id]);
  }

  static Future<String> activeApprover(AppDatabase db) async {
    await ensureTables(db);
    final rows = await db.customSelect(
      'SELECT approver_username FROM $_settingsTable WHERE id = 1 LIMIT 1',
    ).get();
    final value = rows.isEmpty ? _defaultApprover : rows.first.data['approver_username']?.toString().trim() ?? '';
    return value.isEmpty ? _defaultApprover : value;
  }

  static Future<void> setActiveApprover(AppDatabase db, String approver) async {
    await ensureTables(db);
    final clean = approver.trim();
    if (clean.isEmpty) throw ArgumentError('An approver must be selected.');
    final now = DateTime.now().toUtc().toIso8601String();
    await db.customStatement('''
      INSERT INTO $_settingsTable(id, approver_username, updated_at)
      VALUES (1, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        approver_username = excluded.approver_username,
        updated_at = excluded.updated_at
    ''', [clean, now]);

    final device = await SyncFoundation.getDeviceId(db);
    await SyncFoundation.enqueueChange(
      db,
      entity: _settingsEntity,
      recordId: '1',
      operation: 'UPDATE',
      payload: {
        '_aabm_source_device': device,
        '_aabm_source_record': '1',
        'id': 1,
        'approver_username': clean,
        'updated_at': now,
      },
      actorUsername: clean,
    );
  }

  static Future<void> requestChequeApproval(
    AppDatabase db, {
    required String sourceTable,
    required int transactionId,
    required String requestedBy,
  }) async {
    await ensureTables(db);
    if (!await _approvalRequiredFor(db, sourceTable, transactionId)) {
      throw StateError('$sourceTable/$transactionId does not require approval.');
    }

    final now = DateTime.now().toUtc().toIso8601String();
    final parent = await SyncFoundation.findMappingByLocalId(db, sourceTable, transactionId.toString());
    final parentDevice = parent?['source_device_id']?.toString() ?? await SyncFoundation.getDeviceId(db);
    final parentRecord = parent?['source_record_id']?.toString() ?? transactionId.toString();
    final approvalKey = '$parentDevice|$sourceTable|$parentRecord';

    await db.customStatement('''
      INSERT INTO $_approvalTable
      (source_table, transaction_id, status, requested_by, requested_at,
       approved_by, approved_at, rejected_by, rejected_at, rejection_reason)
      VALUES (?, ?, 'PENDING', ?, ?, NULL, NULL, NULL, NULL, NULL)
      ON CONFLICT(source_table, transaction_id) DO UPDATE SET
        status = 'PENDING', requested_by = excluded.requested_by,
        requested_at = excluded.requested_at,
        approved_by = NULL, approved_at = NULL,
        rejected_by = NULL, rejected_at = NULL, rejection_reason = NULL
    ''', [sourceTable, transactionId, requestedBy.trim(), now]);

    await _enqueueApprovalChange(
      db,
      approvalKey: approvalKey,
      parentDevice: parentDevice,
      parentRecord: parentRecord,
      sourceTable: sourceTable,
      transactionId: transactionId,
      requestedBy: requestedBy.trim(),
      requestedAt: now,
      status: 'PENDING',
      approvedBy: null,
      approvedAt: null,
      rejectedBy: null,
      rejectedAt: null,
      rejectionReason: null,
    );
  }

  static Future<Set<String>> pendingKeys(AppDatabase db) async {
    await ensureTables(db);
    final rows = await db.customSelect(
      "SELECT source_table, transaction_id FROM $_approvalTable WHERE status = 'PENDING'",
    ).get();
    return rows.map((r) => '${r.data['source_table']}:${_int(r.data['transaction_id'])}').toSet();
  }

  static Future<int> pendingCount(AppDatabase db) async {
    await ensureTables(db);
    final rows = await db.customSelect(
      "SELECT COUNT(*) AS n FROM $_approvalTable WHERE status = 'PENDING'",
    ).get();
    return _int(rows.first.data['n']) ?? 0;
  }

  static Future<List<PendingCheque>> pending(AppDatabase db) async {
    await ensureTables(db);
    final rows = await db.customSelect('''
      SELECT source_table, transaction_id, requested_by, requested_at
      FROM $_approvalTable WHERE status = 'PENDING'
      ORDER BY requested_at ASC
    ''').get();
    final result = <PendingCheque>[];
    for (final row in rows) {
      final source = row.data['source_table']?.toString() ?? '';
      final id = _int(row.data['transaction_id']);
      if (source.isEmpty || id == null) continue;
      var description = '$source #$id';
      var amount = 0.0;
      var reference = '';
      if (source == 'fund_adjustments') {
        final r = await db.customSelect(
          'SELECT adjustment_type, amount, document_number, cheque_number FROM fund_adjustments WHERE id = ? LIMIT 1',
          variables: [Variable<int>(id)],
        ).get();
        if (r.isNotEmpty) {
          description = r.first.data['adjustment_type']?.toString() ?? description;
          amount = _number(r.first.data['amount']);
          reference = (r.first.data['document_number'] ?? r.first.data['cheque_number'] ?? '').toString();
        }
      } else if (source == 'zakaat_disbursements') {
        final r = await db.customSelect(
          'SELECT recipient_name, amount, voucher_number FROM zakaat_disbursements WHERE id = ? LIMIT 1',
          variables: [Variable<int>(id)],
        ).get();
        if (r.isNotEmpty) {
          description = 'Zakaat Expenditure — ${r.first.data['recipient_name'] ?? ''}'.trim();
          amount = _number(r.first.data['amount']);
          reference = r.first.data['voucher_number']?.toString() ?? '';
        }
      }
      result.add(PendingCheque(
        sourceTable: source,
        transactionId: id,
        requestedBy: row.data['requested_by']?.toString() ?? '',
        requestedAt: DateTime.tryParse(row.data['requested_at']?.toString() ?? ''),
        description: description,
        amount: amount,
        reference: reference,
      ));
    }
    return result;
  }

  static Future<void> removeChequeApproval(
    AppDatabase db, {
    required String sourceTable,
    required int transactionId,
  }) async {
    await ensureTables(db);

    // The local approval row is physical/local state, but the synchronized
    // identity is derived from the parent transaction's stable source mapping.
    // Publish a tombstone before deleting locally so another device does not
    // retain a stale approval request indefinitely.
    final existing = await db.customSelect(
      'SELECT id FROM $_approvalTable WHERE source_table = ? AND transaction_id = ? LIMIT 1',
      variables: [Variable<String>(sourceTable), Variable<int>(transactionId)],
    ).get();
    if (existing.isEmpty) return;

    final parent = await SyncFoundation.findMappingByLocalId(
      db,
      sourceTable,
      transactionId.toString(),
    );
    final parentDevice = parent?['source_device_id']?.toString() ??
        await SyncFoundation.getDeviceId(db);
    final parentRecord = parent?['source_record_id']?.toString() ?? transactionId.toString();
    final approvalKey = '$parentDevice|$sourceTable|$parentRecord';

    await db.transaction(() async {
      await db.customStatement(
        'DELETE FROM $_approvalTable WHERE source_table = ? AND transaction_id = ?',
        [sourceTable, transactionId],
      );

      await SyncFoundation.enqueueChange(
        db,
        entity: _approvalEntity,
        recordId: approvalKey,
        operation: 'DELETE',
        payload: {
          '_aabm_source_device': parentDevice,
          '_aabm_source_record': approvalKey,
          '_aabm_parent_device': parentDevice,
          '_aabm_parent_record': parentRecord,
          'source_table': sourceTable,
          'transaction_id': transactionId,
        },
      );
    });
  }

  static Future<void> approve(
    AppDatabase db, {
    required String sourceTable,
    required int transactionId,
    required String approver,
  }) async {
    await ensureTables(db);
    final configured = (await activeApprover(db)).toLowerCase();
    if (approver.trim().isEmpty || approver.trim().toLowerCase() != configured) {
      throw ArgumentError('Only the configured approver may approve this transaction.');
    }
    final rows = await db.customSelect('''
      SELECT requested_by, requested_at FROM $_approvalTable
      WHERE source_table = ? AND transaction_id = ? AND status = 'PENDING' LIMIT 1
    ''', variables: [Variable<String>(sourceTable), Variable<int>(transactionId)]).get();
    if (rows.isEmpty) throw StateError('Approval request is not pending.');
    final now = DateTime.now().toUtc().toIso8601String();
    await db.customStatement('''
      UPDATE $_approvalTable SET
        status = 'APPROVED', approved_by = ?, approved_at = ?,
        rejected_by = NULL, rejected_at = NULL, rejection_reason = NULL
      WHERE source_table = ? AND transaction_id = ? AND status = 'PENDING'
    ''', [approver.trim(), now, sourceTable, transactionId]);
    await _enqueueCurrentApprovalState(db, sourceTable, transactionId);
  }

  static Future<void> reject(
    AppDatabase db, {
    required String sourceTable,
    required int transactionId,
    required String rejectedBy,
    required String reason,
  }) async {
    await ensureTables(db);
    final configured = (await activeApprover(db)).toLowerCase();
    if (rejectedBy.trim().isEmpty || rejectedBy.trim().toLowerCase() != configured) {
      throw ArgumentError('Only the configured approver may disprove this transaction.');
    }
    final cleanReason = reason.trim();
    if (cleanReason.isEmpty) throw ArgumentError('A reason is required for disproof.');
    final now = DateTime.now().toUtc().toIso8601String();
    final pending = await db.customSelect(
      "SELECT id FROM $_approvalTable WHERE source_table = ? AND transaction_id = ? AND status = 'PENDING' LIMIT 1",
      variables: [Variable<String>(sourceTable), Variable<int>(transactionId)],
    ).get();
    if (pending.isEmpty) throw StateError('Approval request is not pending.');
    await db.customStatement('''
      UPDATE $_approvalTable SET
        status = 'REJECTED', rejected_by = ?, rejected_at = ?, rejection_reason = ?,
        approved_by = NULL, approved_at = NULL
      WHERE source_table = ? AND transaction_id = ? AND status = 'PENDING'
    ''', [rejectedBy.trim(), now, cleanReason, sourceTable, transactionId]);
    await _enqueueCurrentApprovalState(db, sourceTable, transactionId);
  }

  static Future<Map<String, Object?>> approvalInfo(
    AppDatabase db, {
    required String sourceTable,
    required int transactionId,
  }) async {
    await ensureTables(db);
    final rows = await db.customSelect('''
      SELECT status, requested_by, requested_at, approved_by, approved_at,
             rejected_by, rejected_at, rejection_reason
      FROM $_approvalTable
      WHERE source_table = ? AND transaction_id = ? LIMIT 1
    ''', variables: [Variable<String>(sourceTable), Variable<int>(transactionId)]).get();
    if (rows.isNotEmpty) return rows.first.data;

    // Fail closed for every transaction type that is subject to approval.
    // Missing approval data can never silently become financially effective.
    if (await _approvalRequiredFor(db, sourceTable, transactionId)) {
      return <String, Object?>{'status': 'PENDING', 'requested_by': null, 'requested_at': null};
    }
    return <String, Object?>{'status': 'FINAL'};
  }

  static Future<Set<String>> rejectedKeys(AppDatabase db) async {
    await ensureTables(db);
    final rows = await db.customSelect(
      "SELECT source_table, transaction_id FROM $_approvalTable WHERE status = 'REJECTED'",
    ).get();
    return rows.map((r) => '${r.data['source_table']}:${_int(r.data['transaction_id'])}').toSet();
  }

  static Future<Set<String>> nonEffectiveKeys(AppDatabase db) async {
    await ensureTables(db);
    final result = <String>{};
    final rows = await db.customSelect('''
      SELECT source_table, transaction_id FROM $_approvalTable WHERE status != 'APPROVED'
    ''').get();
    for (final r in rows) {
      final id = _int(r.data['transaction_id']);
      if (id != null) result.add('${r.data['source_table']}:$id');
    }

    // Fail closed for approval-required source rows that have no approval row.
    final fundRows = await db.customSelect('''
      SELECT id FROM fund_adjustments
      WHERE adjustment_type IN ('QARZA_DISBURSEMENT','OTHER_EXPENSE')
    ''').get();
    for (final r in fundRows) {
      final id = _int(r.data['id']);
      if (id != null) {
        final exists = await _approvalExists(db, 'fund_adjustments', id);
        if (!exists) result.add('fund_adjustments:$id');
      }
    }
    final zakaatRows = await db.customSelect('SELECT id FROM zakaat_disbursements').get();
    for (final r in zakaatRows) {
      final id = _int(r.data['id']);
      if (id != null) {
        final exists = await _approvalExists(db, 'zakaat_disbursements', id);
        if (!exists) result.add('zakaat_disbursements:$id');
      }
    }
    return result;
  }

  static Future<void> _enqueueCurrentApprovalState(
    AppDatabase db,
    String sourceTable,
    int transactionId,
  ) async {
    final row = await db.customSelect('SELECT * FROM $_approvalTable WHERE source_table = ? AND transaction_id = ? LIMIT 1',
      variables: [Variable<String>(sourceTable), Variable<int>(transactionId)]).getSingle();
    final parent = await SyncFoundation.findMappingByLocalId(db, sourceTable, transactionId.toString());
    final parentDevice = parent?['source_device_id']?.toString() ?? await SyncFoundation.getDeviceId(db);
    final parentRecord = parent?['source_record_id']?.toString() ?? transactionId.toString();
    await _enqueueApprovalChange(
      db,
      approvalKey: '$parentDevice|$sourceTable|$parentRecord',
      parentDevice: parentDevice,
      parentRecord: parentRecord,
      sourceTable: sourceTable,
      transactionId: transactionId,
      requestedBy: row.data['requested_by']?.toString() ?? '',
      requestedAt: row.data['requested_at']?.toString() ?? DateTime.now().toUtc().toIso8601String(),
      status: row.data['status']?.toString() ?? 'PENDING',
      approvedBy: row.data['approved_by']?.toString(),
      approvedAt: row.data['approved_at']?.toString(),
      rejectedBy: row.data['rejected_by']?.toString(),
      rejectedAt: row.data['rejected_at']?.toString(),
      rejectionReason: row.data['rejection_reason']?.toString(),
    );
  }

  static Future<void> _enqueueApprovalChange(
    AppDatabase db, {
    required String approvalKey,
    required String parentDevice,
    required String parentRecord,
    required String sourceTable,
    required int transactionId,
    required String requestedBy,
    required String requestedAt,
    required String status,
    required String? approvedBy,
    required String? approvedAt,
    required String? rejectedBy,
    required String? rejectedAt,
    required String? rejectionReason,
  }) async {
    final localDevice = await SyncFoundation.getDeviceId(db);
    await SyncFoundation.enqueueChange(
      db,
      entity: _approvalEntity,
      recordId: approvalKey,
      operation: 'UPSERT',
      payload: {
        '_aabm_source_device': parentDevice,
        '_aabm_source_record': approvalKey,
        '_aabm_parent_device': parentDevice,
        '_aabm_parent_record': parentRecord,
        'source_table': sourceTable,
        'transaction_id': transactionId,
        'status': status,
        'requested_by': requestedBy,
        'requested_at': requestedAt,
        'approved_by': approvedBy,
        'approved_at': approvedAt,
        'rejected_by': rejectedBy,
        'rejected_at': rejectedAt,
        'rejection_reason': rejectionReason,
        'changed_on_device': localDevice,
      },
      actorUsername: approvedBy ?? rejectedBy ?? requestedBy,
    );
  }

  static Future<bool> _approvalRequiredFor(AppDatabase db, String sourceTable, int transactionId) async {
    if (sourceTable == 'zakaat_disbursements') return true;
    if (sourceTable == 'fund_adjustments') {
      final rows = await db.customSelect(
        'SELECT adjustment_type FROM fund_adjustments WHERE id = ? LIMIT 1',
        variables: [Variable<int>(transactionId)],
      ).get();
      if (rows.isEmpty) return false;
      final type = rows.first.data['adjustment_type']?.toString();
      return type == 'QARZA_DISBURSEMENT' || type == 'OTHER_EXPENSE';
    }
    return false;
  }

  static Future<bool> _approvalExists(AppDatabase db, String sourceTable, int transactionId) async {
    final rows = await db.customSelect(
      'SELECT id FROM $_approvalTable WHERE source_table = ? AND transaction_id = ? LIMIT 1',
      variables: [Variable<String>(sourceTable), Variable<int>(transactionId)],
    ).get();
    return rows.isNotEmpty;
  }

  static double _number(Object? value) => value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '') ?? 0;
  static int? _int(Object? value) => value is int ? value : int.tryParse(value?.toString() ?? '');
}

class QarzaWaiver {
  final int id;
  final String waiverNumber;
  final DateTime date;
  final String borrowerName;
  final String originalQarzaNumber;
  final double amount;
  final String username;
  final String remarks;

  const QarzaWaiver({
    required this.id,
    required this.waiverNumber,
    required this.date,
    required this.borrowerName,
    required this.originalQarzaNumber,
    required this.amount,
    required this.username,
    required this.remarks,
  });
}

class PendingCheque {
  final String sourceTable;
  final int transactionId;
  final String requestedBy;
  final DateTime? requestedAt;
  final String description;
  final double amount;
  final String reference;

  const PendingCheque({
    required this.sourceTable,
    required this.transactionId,
    required this.requestedBy,
    required this.requestedAt,
    required this.description,
    required this.amount,
    required this.reference,
  });
}
