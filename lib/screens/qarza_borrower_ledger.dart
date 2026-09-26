import 'dart:typed_data';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/workflow_service.dart';
import 'edit_transaction_page.dart';
import 'receipt_actions.dart';
import 'security.dart';

class QarzaBorrowerLedgerPage extends StatefulWidget {
  final AppDatabase database;
  final String borrowerName;

  const QarzaBorrowerLedgerPage({
    super.key,
    required this.database,
    required this.borrowerName,
  });

  @override
  State<QarzaBorrowerLedgerPage> createState() => _QarzaBorrowerLedgerPageState();
}

class _QarzaBorrowerLedgerPageState extends State<QarzaBorrowerLedgerPage> {
  late Future<List<FundAdjustment>> _future;

  @override
  void initState() {
    super.initState();
    _future = _rows();
  }

  Future<List<FundAdjustment>> _rows() {
    return (widget.database.select(widget.database.fundAdjustments)
          ..where((a) => a.partyName.equals(widget.borrowerName) &
              (a.adjustmentType.equals('QARZA_DISBURSEMENT') |
                  a.adjustmentType.equals('QARZA_RECOVERY')))
          ..orderBy([
            (a) => OrderingTerm(expression: a.transactionDate, mode: OrderingMode.asc),
            (a) => OrderingTerm(expression: a.id, mode: OrderingMode.asc),
          ]))
        .get();
  }

  double _balanceAfter(List<FundAdjustment> rows, int index) {
    var balance = 0.0;
    for (var i = 0; i <= index; i++) {
      final row = rows[i];
      balance += row.adjustmentType == 'QARZA_DISBURSEMENT' ? row.amount : -row.amount;
    }
    return balance < 0 ? 0 : balance;
  }

