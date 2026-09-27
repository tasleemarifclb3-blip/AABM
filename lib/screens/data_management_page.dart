import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/backup_service.dart';
import '../database/data_management_service.dart';
import '../database/sync_firestore_service.dart';

class DataManagementPage extends StatefulWidget {
  final AppDatabase database;

  const DataManagementPage({super.key, required this.database});

  @override
  State<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage> {
  bool _busy = false;

  Future<void> _backup() async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    if (_busy) return;

    final choice = await showDialog<_RestoreChoice>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Restore AABM Backup'),
        content: const Text(
          'Choose the backup you want to restore. The restore replaces the '
          'current local accounting data and resets local sync bookkeeping '
          'so the restored dataset can synchronize again.',
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
            onPressed: () => Navigator.pop(context, _RestoreChoice.file),
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
        'Financial transactions: ${counts['financial_transactions'] ?? 0}',
        'Zakaat disbursements: ${counts['zakaat_disbursements'] ?? 0}',
        'Fund adjustments: ${counts['fund_adjustments'] ?? 0}',
        'Qarza waivers: ${counts['qarza_waivers'] ?? 0}',
      ];

      final firstConfirmation = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Restore Backup?'),
          content: SingleChildScrollView(
            child: Text(
              '${summary.join('\n')}\n\n'
              'Current local accounting data will be replaced. '
              'The existing Firebase dataset will not be deleted by restore.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      );

      if (firstConfirmation != true || !mounted) return;

      final finalConfirmation = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('FINAL CONFIRMATION'),
          content: const Text(
            'Restore this backup now? All current local accounting data '
            'will be replaced by the selected backup.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('RESTORE BACKUP'),
            ),
          ],
        ),
      );

      if (finalConfirmation != true || !mounted) return;

      await BackupService.restore(widget.database, backup);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Backup restored successfully. The restored data is ready to '
            'synchronize with Firebase.',
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

    // The delete workflow always creates a complete portable backup first.
    // If the user cancels the save dialog or the backup fails, no deletion
    // option is offered and no accounting data is changed.
    try {
      setState(() => _busy = true);

      final savedPath = await BackupService.backup(
        widget.database,
        chooseLocation: true,
      );

      if (savedPath == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Delete cancelled because the required backup was not saved.',
            ),
          ),
        );
        return;
      }

      if (!mounted) return;
      setState(() => _busy = false);

      final scope = await showDialog<_DeleteScope>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Delete AABM Data'),
          content: Text(
            'A complete backup was saved at:\n\n$savedPath\n\n'
            'Now choose what to delete.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            OutlinedButton.icon(
              onPressed: () =>
                  Navigator.pop(context, _DeleteScope.local),
              icon: const Icon(Icons.computer),
              label: const Text('LOCAL DATA ONLY'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () =>
                  Navigator.pop(context, _DeleteScope.entire),
              icon: const Icon(Icons.cloud_off),
              label: const Text('ENTIRE DATABASE'),
            ),
          ],
        ),
      );

      if (scope == null || !mounted) return;

      final firstConfirmation = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            scope == _DeleteScope.local
                ? 'Delete Local Data?'
                : 'DELETE ENTIRE DATABASE?',
          ),
          content: Text(
            scope == _DeleteScope.local
                ? 'The backup has been saved successfully. The selected '
                    'local accounting and workflow data will now be deleted '
                    'from this device only.'
                : 'The backup has been saved successfully. The entire '
                    'synchronized AABM database will now be reset. Other '
                    'devices will clear their old local accounting data when '
                    'they next synchronize.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      );

      if (firstConfirmation != true || !mounted) return;

      final finalConfirmation = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('FINAL CONFIRMATION'),
          content: Text(
            scope == _DeleteScope.local
                ? 'Permanently DELETE ALL LOCAL ACCOUNTING DATA?'
                : 'Permanently DELETE THE ENTIRE SYNCHRONIZED AABM '
                    'DATABASE FROM FIREBASE AND ALL DEVICES?\n\n'
                    'The saved backup is your recovery point.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                scope == _DeleteScope.local
                    ? 'DELETE LOCAL DATA'
                    : 'DELETE ENTIRE DATABASE',
              ),
            ),
          ],
        ),
      );

      if (finalConfirmation != true || !mounted) return;

      setState(() => _busy = true);

      if (scope == _DeleteScope.local) {
        await DataManagementService.deleteAllData(widget.database);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All local accounting data has been deleted.'),
          ),
        );
      } else {
        final result = await SyncFirestoreService.deleteEntireDatabase(
          widget.database,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
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
                description:
                    'Create and save a complete AABM JSON backup. You '
                    'choose the storage location.',
                child: FilledButton.icon(
                  onPressed: _busy ? null : _backup,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('BACK UP DATA'),
                ),
              ),
              _ActionCard(
                icon: Icons.restore_outlined,
                title: 'Restore Backup',
                description:
                    'Restore the latest saved backup or choose a backup '
                    'file. Restore requires two confirmations.',
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _restore,
                  icon: const Icon(Icons.restore),
                  label: const Text('RESTORE BACKUP'),
                ),
              ),
              _ActionCard(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Data',
                description:
                    'A complete backup is required first. After it is '
                    'saved, two separate confirmations are required.',
                danger: true,
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _deleteAllData,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('DELETE DATA'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              if (_busy)
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Center(child: CircularProgressIndicator()),
                ),
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

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(icon, size: 42, color: danger ? Colors.red : null),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: danger ? Colors.red : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
