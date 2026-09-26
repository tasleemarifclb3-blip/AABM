import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;

import '../database/app_database.dart';
import '../database/accounting_service.dart';
import 'receipt_actions.dart';
import 'security.dart';

class HouseholdPaymentPage extends StatefulWidget {
  final AppDatabase database;
  final Household household;

  const HouseholdPaymentPage({
    super.key,
    required this.database,
    required this.household,
  });

  @override
  State<HouseholdPaymentPage> createState() =>
      _HouseholdPaymentPageState();
}

class _HouseholdPaymentPageState
    extends State<HouseholdPaymentPage> {
  final _paymentController = TextEditingController();
  final _concessionController = TextEditingController();
  final _remarksController = TextEditingController();

  String _paymentMode = 'Cash';
  DateTime _transactionDate = DateTime.now();

  // Receipt type controls the prefix used for new receipts.
  // The numeric sequence is six digits and is maintained separately
  // for each prefix, e.g. MD-000001, GD-000001, SF-000001.
  String _receiptType = 'MD';

  static const Map<String, String> _receiptTypes = {
    'MD': 'Monthly Donation',
  };

  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  double _outstanding = 0;
  double _advance = 0;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    _concessionController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _selectTransactionDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year, now.month, now.day),
      helpText: 'Select transaction date',
    );
    if (!mounted || picked == null) return;
    setState(() {
      _transactionDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
        now.hour,
        now.minute,
        now.second,
      );
    });
  }

  // ============================================================
  // LOAD CURRENT HOUSEHOLD BALANCE
  // ============================================================

  Future<void> _loadBalance() async {
    try {
      final balance = await AccountingService.householdBalance(
        widget.database,
        widget.household.id,
      );
      if (!mounted) return;
      setState(() {
        _outstanding = balance.outstanding;
        _advance = balance.advance;
        _loading = false;
        _loadError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'Could not load this household payment form: $e';
      });
    }
  }

  // ============================================================
  // PARSE MONEY
  // ============================================================

  double _parseAmount(String text) {
    final cleaned =
        text.replaceAll(',', '').trim();

    if (cleaned.isEmpty) {
      return 0;
    }

    return double.tryParse(cleaned) ?? 0;
  }

  // ============================================================
  // RECEIPT NUMBER
  // ============================================================

  Future<String> _nextReceiptNumber(String prefix) async {
    final payments = await widget.database
        .select(widget.database.householdPayments)
        .get();
    final concessions = await widget.database
        .select(widget.database.householdConcessions)
        .get();

    int highest = 0;
    final prefixWithDash = '$prefix-';

    for (final value in <String?>[
      ...payments.map((p) => p.receiptNumber),
      ...concessions.map((c) => c.receiptNumber),
    ]) {
      if (value == null || !value.startsWith(prefixWithDash)) {
        continue;
      }

      final number = int.tryParse(value.substring(prefixWithDash.length));
      if (number != null && number > highest) {
        highest = number;
      }
    }

    return '$prefix-${(highest + 1).toString().padLeft(6, '0')}';
  }

  // ============================================================
  // SAVE TRANSACTION
  // ============================================================

  Future<void> _saveTransaction() async {
    if (_saving) return;

    final payment = _parseAmount(_paymentController.text);
    final concession = _parseAmount(_concessionController.text);
    final remarks = _remarksController.text.trim();

    if (payment < 0 || concession < 0) {
      _showMessage('Amounts cannot be negative.');
      return;
    }
    if (payment == 0 && concession == 0) {
      _showMessage('Enter a payment or a concession.');
      return;
    }
    if (concession > _outstanding + .005) {
      _showMessage('Concession cannot be greater than the outstanding amount.');
      return;
    }

    setState(() => _saving = true);

    try {
      final receiptNumber = await _nextReceiptNumber(_receiptType);
      final transactionDate = _transactionDate;
      final username = currentUsername ?? 'Legacy';

      await widget.database.transaction(() async {
        if (payment > 0) {
          await widget.database.into(widget.database.householdPayments).insert(
            HouseholdPaymentsCompanion.insert(
              householdId: widget.household.id,
              paymentDate: Value(transactionDate),
              amount: payment,
              paymentMode: _paymentMode,
              receiptNumber: Value(receiptNumber),
              username: Value(username),
            ),
          );
        }

        if (concession > 0) {
          await widget.database.into(widget.database.householdConcessions).insert(
            HouseholdConcessionsCompanion.insert(
              householdId: widget.household.id,
              concessionDate: Value(transactionDate),
              amount: concession,
              receiptNumber: Value(receiptNumber),
              remarks: Value(remarks.isEmpty ? null : remarks),
              username: Value(username),
            ),
          );
        }

        await AccountingService.rebuildHouseholdAllocations(
          widget.database,
          widget.household.id,
          transaction: false,
        );
      });

      await _loadBalance();
      if (!mounted) return;

      final settled = payment + concession;
      final balanceRemaining = _outstanding > .005
          ? 'Due: INR ${_outstanding.toStringAsFixed(2)}'
          : _advance > .005
              ? 'Advance: INR ${_advance.toStringAsFixed(2)}'
              : 'Nil';

      await ReceiptActions.showActionsDialog(
        context: context,
        documentNumber: receiptNumber,
        title: 'Monthly Donation Receipt',
        fileNamePrefix: 'MD-Receipt',
        shareMessage:
            'Al-Amin Baitul Maal Trust - Monthly Donation Receipt $receiptNumber\n'
            'Date: ${ReceiptActions.formatDate(transactionDate)}\n'
            'Member: ${widget.household.name}\n'
            'Amount Received: INR ${payment.toStringAsFixed(2)}\n'
            'Concession: INR ${concession.toStringAsFixed(2)}\n'
            'Total Settled: INR ${settled.toStringAsFixed(2)}\n'
            'Balance Remaining: $balanceRemaining',
        buildPdf: () async {
          final document = ReceiptActions.thermalReceiptDocument(
            title: 'MONTHLY DONATION RECEIPT',
            documentNumber: receiptNumber,
            date: transactionDate,
            rows: [
              ReceiptActions.thermalRow('Received from', widget.household.name),
              ReceiptActions.thermalRow(
                'Member ID',
                'HH-${widget.household.id.toString().padLeft(4, '0')}',
              ),
              ReceiptActions.thermalRow('On account of', 'Monthly Donation'),
              ReceiptActions.thermalRow('Payment Mode', _paymentMode),
              ReceiptActions.thermalRow('Amount Received', 'INR ${payment.toStringAsFixed(2)}'),
              if (concession > .005)
                ReceiptActions.thermalRow('Concession', 'INR ${concession.toStringAsFixed(2)}'),
            ],
            amountWords: payment > .005 ? ReceiptActions.amountInWords(payment) : null,
            totalSettled: 'INR ${settled.toStringAsFixed(2)}',
            balanceRemaining: balanceRemaining,
            remarks: remarks,
          );
          return document.save();
        },
      );

      _paymentController.clear();
      _concessionController.clear();
      _remarksController.clear();

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) _showMessage('Could not save transaction:\n$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title: const Text(
            'Monthly Contribution',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Monthly Contribution')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.error_outline, size: 42, color: Colors.red),
              const SizedBox(height: 12),
              Text(_loadError!, textAlign: TextAlign.center),
              const SizedBox(height: 14),
              FilledButton.icon(onPressed: () { setState(() { _loading = true; _loadError = null; }); _loadBalance(); }, icon: const Icon(Icons.refresh), label: const Text('Retry')),
            ]),
          ),
        ),
      );
    }

    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.deepPurple.shade200),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text(
          'Monthly Contribution',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                widget.household.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Member ID: HH-${widget.household.id.toString().padLeft(4, '0')}',
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 14),

            // Balance box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  _balanceRow('Outstanding', _outstanding),
                  const Divider(height: 16),
                  _balanceRow('Advance', _advance),
                ],
              ),
            ),
            const SizedBox(height: 14),

            InkWell(
              onTap: _saving ? null : _selectTransactionDate,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Transaction Date',
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: fieldBorder,
                  enabledBorder: fieldBorder,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ReceiptActions.formatDate(_transactionDate)),
                    const Icon(Icons.calendar_today_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _receiptType,
              decoration: InputDecoration(
                labelText: 'Receipt Type',
                filled: true,
                fillColor: Colors.deepPurple.shade50,
                border: fieldBorder,
                enabledBorder: fieldBorder,
                focusedBorder: fieldBorder.copyWith(
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              ),
              items: _receiptTypes.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    '${entry.key} — ${entry.value}',
                    style: const TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: _saving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _receiptType = value);
                      }
                    },
            ),
            const SizedBox(height: 12),

            // Amount received: green
            TextField(
              controller: _paymentController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.green, fontSize: 17, fontWeight: FontWeight.w600),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Amount Received',
                labelStyle: TextStyle(color: Colors.green.shade700),
                prefixText: '₹ ',
                prefixStyle: TextStyle(color: Colors.green.shade700),
                filled: true,
                fillColor: Colors.green.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.green.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.green.shade700, width: 2),
                ),
              ),
            ),
            if (_parseAmount(_paymentController.text) > 0) ...[
              const SizedBox(height: 6),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Amount in Words: ${ReceiptActions.amountInWords(_parseAmount(_paymentController.text))}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),

            // Concession: red
            TextField(
              controller: _concessionController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: 'Concession / Waiver',
                labelStyle: TextStyle(color: Colors.red.shade700),
                prefixText: '₹ ',
                prefixStyle: TextStyle(color: Colors.red.shade700),
                helperText: 'Amount of existing dues being waived',
                filled: true,
                fillColor: Colors.red.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.red.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.red.shade700, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Payment Mode',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),

            // Cash and Bank Transfer on the same line.
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _paymentMode == 'Cash'
                            ? Colors.deepPurple
                            : Colors.deepPurple.shade100,
                      ),
                    ),
                    child: RadioListTile<String>(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                      title: const Text('Cash', style: TextStyle(fontSize: 14)),
                      value: 'Cash',
                      groupValue: _paymentMode,
                      onChanged: (value) {
                        if (value != null) setState(() => _paymentMode = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _paymentMode == 'Bank Transfer'
                            ? Colors.amber.shade700
                            : Colors.amber.shade200,
                      ),
                    ),
                    child: RadioListTile<String>(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                      title: const Text('Bank Transfer', style: TextStyle(fontSize: 14)),
                      value: 'Bank Transfer',
                      groupValue: _paymentMode,
                      onChanged: (value) {
                        if (value != null) setState(() => _paymentMode = value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _remarksController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Remarks (optional)',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveTransaction,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_saving ? 'Saving...' : 'Save Transaction'),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceRow(
    String label,
    double amount,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}