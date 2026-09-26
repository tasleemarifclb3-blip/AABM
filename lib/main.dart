import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'database/sync_foundation.dart';
import 'database/sync_firestore_service.dart';
import 'database/app_database.dart';
import 'database/accounting_service.dart';
import 'database/workflow_service.dart';
import 'screens/brand.dart';
import 'screens/donations_accounts_page.dart';
import 'screens/financial_entry_page.dart';
import 'screens/fund_expense_page.dart';
import 'screens/households_page.dart';
import 'screens/ledger_page.dart';
import 'screens/qarza_hassanah_page.dart';
import 'screens/reports_page.dart';
import 'screens/receipt_actions.dart';
import 'screens/zakaat_expenditure_page.dart';
import 'screens/security.dart';
import 'screens/data_management_page.dart';
import 'screens/app_ui.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final AppDatabase appDatabase = AppDatabase();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSecurity();

  // Render the application first. Database/Firebase synchronization is
  // deliberately started after the first frame so a slow web database,
  // Firebase authentication, or a network problem cannot delay the login
  // screen or block the Android UI thread during startup.
  runApp(const BaitulMaalApp());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(SyncFirestoreService.initialize(appDatabase));
  });
}

class BaitulMaalApp extends StatelessWidget {
  const BaitulMaalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: kBrandGreen, brightness: Brightness.light);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Al-Amin Baitul Maal',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: Colors.transparent,
        cardTheme: CardThemeData(
          elevation: 1.5,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: kBrandGreen,
          centerTitle: false,
        ),
      ),
      builder: (context, child) => _AlAminBackdrop(child: child),
      home: LoginPage(onSuccess: () { navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (_) => const DashboardPage())); }),
    );
  }
}

class _AlAminBackdrop extends StatelessWidget {
  final Widget? child;

