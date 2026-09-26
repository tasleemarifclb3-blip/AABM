import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/accounting_service.dart';
import '../database/workflow_service.dart';
import 'security.dart';
import 'qarza_hassanah_page.dart';
import 'available_balance_card.dart';

class LedgerSource {
  static const memberPayment = 'MEMBER_PAYMENT';
  static const memberConcession = 'MEMBER_CONCESSION';
  static const financial = 'FINANCIAL';
  static const fundAdjustment = 'FUND_ADJUSTMENT';
  static const zakaat = 'ZAKAAT';
  static const qarzaWaiver = 'QARZA_WAIVER';
}

class EditTransactionPage extends StatefulWidget {
  final AppDatabase database;
  final String source;
  final int id;
  final String title;
  final bool deleteOnOpen;
  const EditTransactionPage({
    super.key,
    required this.database,
    required this.source,
    required this.id,
    required this.title,
    this.deleteOnOpen = false,
  });
  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  late DateTime _date;
  final _amount = TextEditingController();
  final _name = TextEditingController();
  final _remarks = TextEditingController();
  final _cheque = TextEditingController();
  String _mode = 'Cash';
  bool _loading = true;
  bool _saving = false;
  bool _authorized = false;
  String? _loadError;
  dynamic _record;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ok = await requireSuperuserPassword(context, title: 'Authorize Edit');
      if (!mounted) return;
      if (!ok) { Navigator.of(context).pop(false); return; }
      setState(() => _authorized = true);
      await _load();
      if (widget.deleteOnOpen && mounted && _loadError == null && _record != null) {
        await _delete(authorizationAlreadyGranted: true);
      }
    });
  }

  @override
  void dispose() { _amount.dispose(); _name.dispose(); _remarks.dispose(); _cheque.dispose(); super.dispose(); }

  Future<void> _load() async {
    try {
      switch (widget.source) {
        case LedgerSource.memberPayment:
          _record = await (widget.database.select(widget.database.householdPayments)..where((t) => t.id.equals(widget.id))).getSingle();
          _date = _record.paymentDate; _amount.text = _record.amount.toStringAsFixed(2); _mode = _record.paymentMode;
          break;
        case LedgerSource.memberConcession:
          _record = await (widget.database.select(widget.database.householdConcessions)..where((t) => t.id.equals(widget.id))).getSingle();
          _date = _record.concessionDate; _amount.text = _record.amount.toStringAsFixed(2); _remarks.text = _record.remarks ?? '';
          break;
        case LedgerSource.financial:
          _record = await (widget.database.select(widget.database.financialTransactions)..where((t) => t.id.equals(widget.id))).getSingle();
          _date = _record.transactionDate; _amount.text = _record.amount.toStringAsFixed(2); _mode = _record.paymentMode; _name.text = _record.donorName ?? ''; _remarks.text = _record.remarks ?? '';
          break;
        case LedgerSource.fundAdjustment:
          _record = await (widget.database.select(widget.database.fundAdjustments)..where((t) => t.id.equals(widget.id))).getSingle();
          _date = _record.transactionDate; _amount.text = _record.amount.toStringAsFixed(2); _mode = _record.paymentMode; _cheque.text = _record.chequeNumber ?? ''; _name.text = _record.partyName ?? ''; _remarks.text = _record.remarks ?? '';
          break;
        case LedgerSource.zakaat:
          _record = await (widget.database.select(widget.database.zakaatDisbursements)..where((t) => t.id.equals(widget.id))).getSingle();
          _date = _record.disbursementDate; _amount.text = _record.amount.toStringAsFixed(2); _mode = _record.paymentMode; _name.text = _record.recipientName; _remarks.text = _record.remarks ?? ''; _cheque.text = _record.chequeNumber ?? '';
          break;
        case LedgerSource.qarzaWaiver:
          final waiverRows = await WorkflowService.qarzaWaivers(widget.database);
          _record = waiverRows.firstWhere((w) => w.id == widget.id);
          _date = _record.date;
          _amount.text = _record.amount.toStringAsFixed(2);
          _name.text = _record.borrowerName;
          _remarks.text = _record.remarks;
          break;
      }
      if (mounted) setState(() { _loading = false; _loadError = null; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _loadError = 'Could not load transaction: $e'; });
    }
  }

  double _parse() => double.tryParse(_amount.text.replaceAll(',', '').replaceAll('₹', '').trim()) ?? 0;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(1950), lastDate: DateTime(now.year, now.month, now.day));
    if (!mounted || picked == null) return;
    setState(() => _date = DateTime(picked.year, picked.month, picked.day, _date.hour, _date.minute, _date.second));
  }

  Future<double> _fundAvailable(String fund, {int? excludeId}) async {
    switch (fund) {
      case 'ZAKAAT': return AccountingService.availableZakaat(widget.database, excludeDisbursementId: excludeId);
      case 'SADQA_FITR': return AccountingService.availableSadqa(widget.database, excludeAdjustmentId: excludeId);
      default: return AccountingService.availableDonations(widget.database, excludeAdjustmentId: excludeId);
    }
  }

  Future<double> _qarzaOutstanding({int? excludeId}) => AccountingService.qarzaOutstanding(widget.database, excludeAdjustmentId: excludeId);
  Future<void> _rebuildMemberAllocations(int householdId) => AccountingService.rebuildHouseholdAllocations(widget.database, householdId);

  Future<void> _delete({bool authorizationAlreadyGranted = false}) async {
    if (!authorizationAlreadyGranted) {
      final authorized = await requireSuperuserPassword(
        context,
        title: 'Confirm Delete',
        message: 'Deleting a saved transaction is permanent. Enter the superuser password to continue.',
      );
      if (!authorized || !mounted) return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: const Text('This action cannot be undone. Delete the saved accounting transaction?'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), FilledButton.tonal(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete'))],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => _saving = true);
    try {
      final originalReference = switch (widget.source) {
        LedgerSource.memberPayment => _record.receiptNumber as String?,
        LedgerSource.memberConcession => _record.receiptNumber as String?,
        LedgerSource.financial => _record.receiptNumber as String?,
        LedgerSource.fundAdjustment => _record.documentNumber as String?,
        LedgerSource.zakaat => _record.voucherNumber as String?,
        LedgerSource.qarzaWaiver => _record.waiverNumber as String?,
        _ => null,
      };
      final originalAmount = (_record.amount as num).toDouble();
      final originalUser = _record.username as String?;
      final audit = FundAdjustmentsCompanion.insert(
        transactionDate: Value(DateTime.now()), adjustmentType: 'DELETED_RECEIPT', amount: originalAmount, paymentMode: 'N/A',
        documentNumber: Value(originalReference ?? '—'), partyName: Value(widget.title),
        remarks: Value('Original source: ${widget.source}; original user: ${originalUser ?? 'Legacy'}; original ID: ${widget.id}'), username: Value(currentUsername ?? 'Legacy'),
      );
      await widget.database.transaction(() async {
        await widget.database.into(widget.database.fundAdjustments).insert(audit);
        switch (widget.source) {
          case LedgerSource.memberPayment:
            final householdId = _record.householdId as int;
            await (widget.database.delete(widget.database.paymentAllocations)..where((x) => x.paymentId.equals(widget.id))).go();
            await (widget.database.delete(widget.database.openingBalancePaymentAllocations)..where((x) => x.paymentId.equals(widget.id))).go();
            await (widget.database.delete(widget.database.householdPayments)..where((x) => x.id.equals(widget.id))).go();
            await AccountingService.rebuildHouseholdAllocations(widget.database, householdId, transaction: false);
            break;
          case LedgerSource.memberConcession:
            final householdId = _record.householdId as int;
            await (widget.database.delete(widget.database.householdConcessionAllocations)..where((x) => x.concessionId.equals(widget.id))).go();
            await (widget.database.delete(widget.database.openingBalanceConcessionAllocations)..where((x) => x.concessionId.equals(widget.id))).go();
            await (widget.database.delete(widget.database.householdConcessions)..where((x) => x.id.equals(widget.id))).go();
            await AccountingService.rebuildHouseholdAllocations(widget.database, householdId, transaction: false);
            break;
          case LedgerSource.financial:
            await (widget.database.delete(widget.database.financialTransactions)..where((x) => x.id.equals(widget.id))).go();
            break;
          case LedgerSource.fundAdjustment:
            await (widget.database.delete(widget.database.fundAdjustments)..where((x) => x.id.equals(widget.id))).go();
            break;
          case LedgerSource.zakaat:
            await (widget.database.delete(widget.database.zakaatDisbursements)..where((x) => x.id.equals(widget.id))).go();
            break;
          case LedgerSource.qarzaWaiver:
            await WorkflowService.deleteQarzaWaiver(widget.database, widget.id);
            break;
        }
      });
      if (widget.source == LedgerSource.fundAdjustment) {
        await WorkflowService.removeChequeApproval(widget.database, sourceTable: 'fund_adjustments', transactionId: widget.id);
        if (originalReference?.isNotEmpty == true) await WorkflowService.removeParentage(widget.database, originalReference!);
      } else if (widget.source == LedgerSource.zakaat) {
        await WorkflowService.removeChequeApproval(widget.database, sourceTable: 'zakaat_disbursements', transactionId: widget.id);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) _show('Could not delete transaction: $e');
    } finally { if (mounted) setState(() => _saving = false); }
  }

  Future<void> _save() async {
    if (_saving) return;
    final amount = _parse();
    if (amount < 0) { _show('Amount cannot be negative.'); return; }
    setState(() => _saving = true);
    try {
      switch (widget.source) {
        case LedgerSource.memberPayment:
          if (amount <= 0) throw Exception('Amount must be greater than zero.');
          await (widget.database.update(widget.database.householdPayments)..where((t) => t.id.equals(widget.id))).write(HouseholdPaymentsCompanion(paymentDate: Value(_date), amount: Value(amount), paymentMode: Value(_mode)));
          await _rebuildMemberAllocations(_record.householdId);
          break;
        case LedgerSource.memberConcession:
          if (amount <= 0) throw Exception('Concession must be greater than zero.');
          await (widget.database.update(widget.database.householdConcessions)..where((t) => t.id.equals(widget.id))).write(HouseholdConcessionsCompanion(concessionDate: Value(_date), amount: Value(amount), remarks: Value(_remarks.text.trim().isEmpty ? null : _remarks.text.trim())));
          await _rebuildMemberAllocations(_record.householdId);
          break;
        case LedgerSource.financial:
          if (amount <= 0) throw Exception('Amount must be greater than zero.');
          await (widget.database.update(widget.database.financialTransactions)..where((t) => t.id.equals(widget.id))).write(FinancialTransactionsCompanion(transactionDate: Value(_date), amount: Value(amount), paymentMode: Value(_mode), donorName: Value(_name.text.trim().isEmpty ? null : _name.text.trim()), remarks: Value(_remarks.text.trim().isEmpty ? null : _remarks.text.trim())));
          break;
        case LedgerSource.fundAdjustment:
          if (amount <= 0) throw Exception('Amount must be greater than zero.');
          final type = _record.adjustmentType as String;
          final available = type == 'QARZA_RECOVERY' ? await _qarzaOutstanding(excludeId: widget.id) : type == 'SADQA_EXPENSE' ? await _fundAvailable('SADQA_FITR', excludeId: widget.id) : await _fundAvailable('DONATIONS', excludeId: widget.id);
          if (amount > available + .005) throw Exception(type == 'QARZA_RECOVERY' ? 'Recovery exceeds outstanding Qarza of ₹${available.toStringAsFixed(2)}.' : 'Amount exceeds the available fund of ₹${available.toStringAsFixed(2)}.');
          final paymentMode = type == 'QARZA_DISBURSEMENT' || type == 'OTHER_EXPENSE' ? 'Cheque' : _mode;
          if ((type == 'QARZA_DISBURSEMENT' || type == 'OTHER_EXPENSE') && _cheque.text.trim().isEmpty) throw Exception('Cheque number is required.');
          await (widget.database.update(widget.database.fundAdjustments)..where((t) => t.id.equals(widget.id))).write(FundAdjustmentsCompanion(transactionDate: Value(_date), amount: Value(amount), paymentMode: Value(paymentMode), chequeNumber: Value(_cheque.text.trim().isEmpty ? null : _cheque.text.trim()), partyName: Value(_name.text.trim().isEmpty ? null : _name.text.trim()), remarks: Value(_remarks.text.trim().isEmpty ? null : _remarks.text.trim())));
          if (type == 'QARZA_DISBURSEMENT' || type == 'OTHER_EXPENSE') await WorkflowService.requestChequeApproval(widget.database, sourceTable: 'fund_adjustments', transactionId: widget.id, requestedBy: currentUsername ?? 'Legacy');
          break;
        case LedgerSource.zakaat:
          if (amount <= 0) throw Exception('Amount must be greater than zero.');
          if (_cheque.text.trim().isEmpty) throw Exception('Cheque number is required.');
          final available = await _fundAvailable('ZAKAAT', excludeId: widget.id);
          if (amount > available + .005) throw Exception('Amount exceeds available Zakaat of ₹${available.toStringAsFixed(2)}.');
          await (widget.database.update(widget.database.zakaatDisbursements)..where((t) => t.id.equals(widget.id))).write(ZakaatDisbursementsCompanion(disbursementDate: Value(_date), amount: Value(amount), chequeNumber: Value(_cheque.text.trim()), recipientName: Value(_name.text.trim()), remarks: Value(_remarks.text.trim())));
          await WorkflowService.requestChequeApproval(widget.database, sourceTable: 'zakaat_disbursements', transactionId: widget.id, requestedBy: currentUsername ?? 'Legacy');
          break;
        case LedgerSource.qarzaWaiver:
          if (amount <= 0) throw Exception('Waiver amount must be greater than zero.');
          final borrower = _record.borrowerName as String;
          final available = await WorkflowService.qarzaOutstandingForBorrower(widget.database, borrower, excludeWaiverId: widget.id);
          if (amount > available + .005) {
            throw Exception("Waiver cannot exceed the borrower's outstanding Qarza of ₹${available.toStringAsFixed(2)}.");
          }
          final zakaatAvailable = await AccountingService.availableZakaat(widget.database);
          // The current waiver is already included in availableZakaat(), so add
          // it back when determining the limit for this edit.
          final currentWaiverAmount = (_record.amount as num).toDouble();
          final zakaatAvailableForEdit = zakaatAvailable + currentWaiverAmount;
          if (amount > zakaatAvailableForEdit + .005) {
            throw Exception('Qarza waiver cannot exceed available Zakaat of ₹${zakaatAvailableForEdit.toStringAsFixed(2)}.');
          }
          await WorkflowService.updateQarzaWaiver(
            widget.database,
            id: widget.id,
            date: _date,
            amount: amount,
            remarks: _remarks.text.trim(),
          );
          break;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction updated successfully.')));
      Navigator.pop(context, true);
    } catch (e) { if (mounted) _show('Could not update transaction: $e'); }
    finally { if (mounted) setState(() => _saving = false); }
  }

  void _show(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    if (!_authorized || _loading) return Scaffold(appBar: AppBar(title: Text(widget.title)), body: const Center(child: CircularProgressIndicator()));
    if (_loadError != null || _record == null) return Scaffold(appBar: AppBar(title: Text(widget.title)), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(_loadError ?? 'Transaction could not be found.', textAlign: TextAlign.center))));
    final isMemberConcession = widget.source == LedgerSource.memberConcession;
    final isZakaat = widget.source == LedgerSource.zakaat;
    final isFund = widget.source == LedgerSource.fundAdjustment;
    final isWaiver = widget.source == LedgerSource.qarzaWaiver;
    final type = isFund ? (_record.adjustmentType as String) : '';
    final isChequeOnly = isZakaat || type == 'QARZA_DISBURSEMENT' || type == 'OTHER_EXPENSE';
    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.title}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (isWaiver)
            AvailableBalanceCard(
              label: 'Available Zakaat Balance for Waiver',
              future: AccountingService.availableZakaat(widget.database).then(
                (value) => value + ((_record.amount as num).toDouble()),
              ),
            ),
          if (isWaiver) const SizedBox(height: 12),
          Text('Transaction Date', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          OutlinedButton.icon(onPressed: _saving ? null : _pickDate, icon: const Icon(Icons.calendar_today_outlined), label: Text('${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}')),
          const SizedBox(height: 12),
          if (isWaiver) ...[
            TextField(controller: _name, readOnly: true, decoration: const InputDecoration(labelText: 'Borrower', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            InputDecorator(decoration: const InputDecoration(labelText: 'Original Qarza', border: OutlineInputBorder()), child: Text(_record.originalQarzaNumber)),
            const SizedBox(height: 12),
          ] else ...[
            if (!isMemberConcession) TextField(controller: _name, enabled: !_saving, decoration: InputDecoration(labelText: isZakaat ? 'Recipient Name' : 'Name / Party', border: const OutlineInputBorder())),
            if (!isMemberConcession) const SizedBox(height: 12),
          ],
          TextField(controller: _amount, enabled: !_saving, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹ ', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          if (!isMemberConcession && !isWaiver) ...[
            const Text('Payment Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            if (isChequeOnly) const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.receipt_long), title: Text('Cheque'), subtitle: Text('Fixed for this transaction'))
            else Row(children: [Expanded(child: RadioListTile<String>(contentPadding: EdgeInsets.zero, title: const Text('Cash'), value: 'Cash', groupValue: _mode, onChanged: _saving ? null : (v) => setState(() => _mode = v!))), Expanded(child: RadioListTile<String>(contentPadding: EdgeInsets.zero, title: const Text('Bank Transfer'), value: 'Bank Transfer', groupValue: _mode, onChanged: _saving ? null : (v) => setState(() => _mode = v!)))]),
          ],
          if (isChequeOnly) TextField(controller: _cheque, enabled: !_saving, decoration: const InputDecoration(labelText: 'Cheque Number *', border: OutlineInputBorder(), helperText: 'Cheque is mandatory for this transaction.')),
          if (isWaiver || isMemberConcession || isFund || widget.source == LedgerSource.financial) TextField(controller: _remarks, enabled: !_saving, maxLines: 4, decoration: const InputDecoration(labelText: 'Remarks', border: OutlineInputBorder())),
          const SizedBox(height: 18),
          FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save), label: Text(_saving ? 'Saving...' : 'Save Changes')),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: _saving ? null : _delete, icon: const Icon(Icons.delete_outline, color: Colors.red), label: const Text('Delete Transaction', style: TextStyle(color: Colors.red))),
        ]),
      ),
    );
  }
}