  Future<FundAdjustment?> _latestIssue(List<FundAdjustment> rows) async {
    for (final row in rows.reversed) {
      if (row.adjustmentType == 'QARZA_DISBURSEMENT') return row;
    }
    return null;
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _recover() async {
    final rows = await _rows();
    final outstanding = rows.fold<double>(
      0,
      (sum, row) => sum +
          (row.adjustmentType == 'QARZA_DISBURSEMENT' ? row.amount : -row.amount),
    );
    if (!mounted || outstanding <= .005) return;

    final issue = await _latestIssue(rows);
    if (issue == null) {
      _show('Original Qarz issue details could not be found.');
      return;
    }

    final amount = TextEditingController();
    final reference = TextEditingController(text: 'N/A');
    final verification = TextEditingController();
    final verifiedBy1 = TextEditingController();
    final verifiedBy2 = TextEditingController();
    final verifiedBy3 = TextEditingController();
    final remarks = TextEditingController();
    var mode = 'Cash';
    var transactionDate = DateTime.now();

    final result = await showDialog<_QarzRecoveryResult>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) {
          final entered = double.tryParse(
                amount.text.replaceAll(',', '').replaceAll('₹', '').trim(),
              ) ??
              0;
          Widget verifier(String label, TextEditingController controller) {
            final current = kUserPasswords.containsKey(controller.text) ? controller.text : null;
            return DropdownButtonFormField<String>(
              initialValue: current,
              decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
              items: kUserPasswords.keys
                  .map((name) => DropdownMenuItem<String>(value: name, child: Text(name)))
                  .toList(),
              onChanged: (value) => setLocalState(() => controller.text = value ?? ''),
            );
          }

          return AlertDialog(
            title: Text('Receive from ${widget.borrowerName}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Outstanding: ₹${outstanding.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amount,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setLocalState(() {}),
                    decoration: const InputDecoration(labelText: 'Amount Returned *', prefixText: '₹ ', border: OutlineInputBorder()),
                  ),
                  if (entered > 0) ...[
                    const SizedBox(height: 6),
                    Text('Amount in Words: ${ReceiptActions.amountInWords(entered)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final today = DateTime.now();
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: transactionDate,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(today.year, today.month, today.day),
                      );
                      if (picked == null) return;
                      setLocalState(() => transactionDate = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            transactionDate.hour,
                            transactionDate.minute,
                            transactionDate.second,
                          ));
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Transaction Date *', border: OutlineInputBorder()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(ReceiptActions.formatDate(transactionDate)), const Icon(Icons.calendar_today_outlined)],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: RadioListTile<String>(contentPadding: EdgeInsets.zero, title: const Text('Cash'), value: 'Cash', groupValue: mode, onChanged: (v) => v == null ? null : setLocalState(() => mode = v))),
                      Expanded(child: RadioListTile<String>(contentPadding: EdgeInsets.zero, title: const Text('Bank'), value: 'Bank Transfer', groupValue: mode, onChanged: (v) => v == null ? null : setLocalState(() => mode = v))),
                    ],
                  ),
                  TextField(controller: reference, decoration: const InputDecoration(labelText: 'Cheque / Payment Reference *', border: OutlineInputBorder())),
                  const SizedBox(height: 10),
                  TextField(controller: verification, maxLines: 5, decoration: const InputDecoration(labelText: 'Verification *', border: OutlineInputBorder(), alignLabelWithHint: true)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: verifier('Verified by 1 *', verifiedBy1)),
                    const SizedBox(width: 8),
                    Expanded(child: verifier('Verified by 2 *', verifiedBy2)),
                    const SizedBox(width: 8),
                    Expanded(child: verifier('Verified by 3 *', verifiedBy3)),
                  ]),
                  const SizedBox(height: 10),
                  TextField(controller: remarks, maxLines: 5, decoration: const InputDecoration(labelText: 'Remarks *', border: OutlineInputBorder(), alignLabelWithHint: true)),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              FilledButton(
                onPressed: () async {
                  final value = double.tryParse(amount.text.replaceAll(',', '').replaceAll('₹', '').trim()) ?? 0;
                  if (value <= 0 || value > outstanding + .005) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Enter an amount not greater than the outstanding Qarz.')));
                    return;
                  }
                  if (reference.text.trim().isEmpty ||
                      verification.text.trim().isEmpty ||
                      verifiedBy1.text.trim().isEmpty ||
                      verifiedBy2.text.trim().isEmpty ||
                      verifiedBy3.text.trim().isEmpty ||
                      remarks.text.trim().isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Payment reference, verification, all three verifiers and remarks are required.')));
                    return;
                  }
                  final documentNumber = await _nextRecoveryNumber();
                  await widget.database.into(widget.database.fundAdjustments).insert(
                    FundAdjustmentsCompanion.insert(
                      transactionDate: Value(transactionDate),
                      adjustmentType: 'QARZA_RECOVERY',
                      amount: value,
                      paymentMode: mode,
                      chequeNumber: Value(reference.text.trim()),
                      documentNumber: Value(documentNumber),
                      partyName: Value(widget.borrowerName),
                      address: Value(issue.address),
                      aadhaarNumber: Value(issue.aadhaarNumber),
                      phoneNumber: Value(issue.phoneNumber),
                      verification: Value(verification.text.trim()),
                      verifiedBy1: Value(verifiedBy1.text.trim()),
                      verifiedBy2: Value(verifiedBy2.text.trim()),
                      verifiedBy3: Value(verifiedBy3.text.trim()),
                      remarks: Value(remarks.text.trim()),
                      username: Value(currentUsername ?? 'Legacy'),
                    ),
                  );
                  if (ctx.mounted) {
                    Navigator.of(ctx).pop(_QarzRecoveryResult(
                      amount: value,
                      documentNumber: documentNumber,
                      paymentMode: mode,
                      date: transactionDate,
                      reference: reference.text.trim(),
                      verification: verification.text.trim(),
                      verifiedBy1: verifiedBy1.text.trim(),
                      verifiedBy2: verifiedBy2.text.trim(),
                      verifiedBy3: verifiedBy3.text.trim(),
                      remarks: remarks.text.trim(),
                      username: currentUsername ?? 'Legacy',
                      address: issue.address ?? '',
                      aadhaar: issue.aadhaarNumber ?? '',
                      phone: issue.phoneNumber ?? '',
                      outstandingAfter: outstanding - value,
                    ));
                  }
                },
                child: const Text('Receive & Save'),
              ),
            ],
          );
        },
      ),
    );

    for (final controller in [amount, reference, verification, verifiedBy1, verifiedBy2, verifiedBy3, remarks]) {
      controller.dispose();
    }
    if (result == null || !mounted) return;

    setState(() {
      _future = _rows();
    });
    final recoveryConditions = await WorkflowService.conditions(widget.database, result.documentNumber);
    await ReceiptActions.showActionsDialog(
      context: context,
      documentNumber: result.documentNumber,
      title: 'Qarz Recovery Voucher',
      fileNamePrefix: 'QH-IN',
      shareMessage: 'Al-Amin Baitul Maal - Qarz recovery ${result.documentNumber}\nBorrower: ${widget.borrowerName}\nReturned: INR ${result.amount.toStringAsFixed(2)}\nOutstanding: INR ${result.outstandingAfter.toStringAsFixed(2)}',
      buildPdf: () async => ReceiptActions.qarzaVoucherDocument(
        documentNumber: result.documentNumber,
        date: result.date,
        party: widget.borrowerName,
        address: result.address,
        aadhaar: result.aadhaar,
        phone: result.phone,
        amount: result.amount,
        chequeNumber: result.reference,
        paymentMode: result.paymentMode,
        operation: 'RECOVERY',
        conditions: recoveryConditions,
        verification: result.verification,
        verifiedBy1: result.verifiedBy1,
        verifiedBy2: result.verifiedBy2,
        verifiedBy3: result.verifiedBy3,
        remarks: '${result.remarks}\nOutstanding After Recovery: INR ${result.outstandingAfter.toStringAsFixed(2)}',
        preparedBy: result.username,
      ).save(),
    );
  }

  Future<String> _nextRecoveryNumber() async {
    final rows = await widget.database.select(widget.database.fundAdjustments).get();
    var highest = 0;
    for (final row in rows) {
      final number = row.documentNumber;
      if (number == null || !number.startsWith('QH-IN-')) continue;
      final parsed = int.tryParse(number.substring('QH-IN-'.length));
      if (parsed != null && parsed > highest) highest = parsed;
    }
    return 'QH-IN-${(highest + 1).toString().padLeft(6, '0')}';
  }

  Future<void> _edit(FundAdjustment row) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditTransactionPage(
          database: widget.database,
          source: LedgerSource.fundAdjustment,
          id: row.id,
          title: row.adjustmentType == 'QARZA_DISBURSEMENT' ? 'Qarz Issued' : 'Qarz Recovery',
        ),
      ),
    );
    if (changed == true && mounted) setState(() {
      _future = _rows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.borrowerName} — Qarz Ledger'),
        actions: [
          FutureBuilder<List<FundAdjustment>>(
            future: _future,
            builder: (context, snap) {
              final rows = snap.data ?? const <FundAdjustment>[];
              final outstanding = rows.fold<double>(0, (s, r) => s + (r.adjustmentType == 'QARZA_DISBURSEMENT' ? r.amount : -r.amount));
              return IconButton(tooltip: 'Receive Qarz Payment', onPressed: outstanding > .005 ? _recover : null, icon: const Icon(Icons.payments_outlined));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<FundAdjustment>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('Could not load ledger:\n${snap.error}', textAlign: TextAlign.center)));
          final rows = snap.data!;
          final outstanding = rows.fold<double>(0, (s, r) => s + (r.adjustmentType == 'QARZA_DISBURSEMENT' ? r.amount : -r.amount));
          return Column(children: [
            Card(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: ListTile(
                title: const Text('Current Running Balance', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('₹${outstanding.clamp(0, double.infinity).toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: outstanding > .005 ? Colors.red.shade700 : Colors.green.shade700)),
                subtitle: const Text('Amount still receivable from borrower'),
              ),
            ),
            Expanded(
              child: rows.isEmpty
                  ? const Center(child: Text('No Qarz transactions found.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Amount Borrowed')),
                            DataColumn(label: Text('Amount Returned')),
                            DataColumn(label: Text('Cheque / Ref.')),
                            DataColumn(label: Text('Receipt / Form No.')),
                            DataColumn(label: Text('Running Balance')),
                            DataColumn(label: Text('User')),
                            DataColumn(label: Text('Remarks')),
                            DataColumn(label: Text('Edit')),
                          ],
                          rows: [
                            for (var i = 0; i < rows.length; i++)
                              DataRow(cells: [
                                DataCell(Text(ReceiptActions.formatDate(rows[i].transactionDate))),
                                DataCell(Text(rows[i].adjustmentType == 'QARZA_DISBURSEMENT' ? '₹${rows[i].amount.toStringAsFixed(2)}' : '—')),
                                DataCell(Text(rows[i].adjustmentType == 'QARZA_RECOVERY' ? '₹${rows[i].amount.toStringAsFixed(2)}' : '—')),
                                DataCell(Text(rows[i].chequeNumber?.trim().isNotEmpty == true ? rows[i].chequeNumber! : '—')),
                                DataCell(Text(rows[i].documentNumber ?? '—')),
                                DataCell(Text('₹${_balanceAfter(rows, i).toStringAsFixed(2)}')),
                                DataCell(Text(rows[i].username)),
                                DataCell(Text(rows[i].remarks ?? '—')),
                                DataCell(IconButton(tooltip: 'Edit / Delete', icon: const Icon(Icons.edit_outlined), onPressed: () => _edit(rows[i]))),
                              ]),
                          ],
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: outstanding > .005 ? _recover : null, icon: const Icon(Icons.payments_outlined), label: const Text('Receive Payment'))),
            ),
          ]);
        },
      ),
    );
  }
}

class _QarzRecoveryResult {
  final double amount;
  final String documentNumber;
  final String paymentMode;
  final DateTime date;
  final String reference;
  final String verification;
  final String verifiedBy1;
  final String verifiedBy2;
  final String verifiedBy3;
  final String remarks;
  final String username;
  final String address;
  final String aadhaar;
  final String phone;
  final double outstandingAfter;

  _QarzRecoveryResult({
    required this.amount,
    required this.documentNumber,
    required this.paymentMode,
    required this.date,
    required this.reference,
    required this.verification,
    required this.verifiedBy1,
    required this.verifiedBy2,
    required this.verifiedBy3,
    required this.remarks,
    required this.username,
    required this.address,
    required this.aadhaar,
    required this.phone,
    required this.outstandingAfter,
  });
}
