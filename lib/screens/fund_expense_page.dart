import 'dart:typed_data';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/accounting_service.dart';
import '../database/workflow_service.dart';
import 'brand.dart';
import 'available_balance_card.dart';
import 'receipt_actions.dart';
import 'security.dart';
import 'signature_pad.dart';
import 'app_ui.dart';

class FundExpensePage extends StatefulWidget {
  final AppDatabase database;
  final String title;
  final String adjustmentType;
  final String prefix;
  final String fundLabel;

  const FundExpensePage({super.key, required this.database, required this.title, required this.adjustmentType, required this.prefix, required this.fundLabel});

  @override
  State<FundExpensePage> createState() => _FundExpensePageState();
}

class _FundExpensePageState extends State<FundExpensePage> {
  final _party = TextEditingController();
  final _amount = TextEditingController();
  final _cheque = TextEditingController();
  final _remarks = TextEditingController();
  final _verification = TextEditingController();
  final _verifiedBy1 = TextEditingController();
  final _verifiedBy2 = TextEditingController();
  final _verifiedBy3 = TextEditingController();
  DateTime _date = DateTime.now();
  Uint8List? _recipientSignature;
  Uint8List? _accountantSignature;
  bool _saving = false;

  @override
  void dispose() {
    _party.dispose();
    _amount.dispose();
    _cheque.dispose();
    _remarks.dispose();
    _verification.dispose();
    _verifiedBy1.dispose();
    _verifiedBy2.dispose();
    _verifiedBy3.dispose();
    super.dispose();
  }

  double _parse(String s) => double.tryParse(s.replaceAll(',', '').replaceAll('₹', '').trim()) ?? 0;