  const _AlAminBackdrop({this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/BAckground.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            scale: 1.05,
          ),
        ),
        child ?? const SizedBox.shrink(),
      ],
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _pages = PageController();
  late Future<_FinancialSummary> _future;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<_FinancialSummary> _load() async {
    final totals = await AccountingService.totals(appDatabase);
    final now = DateTime.now();
    bool sameDate(DateTime d) =>
        d.year == now.year && d.month == now.month && d.day == now.day;

    var todayCash = 0.0;
    var todayBank = 0.0;

    final members = await appDatabase.select(appDatabase.householdPayments).get();
    for (final p in members) {
      if (!sameDate(p.paymentDate)) continue;
      if (p.paymentMode == 'Cash') todayCash += p.amount;
      if (p.paymentMode == 'Bank Transfer') todayBank += p.amount;
    }

    final transactions = await appDatabase.select(appDatabase.financialTransactions).get();
    for (final t in transactions) {
      if (!sameDate(t.transactionDate)) continue;
      if (t.paymentMode == 'Cash') todayCash += t.amount;
      if (t.paymentMode == 'Bank Transfer') todayBank += t.amount;
    }

    final adjustments = await appDatabase.select(appDatabase.fundAdjustments).get();
    for (final a in adjustments) {
      if (!sameDate(a.transactionDate)) continue;
      if (a.adjustmentType != 'QARZA_RECOVERY') continue;
      if (a.paymentMode == 'Cash') todayCash += a.amount;
      if (a.paymentMode == 'Bank Transfer') todayBank += a.amount;
    }

    final manualRows = await appDatabase.select(appDatabase.manualBalances).get();
    final cash = manualRows.isEmpty ? 0.0 : manualRows.first.cashInHand;
    final bank = manualRows.isEmpty ? 0.0 : manualRows.first.bankBalance;

    return _FinancialSummary(
      monthlyDonation: totals.monthlyDonation,
      generalDonation: totals.generalDonation,
      boxCollection: totals.boxCollection,
      otherIncome: totals.otherIncome,
      zakaat: totals.zakaatFund,
      sadqaFitr: totals.sadqaFund,
      qarzaNet: totals.qarzaNet,
      todayCash: todayCash,
      todayBank: todayBank,
      cashInHand: cash,
      bankBalance: bank,
      donationFund: totals.donationFund,
      expectedTotal: totals.netAvailable,
    );
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {
      _future = _load();
    });
  }

  Future<void> _syncAndRefresh() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(children: [
          SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
          SizedBox(width: 12),
          Text('Synchronizing with Firebase...'),
        ]),
        duration: Duration(seconds: 30),
      ),
    );

    final status = await SyncFirestoreService.syncNow();
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (status.ok && !status.busy) {
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sync completed successfully. Ledgers and reports have been refreshed.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sync could not be completed: ${status.message ?? 'Sync is already running.'}')),
      );
    }
  }

  Future<void> _push(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (mounted) _refresh();
  }

  Future<void> _openDataManagement() async {
    final controller = TextEditingController();
    bool obscure = true;
    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      requestFocus: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.lock_outline_rounded, color: kBrandGreen),
              SizedBox(width: 10),
              Text('Data Management'),
            ],
          ),
          content: TextField(
            controller: controller,
            // Do not request focus automatically. On Flutter web, an
            // // autofocus TextField inside a modal can leave the dialog
            // FocusScope attached for one frame after the route is popped.
            obscureText: obscure,
            decoration: InputDecoration(
              labelText: 'Superuser Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: obscure ? 'Show password' : 'Hide password',
                onPressed: () => setDialogState(() => obscure = !obscure),
                icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
            ),
            onSubmitted: (_) {
              FocusScope.of(dialogContext).unfocus();
              Navigator.pop(dialogContext, controller.text);
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('CANCEL')),
            FilledButton.icon(
              onPressed: () {
                FocusScope.of(dialogContext).unfocus();
                Navigator.pop(dialogContext, controller.text);
              },
              icon: const Icon(Icons.lock_open_rounded),
              label: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
    // Let the modal route, FocusScope and keyboard detach before disposing
    // the controller or pushing the Data Management page. This prevents the
    // Flutter web '_dependents.isEmpty' assertion during dialog teardown.
    await Future<void>.delayed(const Duration(milliseconds: 120));
    controller.dispose();
    if (!mounted || password == null) return;
    if (!verifySuperuserPassword(password.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Superuser password.')),
      );
      return;
    }
    await _push(DataManagementPage(database: appDatabase));
  }

  Future<void> _editActual(_FinancialSummary s) async {
    final result = await showDialog<_ActualBalanceValues>(
      context: context,
      builder: (_) => _ActualBalancesDialog(
        initialCash: s.cashInHand,
        initialBank: s.bankBalance,
      ),
    );
    if (result == null || !mounted) return;

    try {
      final rows = await appDatabase.select(appDatabase.manualBalances).get();
      if (rows.isEmpty) {
        await appDatabase.into(appDatabase.manualBalances).insert(
          ManualBalancesCompanion.insert(
            cashInHand: Value(result.cash),
            bankBalance: Value(result.bank),
          ),
        );
      } else {
        await (appDatabase.update(appDatabase.manualBalances)
              ..where((t) => t.id.equals(rows.first.id)))
            .write(
          ManualBalancesCompanion(
            cashInHand: Value(result.cash),
            bankBalance: Value(result.bank),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
      if (mounted) _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save reconciliation values: $e')),
        );
      }
    }
  }

  Future<void> _confirmExit() async {
    if (!mounted) return;
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exit Al-Amin Baitul Maal?'),
        content: const Text('Are you sure you want to leave the application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    if (shouldExit != true || !mounted) return;
    await appDatabase.close();
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _confirmExit();
        }
      },
      child: Scaffold(
        // Keep the full logo at the top of the dashboard. Action buttons
        // deliberately sit below it rather than sharing the logo row.
        appBar: const PreferredSize(
          preferredSize: Size.zero,
          child: SizedBox.shrink(),
        ),
        body: FutureBuilder<_FinancialSummary>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Could not load Dashboard:\\n${snap.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final s = snap.data!;

            return Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pages,
                    onPageChanged: (v) => setState(() => _index = v),
                    children: [
                      _screenOne(s),
                      _screenTwo(s),
                      _screenThree(s),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Container(
                        width: 9,
                        height: 9,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _index
                              ? kBrandGreen
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _approvalBanner() {
    return FutureBuilder<String>(
      future: WorkflowService.activeApprover(appDatabase),
      builder: (context, approverSnap) {
        final approver = (approverSnap.data ?? '').trim();
        final user = (currentUsername ?? '').trim();
        if (approver.isEmpty || user.toLowerCase() != approver.toLowerCase()) {
          return const SizedBox.shrink();
        }
        return FutureBuilder<List<PendingCheque>>(
          future: WorkflowService.pending(appDatabase),
          builder: (context, snap) {
            final pending = snap.data ?? const <PendingCheque>[];
            if (pending.isEmpty) return const SizedBox.shrink();
            return Card(
              child: ListTile(
                leading: const Icon(Icons.pending_actions),
                title: Text(
                  '${pending.length} transaction${pending.length == 1 ? '' : 's'} awaiting approval',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('$approver is the configured approver.'),
                trailing: FilledButton.tonal(
                  onPressed: _showPendingApprovals,
                  child: const Text('Review'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _changeApprover() async {
    if (!await requireSuperuserPassword(
      context,
      title: 'Change Approval Authority',
      message: 'Enter the superuser password to change the single active approver.',
    )) return;
    if (!mounted) return;

    final users = kUserPasswords.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final current = await WorkflowService.activeApprover(appDatabase);
    var selected = users.contains(current) ? current : (users.isEmpty ? '' : users.first);

    final chosen = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Single Active Approver'),
          content: DropdownButtonFormField<String>(
            initialValue: selected.isEmpty ? null : selected,
            decoration: const InputDecoration(
              labelText: 'Approver',
              border: OutlineInputBorder(),
            ),
            items: users.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
            onChanged: (v) => setLocal(() => selected = v ?? selected),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: selected.isEmpty ? null : () => Navigator.pop(ctx, selected),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (chosen == null || !mounted) return;

    await WorkflowService.setActiveApprover(appDatabase, chosen);
    await SyncFirestoreService.syncNow();
    if (mounted) {
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Active approver changed to $chosen.')),
      );
    }
  }

  Future<void> _showPendingApprovals() async {
    final activeApprover = await WorkflowService.activeApprover(appDatabase);
    final user = (currentUsername ?? '').trim();
    final canApprove = user.toLowerCase() == activeApprover.toLowerCase();

    var pending = await WorkflowService.pending(appDatabase);
    if (!mounted) return;

    Future<String?> askReason() async {
      final controller = TextEditingController();
      final reason = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Disprove Transaction'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Reason *',
              hintText: 'Enter why this transaction is being disproved',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) Navigator.pop(ctx, controller.text.trim());
              },
              child: const Text('Disprove'),
            ),
          ],
        ),
      );
      controller.dispose();
      return reason;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text('Unapproved Transactions — $activeApprover'),
          content: SizedBox(
            width: 700,
            child: pending.isEmpty
                ? const Text('No unapproved transactions.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: pending.length,
                    itemBuilder: (context, index) {
                      final item = pending[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 5),
                              Text(
                                'Reference: ${item.reference.isEmpty ? '—' : item.reference}\n'
                                'Amount: ₹${item.amount.toStringAsFixed(2)}\n'
                                'Prepared by: ${item.requestedBy}\n'
                                'Date: ${item.requestedAt == null ? '—' : ReceiptActions.formatDate(item.requestedAt!)}',
                              ),
                              const SizedBox(height: 6),
                              Text('Awaiting approval from $activeApprover.'),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: !canApprove ? null : () async {
                                      final reason = await askReason();
                                      if (reason == null) return;
                                      await WorkflowService.reject(
                                        appDatabase,
                                        sourceTable: item.sourceTable,
                                        transactionId: item.transactionId,
                                        rejectedBy: user,
                                        reason: reason,
                                      );
                                      pending = await WorkflowService.pending(appDatabase);
                                      if (dialogContext.mounted) setDialogState(() {});
                                      if (mounted) _refresh();
                                    },
                                    icon: const Icon(Icons.block),
                                    label: const Text('Disprove'),
                                  ),
                                  const SizedBox(width: 8),
                                  FilledButton.icon(
                                    onPressed: !canApprove ? null : () async {
                                      await WorkflowService.approve(
                                        appDatabase,
                                        sourceTable: item.sourceTable,
                                        transactionId: item.transactionId,
                                        approver: user,
                                      );
                                      pending = await WorkflowService.pending(appDatabase);
                                      if (dialogContext.mounted) setDialogState(() {});
                                      if (mounted) _refresh();
                                    },
                                    icon: const Icon(Icons.check),
                                    label: const Text('Approve'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close')),
          ],
        ),
      ),
    );
    if (mounted) _refresh();
  }

  Future<void> _switchUser() async {
    final users = kUserPasswords.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final initial = users.contains((currentUsername ?? '').trim())
        ? (currentUsername ?? '').trim()
        : (users.isEmpty ? '' : users.first);

    final authenticatedUser = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => _SwitchUserDialog(users: users, initialUser: initial),
    );

    if (authenticatedUser == null || !mounted) return;
    // Rebuild only after the dialog route, focus node and keyboard have fully
    // detached. This avoids the recurring Flutter _dependents.isEmpty assertion.
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        currentUsername = authenticatedUser;
      });
    });
  }

  Widget _dashboardScrollable(_FinancialSummary s, Widget content) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep the dashboard comfortably sized on large laptop/desktop
        // screens while allowing it to use the available width on phones.
        final isDesktop = constraints.maxWidth >= 800;
        final maxContentWidth = isDesktop ? 1100.0 : double.infinity;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 24 : 16,
            8,
            isDesktop ? 24 : 16,
            16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppPageHeader(
                    title: 'Al-Amin Baitul Maal',
                    subtitle: 'Manage receipts, funds, expenses and approvals',
                    icon: Icons.account_balance_rounded,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        tooltip: 'Reports (Superuser)',
                        onPressed: () => _push(ReportsPage(database: appDatabase)),
                        icon: const Icon(Icons.bar_chart_rounded),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Change Approver (Superuser)',
                        onPressed: _changeApprover,
                        icon: const Icon(Icons.verified_user_outlined),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Switch User',
                        onPressed: _switchUser,
                        icon: const Icon(Icons.switch_account_outlined),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Sync & Refresh',
                        onPressed: _syncAndRefresh,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .78),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline_rounded, color: kBrandGreen, size: 19),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Welcome, ${(currentUsername ?? '').trim().isEmpty ? 'User' : (currentUsername ?? '').trim()}', style: const TextStyle(fontWeight: FontWeight.w700))),
                        TextButton.icon(
                          onPressed: _openDataManagement,
                          icon: const Icon(Icons.storage_outlined, size: 18),
                          label: const Text('Data'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  content,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _screenOne(_FinancialSummary s) => _dashboardScrollable(
        s,
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _approvalBanner(),
          OutlinedButton.icon(
            onPressed: _showPendingApprovals,
            icon: const Icon(Icons.pending_actions),
            label: const Text('View Unapproved Transactions'),
          ),
          const SizedBox(height: 10),
          _section('Receive Payment'),
          _buttonGrid([
            _menu('Monthly Donation', Icons.people_alt_outlined, () => _push(HouseholdsPage(database: appDatabase))),
            _menu('General Donation', Icons.volunteer_activism_outlined, () => _push(FinancialEntryPage(database: appDatabase, title: 'General Donation', category: 'GD', receiptPrefix: 'GD', typeLabel: 'General Donation'))),
            _menu('Box Collection', Icons.inventory_2_outlined, () => _push(FinancialEntryPage(database: appDatabase, title: 'Box Collection', category: 'BD', receiptPrefix: 'BD', typeLabel: 'Box Collection'))),
            _menu('Other Income', Icons.payments_outlined, () => _push(FinancialEntryPage(database: appDatabase, title: 'Other Income', category: 'OI', receiptPrefix: 'OI', typeLabel: 'Other Income'))),
            _menu('Zakaat Received', Icons.account_balance_wallet_outlined, () => _push(FinancialEntryPage(database: appDatabase, title: 'Zakaat', category: 'ZK', receiptPrefix: 'ZK', typeLabel: 'Zakaat'))),
            _menu('Sadqa-e-Fitr', Icons.card_giftcard_outlined, () => _push(FinancialEntryPage(database: appDatabase, title: 'Sadqa-e-Fitr', category: 'SF', receiptPrefix: 'SF', typeLabel: 'Sadqa-e-Fitr'))),
            _menu('Qarz-e-Hassanah', Icons.handshake_outlined, () => _push(QarzaHassanahPage(database: appDatabase))),
          ]),
          const SizedBox(height: 22),
          _section('Record Expenditure'),
          _buttonGrid([
            _menu('Zakaat', Icons.volunteer_activism_outlined, () => _push(ZakaatExpenditurePage(database: appDatabase))),
            _menu('Sadqa-e-Fitr', Icons.card_giftcard_outlined, () => _push(FundExpensePage(database: appDatabase, title: 'Sadqa-e-Fitr Expenditure', adjustmentType: 'SADQA_EXPENSE', prefix: 'SF-OUT', fundLabel: 'Sadqa-e-Fitr'))),
            _menu('Other Expense', Icons.receipt_long_outlined, () => _push(FundExpensePage(database: appDatabase, title: 'Other Expense', adjustmentType: 'OTHER_EXPENSE', prefix: 'EX', fundLabel: 'Donations'))),
          ]),
          const SizedBox(height: 18),
          _section("Today's Received"),
          Row(children: [Expanded(child: _amountCard('Cash', s.todayCash)), const SizedBox(width: 10), Expanded(child: _amountCard('Bank Transfer', s.todayBank))]),
          _amountCard('Total Collected', s.todayCash + s.todayBank),
          const SizedBox(height: 16),
          const Center(child: Text('Swipe left → Current Available Funds', style: TextStyle(color: Colors.black54))),
        ]),
      );

  Widget _screenTwo(_FinancialSummary s) => _dashboardScrollable(
        s,
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _section('Current Available Funds'),
          _fund('Donations', s.donationFund, () => _push(DonationsAccountsPage(database: appDatabase))),
          _fund('Zakaat', s.zakaat, () => _push(LedgerPage(database: appDatabase, title: 'Zakaat', account: 'ZAKAAT'))),
          _fund('Sadqa-e-Fitr', s.sadqaFitr, () => _push(LedgerPage(database: appDatabase, title: 'Sadqa-e-Fitr', account: 'SADQA_FITR'))),
          _fund('Total Available Funds', s.expectedTotal, () => _push(LedgerPage(database: appDatabase, title: 'Total Available Funds', account: 'TOTAL'))),
          const SizedBox(height: 16),
          const Center(child: Text('Swipe left → Reconciliation', style: TextStyle(color: Colors.black54))),
        ]),
      );

  Widget _screenThree(_FinancialSummary s) {
    final actual = s.cashInHand + s.bankBalance;
    final difference = actual - s.expectedTotal;
    final balanced = difference.abs() < .005;
    final color = balanced ? kBrandGreen : (difference < 0 ? Colors.red.shade700 : Colors.green.shade700);
    return _dashboardScrollable(
      s,
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _section('Reconciliation'),
        _amountCard('Total Funds as per Ledgers', s.expectedTotal),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Actual Cash & Bank', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)), TextButton.icon(onPressed: () => _editActual(s), icon: const Icon(Icons.edit), label: const Text('Enter / Edit'))]),
        Row(children: [Expanded(child: _amountCard('Cash in Hand', s.cashInHand)), const SizedBox(width: 10), Expanded(child: _amountCard('Bank Balance', s.bankBalance))]),
        _amountCard('Actual Total', actual),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text(balanced ? 'BALANCED' : difference < 0 ? 'LESS THAN EXPECTED' : 'MORE THAN EXPECTED', style: TextStyle(color: color, fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(balanced ? '₹0.00' : '${difference > 0 ? '+' : '-'}₹${difference.abs().toStringAsFixed(2)}', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _section(String text) => AppSectionHeader(title: text);

  Widget _buttonGrid(List<Widget> children) => LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;
          final columns = isDesktop ? 3 : 2;
          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: columns,
            childAspectRatio: isDesktop ? 2.9 : 1.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: children,
          );
        },
      );

  Widget _menu(String text, IconData icon, VoidCallback onTap) {
    final expense = {'Zakaat', 'Sadqa-e-Fitr', 'Other Expense'}.contains(text);
    return AppActionCard(title: text, icon: icon, onTap: onTap, destructive: expense);
  }

  Widget _fund(String title, double amount, VoidCallback onTap) => AppBalanceCard(title: title, amount: amount, onTap: onTap, prominent: title == 'Total Available Funds');

  Widget _amountCard(String title, double amount) => AppBalanceCard(title: title, amount: amount);
}

class _SwitchUserDialog extends StatefulWidget {
  final List<String> users;
  final String initialUser;

  const _SwitchUserDialog({required this.users, required this.initialUser});

  @override
  State<_SwitchUserDialog> createState() => _SwitchUserDialogState();
}

class _SwitchUserDialogState extends State<_SwitchUserDialog> {
  late String selected;
  late final TextEditingController passwordController;
  String? error;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    selected = widget.initialUser;
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (submitting) return;
    if (selected.isEmpty) {
      setState(() => error = 'Please select a user.');
      return;
    }
    if (!verifyUserPassword(selected, passwordController.text.trim())) {
      setState(() => error = 'Incorrect password.');
      return;
    }

    // Prevent a second submit while the text field is losing focus and the
    // dialog route is being removed.
    setState(() => submitting = true);
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Switch User'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Select User', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              if (widget.users.isEmpty)
                const Text('No users available.')
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 190),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.users.length,
                    itemBuilder: (_, index) {
                      final user = widget.users[index];
                      return RadioListTile<String>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(user),
                        value: user,
                        groupValue: selected,
                        onChanged: submitting
                            ? null
                            : (value) {
                                if (value == null) return;
                                setState(() {
                                  selected = value;
                                  error = null;
                                  passwordController.clear();
                                });
                              },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                enabled: !submitting,
                obscureText: true,
                maxLength: 4,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: error,
                  border: const OutlineInputBorder(),
                  counterText: '',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: submitting ? null : () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: submitting ? null : _submit,
          child: Text(submitting ? 'Switching...' : 'Switch'),
        ),
      ],
    );
  }
}

