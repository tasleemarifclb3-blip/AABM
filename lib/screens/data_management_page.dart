import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/backup_service.dart';
import '../database/data_management_service.dart';
import '../database/sync_firestore_service.dart';
import 'security.dart';

class DataManagementPage extends StatefulWidget {
  final AppDatabase database;
  const DataManagementPage({super.key, required this.database});

  @override
  State<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage> {
  bool _busy = false;

  Future<bool> _authorizeAdmin({
    String title = 'Admin Authorization Required',
    String message =
        'Enter the separate Admin Password to continue.',
  }) async {
    return requireAdminPassword(
      context,
      title: title,
      message: message,
    );
  }

  Future<void> _backup() async {
    if (_busy) return;

    final authorized = await _authorizeAdmin(
      title: 'Admin Authorization Required',
      message: 'Enter the Admin Password to create a backup.',
    );
    if (!mounted || !authorized) return;

    setState(() => _busy = true);
    try {
      final latest = await BackupService.latestBackupInfo(widget.database);
      final choice = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Back Up AABM Data'),
          content: Text(
            'A complete accounting/workflow backup will be created.\n\n'
            'Choose where to save the backup file. A private latest-copy is also kept inside this installation for quick restore.'
            '${latest == null ? '' : '\n\nCurrent latest backup: ${latest.split('|').first}'}',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.folder_open),
              label: const Text('CHOOSE LOCATION'),
            ),
          ],
        ),
      );
      if (choice != true) return;

      final savedPath = await BackupService.backup(
        widget.database,
        chooseLocation: true,
      );
      if (!mounted) return;
      if (savedPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup cancelled.')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup saved: $savedPath')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    if (_busy) return;

    final authorized = await _authorizeAdmin(
      title: 'Admin Authorization Required',
      message:
          'Enter the Admin Password to restore accounting data.',
    );
    if (!mounted || !authorized) return;

    final choice = await showDialog<_RestoreChoice>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Restore AABM Backup'),
        content: const Text(
          'Choose the backup to restore.\n\n'
          'LATEST SAVED BACKUP uses the backup stored inside this '
          'installation and does not download anything.\n\n'
          'CHOOSE BACKUP FILE lets you select an AABM .json backup '
          'from your device or computer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.pop(context, _RestoreChoice.latest),
            icon: const Icon(Icons.history),
            label: const Text('LATEST SAVED BACKUP'),
          ),
          FilledButton.icon(
            onPressed: () =>
                Navigator.pop(context, _RestoreChoice.file),
            icon: const Icon(Icons.folder_open),
            label: const Text('CHOOSE BACKUP FILE'),
          ),
        ],
      ),
    );

    if (choice == null) return;

    try {
      setState(() => _busy = true);

      final bytes = choice == _RestoreChoice.latest
          ? await BackupService.latestBackupBytes(widget.database)
          : await BackupService.pickBackupBytes();

      if (bytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              choice == _RestoreChoice.latest
                  ? 'No latest saved backup is available.'
                  : 'No backup file selected.',
            ),
          ),
        );
        return;
      }

      final backup = BackupService.parseBackup(bytes);
      final counts = BackupService.backupCounts(backup);

      if (!mounted) return;

      final summary = <String>[
        'Backup date: ${backup['createdAt'] ?? 'Unknown'}',
        'Households: ${counts['households'] ?? 0}',
        'Financial transactions: '
            '${counts['financial_transactions'] ?? 0}',
        'Zakaat disbursements: '
            '${counts['zakaat_disbursements'] ?? 0}',
        'Fund adjustments: ${counts['fund_adjustments'] ?? 0}',
        'Qarza waivers: ${counts['qarza_waivers'] ?? 0}',
      ];

      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Restore Backup?'),
          content: SingleChildScrollView(
            child: Text(
              '${summary.join('\n')}\n\n'
              'The current local accounting/workflow data will be '
              'replaced.\n\n'
              'The restore is performed in a database transaction, so '
              'a failed restore will not leave a partially restored '
              'database.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('RESTORE'),
            ),
          ],
        ),
      );

      if (confirmed != true || !mounted) return;

      // No automatic "safety backup" is written to disk here.
      // On Web that operation previously opened Chrome's download
      // dialog even though the user was restoring data. The actual
      // restore is transactional, so a failed restore rolls back.
      await BackupService.restore(widget.database, backup);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Backup restored successfully. The restored data has '
            'been reset in local sync tracking and will be uploaded '
            'to Firebase by the normal sync process.',
          ),
          duration: Duration(seconds: 8),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAllData() async {
    if (_busy) return;

    final authorized = await _authorizeAdmin(
      title: 'Admin Authorization Required',
      message:
          'Enter the Admin Password to delete local data or reset '
          'the entire synchronized database.',
    );
    if (!mounted || !authorized) return;

    final scope = await showDialog<_DeleteScope>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Delete AABM Data'),
        content: const Text(
          'Choose exactly what you want to delete.\n\n'
          'LOCAL DATA deletes accounting data only from this device/browser.\n\n'
          'ENTIRE DATABASE deletes the synchronized accounting dataset from Firebase and causes all connected AABM devices to clear their local accounting data on their next sync.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context, _DeleteScope.local),
            icon: const Icon(Icons.computer),
            label: const Text('LOCAL DATA ONLY'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, _DeleteScope.entire),
            icon: const Icon(Icons.cloud_off),
            label: const Text('ENTIRE DATABASE'),
          ),
        ],
      ),
    );
    if (scope == null) return;

    final first = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(scope == _DeleteScope.local ? 'Delete Local Data?' : 'DELETE ENTIRE DATABASE?'),
        content: Text(
          scope == _DeleteScope.local
              ? 'This will permanently delete all accounting and workflow data on this device. Firebase data and other devices will not be deleted. You can use Refresh afterwards to download the Firebase dataset again.'
              : 'This is a GLOBAL WIPE. All synchronized accounting events will be deleted from Firebase, and every AABM device will clear its local accounting data when it next connects. This cannot be undone except by restoring a backup.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('CONTINUE')),
        ],
      ),
    );
    if (first != true || !mounted) return;

    final second = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('FINAL CONFIRMATION'),
        content: Text(scope == _DeleteScope.local
            ? 'Permanently DELETE ALL LOCAL ACCOUNTING DATA?'
            : 'Permanently DELETE THE ENTIRE SYNCHRONIZED AABM DATABASE FROM FIREBASE AND ALL DEVICES?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: Text(scope == _DeleteScope.local ? 'DELETE LOCAL DATA' : 'DELETE ENTIRE DATABASE'),
          ),
        ],
      ),
    );
    if (second != true || !mounted) return;

    setState(() => _busy = true);
    try {
      if (scope == _DeleteScope.local) {
        await DataManagementService.deleteAllData(widget.database);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All local accounting data has been deleted. Press Refresh on the dashboard to download the Firebase dataset again.')));
      } else {
        final result = await SyncFirestoreService.deleteEntireDatabase(widget.database);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Management')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _ActionCard(
                icon: Icons.backup_outlined,
                title: 'Backup Data',
                description: 'Choose where to save a complete AABM JSON backup. A latest recovery copy is also kept locally.',
                child: FilledButton.icon(onPressed: _busy ? null : _backup, icon: const Icon(Icons.save_alt), label: const Text('BACK UP DATA')),
              ),
              _ActionCard(
                icon: Icons.restore_outlined,
                title: 'Restore Backup',
                description: 'Restore the latest saved backup or select a backup file from another location.',
                child: OutlinedButton.icon(onPressed: _busy ? null : _restore, icon: const Icon(Icons.restore), label: const Text('RESTORE BACKUP')),
              ),
              _ActionCard(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Data',
                description: 'Choose between deleting only this device or wiping the synchronized AABM database across Firebase and all devices.',
                danger: true,
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _deleteAllData,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('DELETE DATA'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                ),
              ),
              if (_busy) const Padding(padding: EdgeInsets.all(18), child: Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    );
  }
}

enum _RestoreChoice { latest, file }
enum _DeleteScope { local, entire }

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget child;
  final bool danger;
  const _ActionCard({required this.icon, required this.title, required this.description, required this.child, this.danger = false});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Icon(icon, size: 42, color: danger ? Colors.red : null),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: danger ? Colors.red : null)),
          const SizedBox(height: 6),
          Text(description, textAlign: TextAlign.center),
          const SizedBox(height: 14),
          child,
        ]),
      ),
    );
  }
}
