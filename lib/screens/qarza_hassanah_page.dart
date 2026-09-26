import 'dart:typed_data';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/app_database.dart';
import '../database/accounting_service.dart';
import '../database/workflow_service.dart';
import 'brand.dart';
import 'available_balance_card.dart';
import 'qarza_borrower_ledger_page.dart';
import 'edit_transaction_page.dart';
import 'receipt_actions.dart';
import 'security.dart';
import 'signature_pad.dart';
import 'app_ui.dart';

class QarzaHassanahPage extends StatelessWidget {
  final AppDatabase database;
  const QarzaHassanahPage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qarz-e-Hassanah')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppPageHeader(
                  title: 'Qarz-e-Hassanah',
                  subtitle: 'Issue, manage and review interest-free assistance',
                  icon: Icons.handshake_rounded,
                ),
                const AppSectionHeader(title: 'Qarza Management'),
                AppActionCard(
                  title: 'Issue Qarza',
                  subtitle: 'Create a new Qarza request and voucher',
                  icon: Icons.add_card_rounded,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QarzaIssuePage(database: database))),
                ),
                const SizedBox(height: 12),
                AppActionCard(
                  title: 'Borrowers',
                  subtitle: 'Open borrower accounts and transaction history',
                  icon: Icons.people_alt_outlined,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QarzaBorrowersPage(database: database))),
                ),
                const SizedBox(height: 12),
                AppActionCard(
                  title: 'Qarza Waiver Ledger',
                  subtitle: 'Review Qarza amounts waived from the Zakaat fund',
                  icon: Icons.menu_book_rounded,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QarzaWaiverLedgerPage(database: database))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QarzaIssuePage extends StatefulWidget {
  final AppDatabase database;
  const QarzaIssuePage({super.key, required this.database});

  @override
  State<QarzaIssuePage> createState() => _QarzaIssuePageState();
}