class _ActualBalanceValues {
  final double cash;
  final double bank;

  const _ActualBalanceValues({required this.cash, required this.bank});
}

class _ActualBalancesDialog extends StatefulWidget {
  final double initialCash;
  final double initialBank;

  const _ActualBalancesDialog({
    required this.initialCash,
    required this.initialBank,
  });

  @override
  State<_ActualBalancesDialog> createState() => _ActualBalancesDialogState();
}

class _ActualBalancesDialogState extends State<_ActualBalancesDialog> {
  late final TextEditingController _cash;
  late final TextEditingController _bank;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cash = TextEditingController(text: widget.initialCash.toStringAsFixed(2));
    _bank = TextEditingController(text: widget.initialBank.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _cash.dispose();
    _bank.dispose();
    super.dispose();
  }

  double? _parse(String value) {
    final clean = value.replaceAll(',', '').replaceAll('₹', '').trim();
    if (clean.isEmpty) return null;
    return double.tryParse(clean);
  }

  void _save() {
    final cash = _parse(_cash.text);
    final bank = _parse(_bank.text);
    if (cash == null || bank == null || cash < 0 || bank < 0) {
      setState(() => _error = 'Enter valid non-negative amounts.');
      return;
    }
    Navigator.of(context).pop(_ActualBalanceValues(cash: cash, bank: bank));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Actual Cash & Bank'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _cash,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Cash in Hand',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bank,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: const InputDecoration(
                labelText: 'Bank Balance',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _FinancialSummary {
  final double monthlyDonation;
  final double generalDonation;
  final double boxCollection;
  final double otherIncome;
  final double zakaat;
  final double sadqaFitr;
  final double qarzaNet;
  final double todayCash;
  final double todayBank;
  final double cashInHand;
  final double bankBalance;
  final double donationFund;
  final double expectedTotal;

  const _FinancialSummary({
    required this.monthlyDonation,
    required this.generalDonation,
    required this.boxCollection,
    required this.otherIncome,
    required this.zakaat,
    required this.sadqaFitr,
    required this.qarzaNet,
    required this.todayCash,
    required this.todayBank,
    required this.cashInHand,
    required this.bankBalance,
    required this.donationFund,
    required this.expectedTotal,
  });
}
