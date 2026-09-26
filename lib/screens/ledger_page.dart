import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../database/app_database.dart';
import 'brand.dart';
import 'edit_transaction_page.dart';
import 'receipt_actions.dart';
import 'security.dart';
import '../database/workflow_service.dart';

class LedgerPage extends StatefulWidget {
  final AppDatabase database;
  final String title;
  final String account;

  const LedgerPage({super.key, required this.database, required this.title, required this.account});

  @override
  State<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  late Future<_LedgerData> _future;
  DateTime? _filterFrom;
  DateTime? _filterTo;
  String _typeFilter = 'ALL';
  String _directionFilter = 'ALL';
  String _textFilter = '';
  String _userFilter = 'ALL';
  String _statusFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  String _typeForIncome(String c) {
    switch (c) {
      case 'GD':
      case 'GENERAL_DONATION':
        return 'General Donation';
      case 'BD':
      case 'BOX_DONATION':
        return 'Box Collection';
      case 'OI':
      case 'OTHER_INCOME':
        return 'Other Income';
      case 'ZK':
      case 'ZAKAAT':
        return 'Zakaat';
      case 'SF':
      case 'SADQA_FITR':
        return 'Sadqa-e-Fitr';
      default:
        return c;
    }
  }

  bool _passesFilters(_LedgerEntry entry) {
    if (widget.account != 'TOTAL') return true;
    final dateOnly = DateTime(entry.date.year, entry.date.month, entry.date.day);
    if (_filterFrom != null && dateOnly.isBefore(DateTime(_filterFrom!.year, _filterFrom!.month, _filterFrom!.day))) {
      return false;
    }
    if (_filterTo != null && dateOnly.isAfter(DateTime(_filterTo!.year, _filterTo!.month, _filterTo!.day))) {
      return false;
    }
    if (_directionFilter == 'CREDIT' && entry.credit <= 0) return false;
    if (_directionFilter == 'DEBIT' && entry.debit <= 0) return false;
    if (_typeFilter != 'ALL' && entry.type != _typeFilter) return false;
    if (_userFilter != 'ALL' && entry.username != _userFilter) return false;
    if (_statusFilter != 'ALL' && entry.approvalStatus != _statusFilter) return false;
    final q = _textFilter.trim().toLowerCase();
    if (q.isNotEmpty) {
      final haystack = '${entry.reference} ${entry.remarks} ${entry.type} ${entry.username}'.toLowerCase();
      if (!haystack.contains(q)) return false;
    }
    return true;
  }