class _QarzaIssuePageState extends State<QarzaIssuePage> {
  final _party = TextEditingController();
  final _parentage = TextEditingController();
  final _address = TextEditingController();
  final _aadhaar = TextEditingController();
  final _phone = TextEditingController();
  final _amount = TextEditingController();
  final _cheque = TextEditingController();
  final _verification = TextEditingController();
  final _conditions = TextEditingController();
  final _verifiedBy1 = TextEditingController();
  final _verifiedBy2 = TextEditingController();
  final _verifiedBy3 = TextEditingController();
  final _remarks = TextEditingController();
  DateTime _date = DateTime.now();
  Uint8List? _recipientSignature;
  Uint8List? _accountantSignature;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_party, _parentage, _address, _aadhaar, _phone, _amount, _cheque, _verification, _conditions, _verifiedBy1, _verifiedBy2, _verifiedBy3]) c.dispose();
    super.dispose();
  }

  double _parseAmount(String value) => double.tryParse(value.replaceAll(',', '').replaceAll('₹', '').trim()) ?? 0;

  Future<double> _donationsAvailable() =>
      AccountingService.availableDonations(widget.database);

  Future<String> _nextNumber() async {
    final rows = await widget.database.select(widget.database.fundAdjustments).get();
    var highest = 0;
    for (final row in rows) {
      final v = row.documentNumber;
      if (v == null || !v.startsWith('QH-OUT-')) continue;
      final n = int.tryParse(v.substring('QH-OUT-'.length));
      if (n != null && n > highest) highest = n;
    }
    return 'QH-OUT-${(highest + 1).toString().padLeft(6, '0')}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(1950), lastDate: DateTime(now.year, now.month, now.day));
    if (!mounted || picked == null) return;
    setState(() => _date = DateTime(picked.year, picked.month, picked.day, now.hour, now.minute, now.second));
  }

  String? _validate(double amount) {
    final requiredFields = <String, String>{
      'Borre': _party.text.trim(),
      'Parentage': _parentage.text.trim(),
      'Address': _address.text.trim(),
      'Aadhaar Card Number': _aadhaar.text.trim(),
      'Phone Number': _phone.text.trim(),
      'Amount': _amount.text.trim(),
      'Cheque Number': _cheque.text.trim(),
      'Verification': _verification.text.trim(),
      'Conditions': _conditions.text.trim(),
      'Verified by 1': _verifiedBy1.text.trim(),
      'Verified by 2': _verifiedBy2.text.trim(),
      'Verified by 3': _verifiedBy3.text.trim(),
    };
    for (final entry in requiredFields.entries) {
      if (entry.value.isEmpty) return '${entry.key} is required.';
    }
    if (!RegExp(r'^\d{12}$').hasMatch(_aadhaar.text)) return 'Aadhaar Card Number must contain exactly 12 digits.';
    if (!RegExp(r'^\d{10}$').hasMatch(_phone.text)) return 'Phone Number must contain exactly 10 digits.';
    if (amount <= 0) return 'Enter an amount greater than zero.';
    if (_recipientSignature == null || _recipientSignature!.isEmpty) return 'Borrower / recipient signature is required.';
    if (_accountantSignature == null || _accountantSignature!.isEmpty) return 'Accountant signature is required.';
    return null;
  }

  Future<void> _save() async {
    if (_saving) return;
    final amount = _parseAmount(_amount.text);
    final validation = _validate(amount);
    if (validation != null && validation.isNotEmpty) {
      _show(validation);
      return;
    }
    final available = await _donationsAvailable();
    if (amount > available + .005) {
      _show('Qarz cannot exceed the available Donations balance of ₹${available.toStringAsFixed(2)}.');
      return;
    }

    setState(() => _saving = true);
    try {
      final number = await _nextNumber();
      final insertedId = await widget.database.into(widget.database.fundAdjustments).insert(
        FundAdjustmentsCompanion.insert(
          transactionDate: Value(_date),
          adjustmentType: 'QARZA_DISBURSEMENT',
          amount: amount,
          paymentMode: 'Cheque',
          chequeNumber: Value(_cheque.text.trim()),
          documentNumber: Value(number),
          partyName: Value(_party.text.trim()),
          address: Value(_address.text.trim()),
          aadhaarNumber: Value(_aadhaar.text.trim()),
          phoneNumber: Value(_phone.text.trim()),
          remarks: const Value(''),
          verifiedBy1: Value(_verifiedBy1.text.trim()),
          verifiedBy2: Value(_verifiedBy2.text.trim()),
          verifiedBy3: Value(_verifiedBy3.text.trim()),
          verification: Value(_verification.text.trim()),
          recipientSignature: Value(_recipientSignature),
          accountantSignature: Value(_accountantSignature),
          username: Value(currentUsername ?? 'Legacy'),
        ),
      );
      await WorkflowService.setParentage(widget.database, number, _parentage.text.trim());
      await WorkflowService.setConditions(widget.database, number, _conditions.text.trim());
      await WorkflowService.requestChequeApproval(
        widget.database,
        sourceTable: 'fund_adjustments',
        transactionId: insertedId,
        requestedBy: currentUsername ?? 'Legacy',
      );

      if (!mounted) return;
      await ReceiptActions.showActionsDialog(
        context: context,
        documentNumber: number,
        title: 'Qarz Issued Successfully',
        fileNamePrefix: 'QH-OUT',
        shareMessage: 'Al-Amin Baitul Maal - Qarz Issue $number\nBorrower: ${_party.text.trim()}\nAmount: INR ${amount.toStringAsFixed(2)}',
        buildPdf: () => ReceiptActions.qarzaVoucherDocument(
          documentNumber: number,
          date: _date,
          party: _party.text.trim(),
          address: _address.text.trim(),
          parentage: _parentage.text.trim(),
          aadhaar: _aadhaar.text.trim(),
          phone: _phone.text.trim(),
          amount: amount,
          chequeNumber: _cheque.text.trim(),
          paymentMode: 'Cheque',
          operation: 'ISSUE',
          verification: _verification.text.trim(),
          conditions: _conditions.text.trim(),
          verifiedBy1: _verifiedBy1.text.trim(),
          verifiedBy2: _verifiedBy2.text.trim(),
          verifiedBy3: _verifiedBy3.text.trim(),
          remarks: '',
          recipientSignature: _recipientSignature,
          accountantSignature: _accountantSignature,
          preparedBy: currentUsername ?? 'Legacy',
        ).save(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) _show('Could not save Qarz issue: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _verifierDropdown(String label, TextEditingController controller) {
    final current = kUserPasswords.containsKey(controller.text) ? controller.text : null;
    return DropdownButtonFormField<String>(
      initialValue: current,
      decoration: _d(label),
      items: kUserPasswords.keys.map((name) => DropdownMenuItem<String>(value: name, child: Text(name))).toList(),
      onChanged: _saving ? null : (value) => setState(() => controller.text = value ?? ''),
    );
  }

  void _show(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  Color _fieldFill(String label) {
    final text = label.toLowerCase();
    if (text.contains('name') || text.contains('borrower') || text.contains('recipient')) {
      return const Color(0xFFEAF4F0);
    }
    if (text.contains('parentage') || text.contains('authority') || text.contains('report')) {
      return const Color(0xFFF5EFE1);
    }
    if (text.contains('address')) return const Color(0xFFEEF2F7);
    if (text.contains('aadhaar')) return const Color(0xFFF8EEE7);
    if (text.contains('phone')) return const Color(0xFFF0EBF7);
    if (text.contains('date') || text.contains('month')) return const Color(0xFFEAF0F8);
    if (text.contains('amount')) return const Color(0xFFEAF6EA);
    if (text.contains('cheque') || text.contains('reference')) return const Color(0xFFF5EAF1);
    if (text.contains('verification')) return const Color(0xFFF4F0E8);
    if (text.contains('verified')) return const Color(0xFFEDF5F1);
    if (text.contains('remarks')) return const Color(0xFFF1F1F1);
    if (text.contains('reason')) return const Color(0xFFF9F1E8);
    return const Color(0xFFF7F7F7);
  }

  InputDecoration _d(String label) => InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: .18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: .16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kBrandGreen, width: 1.4),
        ),
        filled: true,
        fillColor: _fieldFill(label),
      );

  @override
  Widget build(BuildContext context) {
    final amount = _parseAmount(_amount.text);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final content = SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(wide ? 4 : 14, 10, wide ? 14 : 14, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 930),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 62,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF145A4A), Color(0xFF1F7A68)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kBrandGreen.withValues(alpha: .15),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const BrandLogo(size: 42),
                          const SizedBox(width: 10),
                          const Icon(Icons.account_balance_rounded, color: Colors.white, size: 25),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Al-Amin Baitul Maal',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  'Issue Qarza • Interest-free assistance',
                                  style: TextStyle(color: Colors.white70, fontSize: 11.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Issue Qarza',
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: kBrandGreen),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _saving ? null : () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded, size: 17),
                          label: const Text('Back'),
                        ),
                      ],
                    ),
                    AvailableBalanceCard(label: 'Available Donations Balance', future: _donationsAvailable()),
                    const SizedBox(height: 8),
                    AppFormSection(
                      title: 'Personal Details',
                      icon: Icons.person_outline_rounded,
                      child: Column(
                        children: [
                          if (wide)
                            Row(children: [
                              Expanded(child: TextField(controller: _party, enabled: !_saving, decoration: _d('Borrower Name *'))),
                              const SizedBox(width: 8),
                              Expanded(child: TextField(controller: _parentage, enabled: !_saving, decoration: _d('Parentage *'))),
                            ])
                          else ...[
                            TextField(controller: _party, enabled: !_saving, decoration: _d('Borrower Name *')),
                            const SizedBox(height: 8),
                            TextField(controller: _parentage, enabled: !_saving, decoration: _d('Parentage *')),
                          ],
                          const SizedBox(height: 8),
                          TextField(controller: _address, enabled: !_saving, maxLines: 1, decoration: _d('Address *')),
                          const SizedBox(height: 8),
                          if (wide)
                            Row(children: [
                              Expanded(child: TextField(controller: _aadhaar, enabled: !_saving, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)], maxLength: 12, decoration: _d('Aadhaar Card Number *'))),
                              const SizedBox(width: 8),
                              Expanded(child: TextField(controller: _phone, enabled: !_saving, keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)], maxLength: 10, decoration: _d('Phone Number *'))),
                            ])
                          else ...[
                            TextField(controller: _aadhaar, enabled: !_saving, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)], maxLength: 12, decoration: _d('Aadhaar Card Number *')),
                            const SizedBox(height: 8),
                            TextField(controller: _phone, enabled: !_saving, keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)], maxLength: 10, decoration: _d('Phone Number *')),
                          ],
                        ],
                      ),
                    ),
                    AppFormSection(
                      title: 'Voucher Details',
                      icon: Icons.description_outlined,
                      child: Column(
                        children: [
                          if (wide)
                            Row(children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _saving ? null : _pickDate,
                                  child: InputDecorator(
                                    decoration: _d('Transaction Date *'),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(ReceiptActions.formatDate(_date)), const Icon(Icons.calendar_today_outlined, size: 18)]),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: TextField(controller: _cheque, enabled: !_saving, decoration: _d('Cheque Number *'))),
                            ])
                          else ...[
                            InkWell(
                              onTap: _saving ? null : _pickDate,
                              child: InputDecorator(
                                decoration: _d('Transaction Date *'),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(ReceiptActions.formatDate(_date)), const Icon(Icons.calendar_today_outlined, size: 18)]),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(controller: _cheque, enabled: !_saving, decoration: _d('Cheque Number *')),
                          ],
                        ],
                      ),
                    ),
                    AppFormSection(
                      title: 'Amount',
                      icon: Icons.payments_outlined,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _amount,
                              enabled: !_saving,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (_) => setState(() {}),
                              decoration: _d('Amount Borrowed *').copyWith(prefixText: '₹ '),
                            ),
                          ),
                          if (amount > 0) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: Container(
                                constraints: const BoxConstraints(minHeight: 44),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                decoration: BoxDecoration(
                                  color: kBrandCream,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: kBrandGold.withValues(alpha: .4)),
                                ),
                                child: Text(
                                  '₹${amount.toStringAsFixed(2)}  •  ${ReceiptActions.amountInWords(amount)}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AppFormSection(
                      title: 'Verification',
                      icon: Icons.verified_user_outlined,
                      child: Column(
                        children: [
                          TextField(controller: _verification, enabled: !_saving, maxLines: 3, decoration: _d('Verification Report *').copyWith(alignLabelWithHint: true)),
                          const SizedBox(height: 8),
                          Row(children: [
                            Expanded(child: _verifierDropdown('Verified by 1 *', _verifiedBy1)),
                            const SizedBox(width: 8),
                            Expanded(child: _verifierDropdown('Verified by 2 *', _verifiedBy2)),
                            const SizedBox(width: 8),
                            Expanded(child: _verifierDropdown('Verified by 3 *', _verifiedBy3)),
                          ]),
                        ],
                      ),
                    ),
                    AppFormSection(
                      title: 'Conditions',
                      icon: Icons.rule_folder_outlined,
                      child: Column(
                        children: [
                          TextField(controller: _conditions, enabled: !_saving, maxLines: 2, decoration: _d('Conditions *').copyWith(alignLabelWithHint: true)),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    AppFormSection(
                      title: 'Signatures',
                      icon: Icons.draw_outlined,
                      child: Row(
                        children: [
                          Expanded(child: SignaturePad(label: 'Borrower / Recipient Signature *', onChanged: (v) => setState(() => _recipientSignature = v))),
                          const SizedBox(width: 10),
                          Expanded(child: SignaturePad(label: 'Accountant Signature *', onChanged: (v) => setState(() => _accountantSignature = v))),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _saving ? null : _save,
                      icon: const Icon(Icons.save_rounded, size: 19),
                      label: Text(_saving ? 'Saving...' : 'Issue & Save Qarza'),
                    ),
                  ],
                ),
              ),
            ),
          );

          if (!wide) return content;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppDesktopSidebar(
                selected: 'Issue Qarza',
                onDashboard: () => Navigator.of(context).popUntil((route) => route.isFirst),
                onIssueQarza: () {},
                onReports: () {},
              ),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }

}