  Future<double> _availableFund() async {
    if (widget.adjustmentType == 'SADQA_EXPENSE') {
      return AccountingService.availableSadqa(widget.database);
    }
    return AccountingService.availableDonations(widget.database);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(1950), lastDate: DateTime(now.year, now.month, now.day));
    if (!mounted || picked == null) return;
    setState(() => _date = DateTime(picked.year, picked.month, picked.day, now.hour, now.minute, now.second));
  }

  Future<String> _nextNumber() async {
    final rows = await widget.database.select(widget.database.fundAdjustments).get();
    var highest = 0;
    final prefix = '${widget.prefix}-';
    for (final row in rows) {
      final value = row.documentNumber;
      if (value == null || !value.startsWith(prefix)) continue;
      final number = int.tryParse(value.substring(prefix.length));
      if (number != null && number > highest) highest = number;
    }
    return '$prefix${(highest + 1).toString().padLeft(6, '0')}';
  }

  Future<Uint8List> _pdf(String documentNumber, double amount) async {
    final doc = ReceiptActions.fundAdjustmentVoucherDocument(
      title: widget.title.toUpperCase(),
      documentNumber: documentNumber,
      date: _date,
      fundLabel: widget.fundLabel,
      party: _party.text.trim(),
      amount: amount,
      paymentMode: 'Cheque',
      chequeNumber: _cheque.text.trim(),
      verification: _verification.text.trim(),
      verifiedBy1: _verifiedBy1.text.trim(),
      verifiedBy2: _verifiedBy2.text.trim(),
      verifiedBy3: _verifiedBy3.text.trim(),
      remarks: _remarks.text.trim(),
      recipientSignature: _recipientSignature,
      accountantSignature: _accountantSignature,
      preparedBy: currentUsername ?? 'Legacy',
    );
    return doc.save();
  }

  Future<void> _save() async {
    if (_saving) return;
    final party = _party.text.trim();
    final amount = _parse(_amount.text);
    final remarks = _remarks.text.trim();
    if (party.isEmpty || amount <= 0 || remarks.isEmpty || _cheque.text.trim().isEmpty) {
      _show('Particulars, amount and cheque number are required.');
      return;
    }
    if (widget.adjustmentType == 'SADQA_EXPENSE') {
      if (_verification.text.trim().isEmpty ||
          _verifiedBy1.text.trim().isEmpty ||
          _verifiedBy2.text.trim().isEmpty ||
          _verifiedBy3.text.trim().isEmpty) {
        _show('Verification and all three verifier names are required for Sadqa-e-Fitr.');
        return;
      }
    }
    if (_recipientSignature == null || _recipientSignature!.isEmpty) {
      _show('Recipient / party signature is required.');
      return;
    }
    if (_accountantSignature == null || _accountantSignature!.isEmpty) {
      _show('Accountant signature is required.');
      return;
    }
    final available = await _availableFund();
    if (amount > available + .005) {
      _show('${widget.title} cannot exceed the available ${widget.fundLabel} balance of ₹${available.toStringAsFixed(2)}.');
      return;
    }

    setState(() => _saving = true);
    try {
      final number = await _nextNumber();
      await widget.database.into(widget.database.fundAdjustments).insert(
        FundAdjustmentsCompanion.insert(
          transactionDate: Value(_date),
          adjustmentType: widget.adjustmentType,
          amount: amount,
          paymentMode: 'Cheque',
          documentNumber: Value(number),
          chequeNumber: Value(_cheque.text.trim()),
          partyName: Value(party),
          remarks: Value(remarks),
          verifiedBy1: Value(widget.adjustmentType == 'SADQA_EXPENSE' ? _verifiedBy1.text.trim() : null),
          verifiedBy2: Value(widget.adjustmentType == 'SADQA_EXPENSE' ? _verifiedBy2.text.trim() : null),
          verifiedBy3: Value(widget.adjustmentType == 'SADQA_EXPENSE' ? _verifiedBy3.text.trim() : null),
          verification: Value(widget.adjustmentType == 'SADQA_EXPENSE' ? _verification.text.trim() : null),
          recipientSignature: Value(_recipientSignature),
          accountantSignature: Value(_accountantSignature),
          username: Value(currentUsername ?? 'Legacy'),
        ),
      );
      if (widget.adjustmentType == 'OTHER_EXPENSE') {
        final saved = await (widget.database.select(widget.database.fundAdjustments)
              ..where((a) => a.documentNumber.equals(number)))
            .getSingle();
        await WorkflowService.requestChequeApproval(
          widget.database,
          sourceTable: 'fund_adjustments',
          transactionId: saved.id,
          requestedBy: currentUsername ?? 'Legacy',
        );
      }
      if (!mounted) return;
      await ReceiptActions.showActionsDialog(
        context: context,
        documentNumber: number,
        title: '${widget.title} Saved',
        fileNamePrefix: widget.prefix,
        shareMessage: 'Al-Amin Baitul Maal - ${widget.title} $number\nDate: ${ReceiptActions.formatDate(_date)}\nAmount: INR ${amount.toStringAsFixed(2)}',
        buildPdf: () => _pdf(number, amount),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) _show('Could not save: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _verifierDropdown(String label, TextEditingController controller) {
    final current = kUserPasswords.containsKey(controller.text) ? controller.text : null;
    return DropdownButtonFormField<String>(
      initialValue: current,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: kUserPasswords.keys.map((name) => DropdownMenuItem<String>(value: name, child: Text(name))).toList(),
      onChanged: _saving ? null : (value) => setState(() => controller.text = value ?? ''),
    );
  }

  void _show(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  InputDecoration _d(String label, {String? helper, bool multiline = false}) => InputDecoration(
        labelText: label,
        helperText: helper,
        alignLabelWithHint: multiline,
        filled: true,
        fillColor: const Color(0xFFF1F6F4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withValues(alpha: .25))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withValues(alpha: .25))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBrandGreen, width: 1.4)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: AppDesktopShell(selected: widget.adjustmentType == 'SADQA_EXPENSE' ? 'Sadqa-e-Fitr' : 'Other Expense', child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth >= 900 ? 980.0 : 680.0;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppPageHeader(
                      title: widget.title,
                      subtitle: 'Record an expenditure from the ${widget.fundLabel} fund',
                      icon: widget.adjustmentType == 'SADQA_EXPENSE' ? Icons.card_giftcard_rounded : Icons.receipt_long_rounded,
                    ),
                    AvailableBalanceCard(label: 'Available ${widget.fundLabel} Balance', future: _availableFund()),
                    const SizedBox(height: 14),
                    AppFormSection(
                      title: 'Transaction Details',
                      icon: Icons.description_outlined,
                      child: Column(
                        children: [
                          TextField(controller: _party, enabled: !_saving, decoration: _d('Party / Description *', helper: 'This transaction is deducted from ${widget.fundLabel}.')),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: _saving ? null : _pickDate,
                            child: InputDecorator(
                              decoration: _d('Transaction Date *'),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(ReceiptActions.formatDate(_date)), const Icon(Icons.calendar_today_outlined)]),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(controller: _cheque, enabled: !_saving, decoration: _d('Cheque Number *')),
                          const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.account_balance_outlined, color: kBrandGreen), title: Text('Payment Mode', style: TextStyle(fontWeight: FontWeight.w700)), subtitle: Text('Cheque only')),
                        ],
                      ),
                    ),
                    AppFormSection(
                      title: 'Amount',
                      icon: Icons.payments_outlined,
                      child: TextField(controller: _amount, enabled: !_saving, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: _d('Amount *').copyWith(prefixText: '₹ ')),
                    ),
                    if (widget.adjustmentType == 'SADQA_EXPENSE')
                      AppFormSection(
                        title: 'Verification',
                        icon: Icons.verified_user_outlined,
                        child: Column(
                          children: [
                            TextField(controller: _verification, enabled: !_saving, maxLines: 7, decoration: _d('Verification *', multiline: true)),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(child: _verifierDropdown('Verified by 1 *', _verifiedBy1)),
                              const SizedBox(width: 10),
                              Expanded(child: _verifierDropdown('Verified by 2 *', _verifiedBy2)),
                              const SizedBox(width: 10),
                              Expanded(child: _verifierDropdown('Verified by 3 *', _verifiedBy3)),
                            ]),
                          ],
                        ),
                      ),
                    AppFormSection(
                      title: 'Particulars / Description',
                      icon: Icons.notes_outlined,
                      child: TextField(controller: _remarks, enabled: !_saving, maxLines: 4, decoration: _d('Particulars / Description *', multiline: true)),
                    ),
                    AppFormSection(
                      title: 'Signatures',
                      icon: Icons.draw_outlined,
                      child: Column(
                        children: [
                          SignaturePad(label: 'Recipient / Party Signature *', onChanged: (bytes) => setState(() => _recipientSignature = bytes)),
                          const SizedBox(height: 12),
                          SignaturePad(label: 'Accountant Signature *', onChanged: (bytes) => setState(() => _accountantSignature = bytes)),
                        ],
                      ),
                    ),
                    FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save_rounded), label: Text(_saving ? 'Saving...' : 'Save Entry')),
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }

}
