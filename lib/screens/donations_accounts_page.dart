import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/accounting_service.dart';
import '../database/workflow_service.dart';
import 'ledger_page.dart';

class DonationsAccountsPage extends StatefulWidget {
  final AppDatabase database;
  const DonationsAccountsPage({super.key, required this.database});

  @override
  State<DonationsAccountsPage> createState() => _DonationsAccountsPageState();
}

class _DonationsAccountsPageState extends State<DonationsAccountsPage> {
  late Future<_DonationTotals> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DonationTotals> _load() async {
    final totals = await AccountingService.totals(widget.database);
    final monthlyOpening = await WorkflowService.openingBalance(widget.database, 'MONTHLY_DONATION');
    final generalOpening = await WorkflowService.openingBalance(widget.database, 'GENERAL_DONATION');
    final boxOpening = await WorkflowService.openingBalance(widget.database, 'BOX_COLLECTION');
    final otherOpening = await WorkflowService.openingBalance(widget.database, 'OTHER_INCOME');
    final otherExpenseOpening = await WorkflowService.openingBalance(widget.database, 'OTHER_EXPENSE');
    return _DonationTotals(
      monthly: totals.monthlyDonation + monthlyOpening,
      general: totals.generalDonation + generalOpening,
      box: totals.boxCollection + boxOpening,
      other: totals.otherIncome + otherOpening,
      otherExpense: totals.otherExpense,
      qarzaNet: totals.qarzaNet,
      qarzaIssued: totals.qarzaIssued,
      qarzaRecovered: totals.qarzaRecovered,
      qarzaWaived: totals.qarzaWaived,
      opening: otherExpenseOpening,
    );
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations Accounts'),
        actions: [IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh))],
      ),
      body: FutureBuilder<_DonationTotals>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Could not load accounts:\n${snapshot.error}', textAlign: TextAlign.center));
          final t = snapshot.data!;
          final donationsTotal = t.opening + t.monthly + t.general + t.box + t.other + t.qarzaNet - t.otherExpense;
          final qarzaChild = t.qarzaNet;
          final accounts = [
            ('Monthly Donations', t.monthly, 'MONTHLY_DONATION'),
            ('General Donations', t.general, 'GENERAL_DONATION'),
            ('Other Income', t.other, 'OTHER_INCOME'),
            ('Box Collections', t.box, 'BOX_COLLECTION'),
          ];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Donations', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Current balance after Qarz and other expenses: ₹${donationsTotal.toStringAsFixed(2)}'),
              const SizedBox(height: 14),
              ...accounts.map(
                (a) => Card(
                  child: ListTile(
                    title: Text(a.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('₹${a.$2.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: a.$2 < 0 ? Colors.red.shade700 : null)),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => LedgerPage(database: widget.database, title: a.$1, account: a.$3)));
                      if (mounted) _refresh();
                    },
                  ),
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: const Text('Qarz-e-Hassanah (Receivable)', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Text(
                    '₹${qarzaChild.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: qarzaChild < 0 ? Colors.red.shade700 : null,
                    ),
                  ),
                  subtitle: const Text('Issued − Recovered − Waived'),
                  children: [
                    ListTile(
                      dense: true,
                      title: const Text('Qarz Issued'),
                      trailing: Text('−₹${t.qarzaIssued.toStringAsFixed(2)}', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600)),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text('Qarz Recovered'),
                      trailing: Text('+₹${t.qarzaRecovered.toStringAsFixed(2)}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text('Qarz Waived to Zakaat'),
                      trailing: Text('+₹${t.qarzaWaived.toStringAsFixed(2)}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text('Open Qarza Ledger'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LedgerPage(
                              database: widget.database,
                              title: 'Qarz-e-Hassanah (Receivable)',
                              account: 'QARZA',
                            ),
                          ),
                        );
                        if (mounted) _refresh();
                      },
                    ),
                  ],
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Other Expenses', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Text(
                    '₹${(t.opening - t.otherExpense).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (t.opening - t.otherExpense) < 0 ? Colors.red.shade700 : null,
                    ),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LedgerPage(
                          database: widget.database,
                          title: 'Other Expenses',
                          account: 'OTHER_EXPENSE',
                        ),
                      ),
                    );
                    if (mounted) _refresh();
                  },
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ListTile(
                  title: const Text('Total Donations Balance', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('₹${donationsTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DonationTotals {
  final double monthly;
  final double general;
  final double box;
  final double other;
  final double otherExpense;
  final double qarzaNet;
  final double qarzaIssued;
  final double qarzaRecovered;
  final double qarzaWaived;
  final double opening;

  const _DonationTotals({required this.monthly, required this.general, required this.box, required this.other, required this.otherExpense, required this.qarzaNet, required this.qarzaIssued, required this.qarzaRecovered, required this.qarzaWaived, required this.opening});
}
