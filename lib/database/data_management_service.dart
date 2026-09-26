import 'package:drift/drift.dart';

import 'app_database.dart';
import 'sync_foundation.dart';
import 'workflow_service.dart';

class DataManagementService {
  static const _driftTables = <String>[
    'household_concession_allocations',
    'payment_allocations',
    'opening_balance_payment_allocations',
    'opening_balance_concession_allocations',
    'household_status_histories',
    'household_payments',
    'household_concessions',
    'household_months',
    'household_charge_histories',
    'zakaat_disbursements',
    'zakaat_beneficiaries',
    'fund_adjustments',
    'financial_transactions',
    'manual_balances',
    'households',
  ];

  static const _workflowTables = <String>[
    'aabm_approval_requests',
    'qarza_waivers',
    'qarza_conditions',
    'qarza_parentage',
    'ledger_opening_balances',
  ];

  static Future<void> deleteAllData(AppDatabase db) async {
    await WorkflowService.ensureTables(db);
    final resetToken = await SyncFoundation.getState(db, 'global_reset_token');

    await db.transaction(() async {
      // Delete children before parents because several accounting tables
      // use foreign keys. Keep sync device identity and configuration.
      for (final table in _driftTables) {
        await db.customStatement('DELETE FROM "$table"');
      }
      for (final table in _workflowTables) {
        await db.customStatement('DELETE FROM "$table"');
      }

      // Remove pending/received/conflict bookkeeping, but preserve the
      // permanent device ID in sync_device.
      await db.customStatement('DELETE FROM aabm2_sync_outbox');
      await db.customStatement('DELETE FROM aabm2_sync_received');
      await db.customStatement('DELETE FROM aabm2_sync_conflicts');
      await db.customStatement('DELETE FROM aabm2_sync_failures');
      await db.customStatement('DELETE FROM aabm2_sync_state');
      await db.customStatement('DELETE FROM aabm2_sync_map');
    });

    // Start from a clean sync state without changing the device identity.
    await SyncFoundation.initialize(db);
    if (resetToken != null && resetToken.isNotEmpty) {
      await SyncFoundation.setState(db, 'global_reset_token', resetToken);
    }
  }
}