  Future<void> _showFilters(_LedgerData allData) async {
    DateTime? from = _filterFrom;
    DateTime? to = _filterTo;
    String type = _typeFilter;
    String direction = _directionFilter;
    String user = _userFilter;
    String status = _statusFilter;
    final textController = TextEditingController(text: _textFilter);
    final users = <String>{
      'ALL',
      ...allData.entries.map((e) => e.username).where((e) => e.trim().isNotEmpty),
    }.toList()..sort();
    final types = <String>{
      'ALL',
      ...allData.entries.map((e) => e.type),
    }.toList()..sort();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Filter Transactions'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final p = await showDatePicker(
                            context: dialogContext,
                            initialDate: from ?? DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: to ?? DateTime.now(),
                          );
                          if (p != null) setDialogState(() => from = p);
                        },
                        child: Text(from == null ? 'From date' : ReceiptActions.formatDate(from!)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final p = await showDatePicker(
                            context: dialogContext,
                            initialDate: to ?? DateTime.now(),
                            firstDate: from ?? DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (p != null) setDialogState(() => to = p);
                        },
                        child: Text(to == null ? 'To date' : ReceiptActions.formatDate(to!)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Transaction Type', border: OutlineInputBorder()),
                  items: types.map((v) => DropdownMenuItem(value: v, child: Text(v == 'ALL' ? 'All Types' : v))).toList(),
                  onChanged: (v) => setDialogState(() => type = v ?? 'ALL'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: direction,
                  decoration: const InputDecoration(labelText: 'Debit / Credit', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'ALL', child: Text('Both')),
                    DropdownMenuItem(value: 'CREDIT', child: Text('Credit / Received')),
                    DropdownMenuItem(value: 'DEBIT', child: Text('Debit / Spent')),
                  ],
                  onChanged: (v) => setDialogState(() => direction = v ?? 'ALL'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: users.contains(user) ? user : 'ALL',
                  decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                  items: users.map((v) => DropdownMenuItem(value: v, child: Text(v == 'ALL' ? 'All Users' : v))).toList(),
                  onChanged: (v) => setDialogState(() => user = v ?? 'ALL'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  decoration: const InputDecoration(labelText: 'Approval Status', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'ALL', child: Text('All Statuses')),
                    DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                    DropdownMenuItem(value: 'APPROVED', child: Text('Approved')),
                    DropdownMenuItem(value: 'REJECTED', child: Text('Disproved')),
                  ],
                  onChanged: (v) => setDialogState(() => status = v ?? 'ALL'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'Search receipt / remarks / type',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _filterFrom = null;
                  _filterTo = null;
                  _typeFilter = 'ALL';
                  _directionFilter = 'ALL';
                  _userFilter = 'ALL';
                  _statusFilter = 'ALL';
                  _textFilter = '';
                  _future = _load();
                });
              },
              child: const Text('Clear'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _filterFrom = from;
                  _filterTo = to;
                  _typeFilter = type;
                  _directionFilter = direction;
                  _userFilter = user;
                  _statusFilter = status;
                  _textFilter = textController.text;
                  _future = _load();
                });
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
    textController.dispose();
  }

  Future<_LedgerData> _load() async {
    final entries = <_LedgerEntry>[];
    final openingBalance = switch (widget.account) {
      'SADQA_FITR' || 'QARZA' => 0.0,
      'TOTAL' => await WorkflowService.totalOpeningBalance(
          widget.database,
          const ['MONTHLY_DONATION', 'GENERAL_DONATION', 'BOX_COLLECTION', 'OTHER_INCOME', 'ZAKAAT', 'OTHER_EXPENSE'],
        ),
      _ => await WorkflowService.openingBalance(widget.database, widget.account),
    };
    final households = await widget.database.select(widget.database.households).get();
    final names = {for (final h in households) h.id: h.name};

    final isTotal = widget.account == 'TOTAL';
    final isDonations = widget.account == 'DONATIONS';

    final payments = await widget.database.select(widget.database.householdPayments).get();
    if (isTotal || isDonations || widget.account == 'MONTHLY_DONATION') {
      for (final p in payments) {
        entries.add(_LedgerEntry(
          date: p.paymentDate,
          credit: p.amount,
          debit: 0,
          reference: p.receiptNumber ?? '—',
          remarks: 'Member: ${names[p.householdId] ?? 'Member'}; Mode: ${p.paymentMode}',
          type: 'Monthly Donation',
          source: LedgerSource.memberPayment,
          id: p.id,
          username: p.username,
        ));
      }
    }

    final tx = await widget.database.select(widget.database.financialTransactions).get();
    for (final t in tx) {
      final c = t.category.toUpperCase();
      final match = switch (widget.account) {
        'GENERAL_DONATION' => c == 'GD' || c == 'GENERAL_DONATION',
        'BOX_COLLECTION' => c == 'BD' || c == 'BOX_DONATION',
        'OTHER_INCOME' => c == 'OI' || c == 'OTHER_INCOME',
        'ZAKAAT' => c == 'ZK' || c == 'ZAKAAT',
        'SADQA_FITR' => c == 'SF' || c == 'SADQA_FITR',
        'DONATIONS' => c == 'GD' || c == 'GENERAL_DONATION' || c == 'BD' || c == 'BOX_DONATION' || c == 'OI' || c == 'OTHER_INCOME',
        'TOTAL' => true,
        _ => false,
      };
      if (!match) continue;
      final party = (t.donorName ?? '').trim();
      final remarks = party.isEmpty ? (t.remarks ?? '—') : 'Donor: $party${(t.remarks ?? '').trim().isEmpty ? '' : '; ${t.remarks}'}';
      entries.add(_LedgerEntry(
        date: t.transactionDate,
        credit: t.amount,
        debit: 0,
        reference: t.receiptNumber ?? '—',
        remarks: remarks,
        type: _typeForIncome(c),
        source: LedgerSource.financial,
        id: t.id,
        username: t.username,
      ));
    }

    final zakaat = await widget.database.select(widget.database.zakaatDisbursements).get();
    for (final d in zakaat) {
      final match = widget.account == 'ZAKAAT' || isTotal;
      if (!match) continue;
      entries.add(_LedgerEntry(
        date: d.disbursementDate,
        credit: 0,
        debit: d.amount,
        reference: d.voucherNumber ?? '—',
        remarks: 'Recipient: ${d.recipientName}; Cheque: ${d.chequeNumber ?? '—'}${(d.remarks ?? '').trim().isEmpty ? '' : '; ${d.remarks}'}',
        type: 'Zakaat Expenditure',
        source: LedgerSource.zakaat,
        id: d.id,
        username: d.username,
      ));
    }

    final adjustments = await widget.database.select(widget.database.fundAdjustments).get();
    for (final a in adjustments) {
      if (a.adjustmentType == 'OTHER_EXPENSE') {
        if (isDonations || isTotal || widget.account == 'OTHER_EXPENSE') {
          entries.add(_LedgerEntry(date: a.transactionDate, credit: 0, debit: a.amount, reference: a.documentNumber ?? '—', remarks: '${a.partyName ?? 'Expense'}${(a.remarks ?? '').trim().isEmpty ? '' : '; ${a.remarks}'}', type: 'Other Expense', source: LedgerSource.fundAdjustment, id: a.id, username: a.username));
        }
      } else if (a.adjustmentType == 'QARZA_DISBURSEMENT') {
        if (isDonations || isTotal || widget.account == 'QARZA') {
          entries.add(_LedgerEntry(date: a.transactionDate, credit: 0, debit: a.amount, reference: a.documentNumber ?? '—', remarks: 'Qarz issued to ${a.partyName ?? '—'}; Cheque: ${a.chequeNumber ?? '—'}${(a.remarks ?? '').trim().isEmpty ? '' : '; ${a.remarks}'}', type: 'Qarz-e-Hassanah', source: LedgerSource.fundAdjustment, id: a.id, username: a.username));
        }
      } else if (a.adjustmentType == 'QARZA_RECOVERY') {
        if (isDonations || isTotal || widget.account == 'QARZA') {
          entries.add(_LedgerEntry(date: a.transactionDate, credit: a.amount, debit: 0, reference: a.documentNumber ?? '—', remarks: 'Qarz recovered from ${a.partyName ?? '—'}${(a.remarks ?? '').trim().isEmpty ? '' : '; ${a.remarks}'}', type: 'Qarz Recovery', source: LedgerSource.fundAdjustment, id: a.id, username: a.username));
        }
      } else if (a.adjustmentType == 'SADQA_EXPENSE') {
        if (widget.account == 'SADQA_FITR' || isTotal) {
          entries.add(_LedgerEntry(date: a.transactionDate, credit: 0, debit: a.amount, reference: a.documentNumber ?? '—', remarks: '${a.partyName ?? 'Recipient'}${(a.remarks ?? '').trim().isEmpty ? '' : '; ${a.remarks}'}', type: 'Sadqa-e-Fitr Expenditure', source: LedgerSource.fundAdjustment, id: a.id, username: a.username));
        }
      }
    }

    // Qarza waiver journal: Debit Zakaat expense and Credit Qarza receivable.
    // Only the Zakaat debit affects cash/fund availability.
    final waivers = await WorkflowService.qarzaWaivers(widget.database);
    for (final w in waivers) {
      if (widget.account == 'DONATIONS') {
        entries.add(_LedgerEntry(
          date: w.date,
          credit: w.amount,
          debit: 0,
          reference: w.waiverNumber,
          remarks: 'Memorandum credit: Qarza waiver funded originally from Donations; Original Qarz: ${w.originalQarzaNumber}',
          type: 'Qarz Waiver — Donation Link',
          source: LedgerSource.qarzaWaiver,
          id: w.id,
          username: w.username,
          affectsBalance: false,
        ));
      } else if (widget.account == 'ZAKAAT' || isTotal) {
        entries.add(_LedgerEntry(
          date: w.date,
          credit: 0,
          debit: w.amount,
          reference: w.waiverNumber,
          remarks: 'Borrower: ${w.borrowerName}; Original Qarz: ${w.originalQarzaNumber}; Donations funding reference retained',
          type: 'Qarz Waived to Zakaat',
          source: LedgerSource.qarzaWaiver,
          id: w.id,
          username: w.username,
        ));
      } else if (widget.account == 'QARZA') {
        entries.add(_LedgerEntry(
          date: w.date,
          credit: w.amount,
          debit: 0,
          reference: w.waiverNumber,
          remarks: 'Borrower: ${w.borrowerName}; Original Qarz: ${w.originalQarzaNumber}; Credited off as Zakaat waiver',
          type: 'Qarz Waiver / Written Off',
          source: LedgerSource.qarzaWaiver,
          id: w.id,
          username: w.username,
        ));
      }
    }

    // Approval status: pending transactions remain visible for audit, but
    // do NOT affect ledger balances until both approvers approve. Disproved
    // transactions are also visible but never affect the balance.
    for (final e in entries) {
      if (e.source == LedgerSource.fundAdjustment) {
        final info = await WorkflowService.approvalInfo(widget.database, sourceTable: 'fund_adjustments', transactionId: e.id);
        e.approvalStatus = info['status'] as String? ?? 'FINAL';
      } else if (e.source == LedgerSource.zakaat) {
        final info = await WorkflowService.approvalInfo(widget.database, sourceTable: 'zakaat_disbursements', transactionId: e.id);
        e.approvalStatus = info['status'] as String? ?? 'FINAL';
      }
    }

    final allChronological = [...entries]..sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      return byDate != 0 ? byDate : a.id.compareTo(b.id);
    });
    var current = openingBalance;
    for (final e in allChronological) {
      if (e.affectsBalance && (e.approvalStatus == 'FINAL' || e.approvalStatus == 'APPROVED')) {
        current += e.credit - e.debit;
      }
    }

    final filteredEntries = entries.where(_passesFilters).toList();
    filteredEntries.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : b.id.compareTo(a.id);
    });
    var running = current;
    for (final e in filteredEntries) {
      e.runningBalance = running;
      if (e.affectsBalance && (e.approvalStatus == 'FINAL' || e.approvalStatus == 'APPROVED')) {
        running -= e.credit - e.debit;
      }
    }
    return _LedgerData(filteredEntries, current, openingBalance);
  }

  Future<Uint8List> _pdf(_LedgerData data) async {
    final rows = data.entries.map((e) {
      if (widget.account == 'TOTAL') {
        return [
          ReceiptActions.formatDate(e.date),
          'INR ${(e.credit == 0 ? e.debit : e.credit).toStringAsFixed(2)}',
          e.credit == 0 ? 'DEBIT' : 'CREDIT',
          e.reference,
          e.type,
          'INR ${e.runningBalance.toStringAsFixed(2)}',
          e.username,
        ];
      }
      return [
        ReceiptActions.formatDate(e.date),
        'INR ${(e.credit == 0 ? e.debit : e.credit).toStringAsFixed(2)}',
        e.credit == 0 ? 'DEBIT' : 'CREDIT',
        e.reference,
        e.remarks,
        e.type,
        'INR ${e.runningBalance.toStringAsFixed(2)}',
        e.username,
      ];
    }).toList();
    return ReceiptActions.ledgerDocument(
      title: widget.title,
      rows: rows,
      includeRemarks: widget.account != 'TOTAL',
    ).save();
  }

  bool get _canEditOpeningBalance => widget.account != 'SADQA_FITR' && widget.account != 'QARZA' && widget.account != 'TOTAL';

  Future<void> _editOpeningBalance() async {
    if (!_canEditOpeningBalance) return;
    final authorized = await requireSuperuserPassword(
      context,
      title: 'Authorize Opening Balance',
      message: 'Enter the superuser password to change this account head opening balance.',
    );
    if (!authorized || !mounted) return;
    final current = await WorkflowService.openingBalance(widget.database, widget.account);
    if (!mounted) return;
    final controller = TextEditingController(text: current.abs().toStringAsFixed(2));
    var type = current < 0 ? 'DEBIT' : 'CREDIT';
    final result = await showDialog<(double, String)?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${widget.title} — Opening Balance'),
        content: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Opening Balance', prefixText: '₹ ', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Balance Type', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'CREDIT', child: Text('Credit / Available')),
                  DropdownMenuItem(value: 'DEBIT', child: Text('Debit / Outstanding')),
                ],
                onChanged: (v) => setState(() => type = v ?? 'CREDIT'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final parsed = double.tryParse(controller.text.replaceAll(',', '').replaceAll('₹', '').trim());
              if (parsed == null || parsed < 0) return;
              Navigator.pop(ctx, (parsed, type));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;
    await WorkflowService.setOpeningBalance(widget.database, widget.account, result.$1, balanceType: result.$2);
    if (mounted) {
      setState(() {
        _future = _load();
      });
    }
  }

  Future<void> _showEntry(_LedgerEntry entry) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(entry.reference),
        content: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Date: ${ReceiptActions.formatDate(entry.date)}'),
            Text('Amount: ₹${(entry.credit == 0 ? entry.debit : entry.credit).toStringAsFixed(2)}'),
            Text('Debit/Credit: ${entry.credit == 0 ? 'Debit' : 'Credit'}'),
            Text('Type: ${entry.type}'),
            const SizedBox(height: 6),
            Text(entry.remarks),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ReceiptActions.showActionsDialog(
                context: context,
                documentNumber: entry.reference,
                title: '${entry.type} Receipt',
                fileNamePrefix: entry.reference.split('-').first,
                shareMessage: 'Al-Amin Baitul Maal - ${entry.type} ${entry.reference}',
                buildPdf: () async {
                  if (entry.reference.startsWith('QW-') &&
                      (entry.type == 'Qarz Waived to Zakaat' || entry.type == 'Qarz Waiver / Written Off')) {
                    final waiverRows = await WorkflowService.qarzaWaivers(widget.database);
                    final w = waiverRows.firstWhere((x) => x.waiverNumber == entry.reference);
                    return (await ReceiptActions.qarzaWaiverVoucherDocument(
                      waiverNumber: w.waiverNumber,
                      date: w.date,
                      borrowerName: w.borrowerName,
                      originalQarzaNumber: w.originalQarzaNumber,
                      amount: w.amount,
                      username: w.username,
                      remarks: w.remarks,
                    )).save();
                  }
                  if (entry.source == LedgerSource.fundAdjustment &&
                      (entry.type == 'Qarz-e-Hassanah' || entry.type == 'Qarz Recovery')) {
                    final rows = await (widget.database.select(widget.database.fundAdjustments)
                          ..where((a) => a.id.equals(entry.id)))
                        .get();
                    if (rows.isNotEmpty) {
                      final a = rows.first;
                      final parentage = await WorkflowService.parentage(widget.database, a.documentNumber ?? entry.reference);
                      return ReceiptActions.qarzaVoucherDocument(
                        documentNumber: a.documentNumber ?? entry.reference,
                        date: a.transactionDate,
                        party: a.partyName ?? '',
                        parentage: parentage,
                        address: a.address ?? '',
                        aadhaar: a.aadhaarNumber ?? '',
                        phone: a.phoneNumber ?? '',
                        amount: a.amount,
                        chequeNumber: a.chequeNumber ?? '',
                        paymentMode: a.paymentMode,
                        operation: a.adjustmentType == 'QARZA_DISBURSEMENT' ? 'ISSUE' : 'RECOVERY',
                        verification: a.verification ?? '',
                        verifiedBy1: a.verifiedBy1 ?? '',
                        verifiedBy2: a.verifiedBy2 ?? '',
                        verifiedBy3: a.verifiedBy3 ?? '',
                        remarks: a.remarks ?? '',
                        recipientSignature: a.recipientSignature,
                        accountantSignature: a.accountantSignature,
                        preparedBy: a.username,
                      ).save();
                    }
                  }
                  if (entry.source == LedgerSource.zakaat &&
                      entry.type == 'Zakaat Expenditure') {
                    final rows = await (widget.database.select(widget.database.zakaatDisbursements)
                          ..where((d) => d.id.equals(entry.id)))
                        .get();
                    if (rows.isNotEmpty) {
                      final d = rows.first;
                      return ReceiptActions.zakaatVoucherDocument(
                        voucherNumber: d.voucherNumber ?? entry.reference,
                        date: d.disbursementDate,
                        recipientName: d.recipientName,
                        address: d.recipientAddress ?? '',
                        aadhaar: d.aadhaarNumber ?? '',
                        phone: d.phoneNumber ?? '',
                        amount: d.amount,
                        reason: d.reason ?? '',
                        authority: d.issuingAuthorityReport ?? '',
                        cheque: d.chequeNumber ?? '',
                        paymentMode: d.paymentMode,
                        verification: d.verification ?? '',
                        verifiedBy1: d.verifiedBy1 ?? '',
                        verifiedBy2: d.verifiedBy2 ?? '',
                        verifiedBy3: d.verifiedBy3 ?? '',
                        remarks: d.remarks ?? '',
                        recipientSignature: d.recipientSignature,
                        accountantSignature: d.accountantSignature,
                        preparedBy: d.username,
                      ).save();
                    }
                  }

                  if (entry.credit > 0) {
                    return ReceiptActions.thermalReceiptDocument(
                      title: '${entry.type.toUpperCase()} RECEIPT',
                      documentNumber: entry.reference,
                      date: entry.date,
                      rows: [
                        ReceiptActions.pdfRow('Type', entry.type),
                        ReceiptActions.pdfRow('Amount', 'INR ${entry.credit.toStringAsFixed(2)}'),
                        ReceiptActions.pdfRow('Party / Source', entry.remarks.isEmpty ? '—' : entry.remarks),
                      ],
                      amountWords: ReceiptActions.amountInWords(entry.credit),
                    ).save();
                  }
                  return ReceiptActions.baseDocument(
                    title: entry.type.toUpperCase(),
                    documentNumber: entry.reference,
                    date: ReceiptActions.formatDate(entry.date),
                    rows: [
                      ReceiptActions.pdfRow('Amount', 'INR ${entry.debit.toStringAsFixed(2)}'),
                      ReceiptActions.pdfRow('Debit / Credit', 'Debit'),
                      ReceiptActions.pdfRow('Type', entry.type),
                      ReceiptActions.pdfRow('Remarks', entry.remarks),
                    ],
                    largeHeader: false,
                  ).save();
                },
              );
            },
            child: const Text('Print / Share'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final changed = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => EditTransactionPage(database: widget.database, source: entry.source, id: entry.id, title: entry.type)));
              if (changed == true && mounted) {
                setState(() {
                  _future = _load();
                });
              }
            },
            child: const Text('Edit'),
          ),
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} Ledger'),
        actions: [
          FutureBuilder<_LedgerData>(future: _future, builder: (context, snap) => snap.hasData ? Row(children: [if (_canEditOpeningBalance) IconButton(tooltip: 'Opening Balance', onPressed: _editOpeningBalance, icon: const Icon(Icons.account_balance_wallet_outlined)), IconButton(tooltip: 'Print / Save PDF', onPressed: () async { final b = await _pdf(snap.data!); await ReceiptActions.printPdf(bytes: b, fileName: 'Ledger-${widget.title}.pdf'); }, icon: const Icon(Icons.print)), IconButton(tooltip: 'Send via WhatsApp', onPressed: () async { final b = await _pdf(snap.data!); await ReceiptActions.sharePdf(bytes: b, fileName: 'Ledger-${widget.title}.pdf', message: 'Al-Amin Baitul Maal - ${widget.title} Ledger'); }, icon: const Icon(Icons.share))]) : const SizedBox.shrink()),
        ],
      ),
      body: FutureBuilder<_LedgerData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(16), child: Text('Could not load ledger:\n${snapshot.error}', textAlign: TextAlign.center)));
          final data = snapshot.data!;
          return Column(children: [
            if (widget.account == 'TOTAL')
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final p = await showDatePicker(
                            context: context,
                            initialDate: _filterFrom ?? DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: _filterTo ?? DateTime.now(),
                          );
                          if (p == null || !mounted) return;
                          setState(() {
                            _filterFrom = p;
                            _future = _load();
                          });
                        },
                        icon: const Icon(Icons.date_range),
                        label: Text(_filterFrom == null ? 'From date' : ReceiptActions.formatDate(_filterFrom!)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final p = await showDatePicker(
                            context: context,
                            initialDate: _filterTo ?? DateTime.now(),
                            firstDate: _filterFrom ?? DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (p == null || !mounted) return;
                          setState(() {
                            _filterTo = p;
                            _future = _load();
                          });
                        },
                        icon: const Icon(Icons.event),
                        label: Text(_filterTo == null ? 'To date' : ReceiptActions.formatDate(_filterTo!)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      tooltip: 'Filter transactions',
                      onPressed: () {
                        _showFilters(snapshot.data!);
                      },
                      icon: const Icon(Icons.filter_alt_outlined),
                    ),
                  ],
                ),
              ),
            if (widget.account == 'TOTAL')
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                child: DropdownButtonFormField<String>(
                  initialValue: _typeFilter,
                  decoration: const InputDecoration(
                    labelText: 'Transaction Type',
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem(value: 'ALL', child: Text('All Transaction Types')),
                    ...<String>{...data.entries.map((e) => e.type)}
                        .where((v) => v.trim().isNotEmpty)
                        .map((v) => DropdownMenuItem(value: v, child: Text(v))),
                  ],
                  onChanged: (v) {
                    setState(() {
                      _typeFilter = v ?? 'ALL';
                      _future = _load();
                    });
                  },
                ),
              ),
            Container(width: double.infinity, padding: const EdgeInsets.all(12), color: kBrandCream, child: Row(
              children: [
                Expanded(child: Text('Opening: ₹${data.openingBalance.toStringAsFixed(2)}   •   Current Balance: ₹${data.currentBalance.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kBrandGreen))),
                if (_canEditOpeningBalance) IconButton(tooltip: 'Edit opening balance', onPressed: _editOpeningBalance, icon: const Icon(Icons.edit_outlined)),
              ],
            )),
            Expanded(
              child: data.entries.isEmpty
                  ? const Center(child: Text('No transactions recorded.'))
                  : SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStatePropertyAll(kBrandGreen.withAlpha(30)),
                          columns: [
                            DataColumn(label: Text('Approval')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Debit/Credit')),
                            DataColumn(label: Text('Receipt No.')),
                            if (widget.account != 'TOTAL') DataColumn(label: Text('Remarks')),
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('Running Balance')),
                            DataColumn(label: Text('Username')),
                          ],
                          rows: data.entries.map((e) => DataRow(
                            color: WidgetStatePropertyAll(
                              e.approvalStatus == 'PENDING'
                                  ? const Color(0xFFFFF3B0)
                                  : e.approvalStatus == 'REJECTED'
                                      ? const Color(0xFFFFCDD2)
                                      : null,
                            ),
                            onLongPress: () => _showEntry(e),
                            cells: [
                              DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                                Checkbox(value: e.approvalStatus == 'APPROVED', onChanged: null, visualDensity: VisualDensity.compact),
                                Text(e.approvalStatus == 'REJECTED' ? 'DISPROVED' : e.approvalStatus == 'PENDING' ? 'Pending' : 'Approved'),
                              ]), onTap: () => _showEntry(e)),
                              DataCell(Text(ReceiptActions.formatDate(e.date)), onTap: () => _showEntry(e)),
                              DataCell(Text('₹${(e.credit == 0 ? e.debit : e.credit).toStringAsFixed(2)}'), onTap: () => _showEntry(e)),
                              DataCell(Text(e.credit == 0 ? 'Debit' : 'Credit', style: TextStyle(color: e.credit == 0 ? Colors.red.shade700 : Colors.green.shade700, fontWeight: FontWeight.bold)), onTap: () => _showEntry(e)),
                              DataCell(Text(e.reference, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)), onTap: () => _showEntry(e)),
                              if (widget.account != 'TOTAL') DataCell(Text(e.remarks), onTap: () => _showEntry(e)),
                              DataCell(Text(e.type), onTap: () => _showEntry(e)),
                              DataCell(Text('₹${e.runningBalance.toStringAsFixed(2)}'), onTap: () => _showEntry(e)),
                              DataCell(Text(e.username), onTap: () => _showEntry(e)),
                            ],
                          )).toList(),
                        ),
                      ),
                    ),
            ),
          ]);
        },
      ),
    );
  }
}

class _LedgerEntry {
  final DateTime date;
  final double credit;
  final double debit;
  final String reference;
  final String remarks;
  final String type;
  final String source;
  final int id;
  final String username;
  final bool affectsBalance;
  String approvalStatus = 'FINAL';
  double runningBalance = 0;

  _LedgerEntry({required this.date, required this.credit, required this.debit, required this.reference, required this.remarks, required this.type, required this.source, required this.id, required this.username, this.affectsBalance = true});
}

class _LedgerData {
  final List<_LedgerEntry> entries;
  final double currentBalance;
  final double openingBalance;
  const _LedgerData(this.entries, this.currentBalance, this.openingBalance);
}