class QarzaWaiverLedgerPage extends StatefulWidget {
  final AppDatabase database;

  const QarzaWaiverLedgerPage({super.key, required this.database});

  @override
  State<QarzaWaiverLedgerPage> createState() => _QarzaWaiverLedgerPageState();
}

class _QarzaWaiverLedgerPageState extends State<QarzaWaiverLedgerPage> {
  late Future<List<QarzaWaiver>> _future;

  @override
  void initState() {
    super.initState();
    _future = WorkflowService.qarzaWaivers(widget.database);
  }

  void _reload() {
    if (mounted) {
      setState(() {
        _future = WorkflowService.qarzaWaivers(widget.database);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qarza Waiver Ledger'), actions: [IconButton(onPressed: _reload, icon: const Icon(Icons.refresh))]),
      body: FutureBuilder<List<QarzaWaiver>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('Could not load waiver ledger:\n${snap.error}', textAlign: TextAlign.center)));
          final rows = snap.data ?? const <QarzaWaiver>[];
          if (rows.isEmpty) return const Center(child: Text('No Qarza waiver transactions found.'));

          final total = rows.fold<double>(0, (sum, w) => sum + w.amount);
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: ListTile(
                  title: const Text('Total Waived to Zakaat', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('₹${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                  subtitle: const Text('Journal: Debit Zakaat Expense • Credit Qarza Receivable • Donation funding link retained as a memorandum reference'),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Waiver No.')),
                        DataColumn(label: Text('Borrower')),
                        DataColumn(label: Text('Original Qarza')),
                        DataColumn(label: Text('Debit: Zakaat')),
                        DataColumn(label: Text('Credit: Qarza')),
                        DataColumn(label: Text('Donation Link')),
                        DataColumn(label: Text('User')),
                        DataColumn(label: Text('Remarks')),
                        DataColumn(label: Text('Modify')),
                      ],
                      rows: [
                        for (final w in rows)
                          DataRow(cells: [
                            DataCell(Text(ReceiptActions.formatDate(w.date))),
                            DataCell(Text(w.waiverNumber)),
                            DataCell(Text(w.borrowerName)),
                            DataCell(Text(w.originalQarzaNumber)),
                            DataCell(Text('₹${w.amount.toStringAsFixed(2)}')),
                            DataCell(Text('₹${w.amount.toStringAsFixed(2)}')),
                            const DataCell(Text('Donations (memo)')),
                            DataCell(Text(w.username)),
                            DataCell(Text(w.remarks.isEmpty ? '—' : w.remarks)),
                            DataCell(
                              IconButton(
                                tooltip: 'Modify waiver',
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () async {
                                  final changed = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditTransactionPage(
                                        database: widget.database,
                                        source: LedgerSource.qarzaWaiver,
                                        id: w.id,
                                        title: 'Qarz Waived to Zakaat',
                                      ),
                                    ),
                                  );
                                  if (changed == true && mounted) _reload();
                                },
                              ),
                            ),
                          ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class QarzaBorrowersPage extends StatefulWidget {
  final AppDatabase database;
  const QarzaBorrowersPage({super.key, required this.database});

  @override
  State<QarzaBorrowersPage> createState() => _QarzaBorrowersPageState();
}

class _QarzaBorrowersPageState extends State<QarzaBorrowersPage> {
  late Future<List<_BorrowerAccount>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_BorrowerAccount>> _load() async {
    final rows = await widget.database.select(widget.database.fundAdjustments).get();
    final rejected = await WorkflowService.rejectedKeys(widget.database);
    final waivers = await WorkflowService.qarzaWaivers(widget.database);
    final map = <String, _BorrowerAccount>{};
    for (final row in rows) {
      if (row.adjustmentType != 'QARZA_DISBURSEMENT' && row.adjustmentType != 'QARZA_RECOVERY') continue;
      if (rejected.contains('fund_adjustments:${row.id}')) continue;
      final name = (row.partyName ?? '').trim();
      if (name.isEmpty) continue;
      final account = map.putIfAbsent(name, () => _BorrowerAccount(name));
      if (row.adjustmentType == 'QARZA_DISBURSEMENT') account.issued += row.amount;
      if (row.adjustmentType == 'QARZA_RECOVERY') account.recovered += row.amount;
      account.lastDate = account.lastDate == null || row.transactionDate.isAfter(account.lastDate!) ? row.transactionDate : account.lastDate;
    }
    for (final waiver in waivers) {
      final name = waiver.borrowerName.trim();
      if (name.isEmpty) continue;
      final account = map.putIfAbsent(name, () => _BorrowerAccount(name));
      account.waived += waiver.amount;
      account.lastDate = account.lastDate == null || waiver.date.isAfter(account.lastDate!) ? waiver.date : account.lastDate;
    }
    final list = map.values.toList()..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  void _open(_BorrowerAccount account) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => QarzaBorrowerLedgerPage(database: widget.database, borrowerName: account.name)));
    if (mounted) {
      setState(() {
        _future = _load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qarz Borrowers')),
      body: FutureBuilder<List<_BorrowerAccount>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('Could not load borrowers:\n${snap.error}', textAlign: TextAlign.center)));
          final list = snap.data!;
          if (list.isEmpty) return const Center(child: Text('No Qarz borrowers found.'));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final b = list[i];
              final outstanding = (b.issued - b.recovered - b.waived).clamp(0, double.infinity).toDouble();
              return Card(
                child: ListTile(
                  onTap: () => _open(b),
                  leading: CircleAvatar(child: Text(b.name.isEmpty ? '?' : b.name[0].toUpperCase())),
                  title: Text(b.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('Borrowed: ₹${b.issued.toStringAsFixed(2)}   Returned: ₹${b.recovered.toStringAsFixed(2)}   Waived to Zakaat: ₹${b.waived.toStringAsFixed(2)}'),
                  trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('Balance', style: TextStyle(fontSize: 11)), Text('₹${outstanding.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: outstanding > 0 ? Colors.red.shade700 : kBrandGreen))]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _BorrowerAccount {
  final String name;
  double issued = 0;
  double recovered = 0;
  double waived = 0;
  DateTime? lastDate;
  _BorrowerAccount(this.name);
}
