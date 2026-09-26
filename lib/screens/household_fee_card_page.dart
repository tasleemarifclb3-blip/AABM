import 'package:flutter/material.dart';

import 'package:drift/drift.dart' hide Column;

import '../database/app_database.dart';
import '../database/accounting_service.dart';

import 'household_payment_page.dart';
import 'receipt_actions.dart';
import 'edit_transaction_page.dart';

class HouseholdFeeCardPage extends StatefulWidget {

  final AppDatabase database;

  final Household household;

  const HouseholdFeeCardPage({

    super.key,

    required this.database,

    required this.household,

  });

  @override

  State<HouseholdFeeCardPage> createState() =>

      _HouseholdFeeCardPageState();

}

class _HouseholdFeeCardPageState

    extends State<HouseholdFeeCardPage> {

  bool _loading = true;

  List<HouseholdMonth> _months = [];

List<HouseholdStatusHistory> _statusHistory = [];

List<HouseholdPayment> _payments = [];

List<HouseholdConcession> _concessions = [];

  final Map<int, double> _paidByMonth = {};

  // Actual money received in each calendar month. This is separate from
  // allocation data, which tells us which older dues the payment settled.
  final Map<String, double> _transactionPaidByMonth = {};

  // Actual concessions recorded in each calendar month. This is separate
  // from allocation data, which tells us which older dues the concession cleared.
  final Map<String, double> _transactionConcessionByMonth = {};

  final Map<int, double> _concessionByMonth = {};

  double _totalPaid = 0;

  double _totalConcession = 0;

  double _totalPayable = 0;

  double _outstanding = 0;
  double _advance = 0;

  // Opening balance accounting. The original opening amount is kept
  // unchanged; allocations reduce only the remaining opening balance.
  double _openingOriginalSignedBalance = 0;
  double _openingSignedBalance = 0;
  double _openingPaid = 0;
  double _openingConcession = 0;

  // Payment allocated to monthly records only.
  double _monthlyPaid = 0;
  bool _isActive = true;

  HouseholdStatusHistory? _latestStatus;

  @override

  void initState() {

    super.initState();

    _loadFeeCard();

  }

  // ============================================================

  // LOAD FEE CARD

  // ============================================================

  Future<void> _rebuildPaymentAllocations(Household household) async {
    final payments = await (widget.database
          .select(widget.database.householdPayments)
        ..where((p) => p.householdId.equals(household.id))
        ..orderBy([
          (p) => OrderingTerm(
                expression: p.paymentDate,
                mode: OrderingMode.asc,
              ),
          (p) => OrderingTerm(
                expression: p.id,
                mode: OrderingMode.asc,
              ),
        ]))
        .get();

    if (payments.isEmpty) return;

    // Rebuild only allocation records. Actual transaction records are kept
    // untouched. This also fixes records created by the earlier payment flow.
    for (final payment in payments) {
      await (widget.database.delete(widget.database.paymentAllocations)
            ..where((a) => a.paymentId.equals(payment.id)))
          .go();
      await (widget.database
            .delete(widget.database.openingBalancePaymentAllocations)
            ..where((a) => a.paymentId.equals(payment.id)))
          .go();
    }

    double openingConcession = 0;
    final openingConcessions = await (widget.database
          .select(widget.database.openingBalanceConcessionAllocations)
        ..where((a) => a.householdId.equals(household.id)))
        .get();
    for (final allocation in openingConcessions) {
      openingConcession += allocation.amount;
    }

    double openingRemaining = household.openingBalanceType == 'DUE'
        ? household.openingBalance - openingConcession
        : 0;

    final months = await (widget.database
          .select(widget.database.householdMonths)
        ..where((m) => m.householdId.equals(household.id))
        ..orderBy([
          (m) => OrderingTerm(
                expression: m.year,
                mode: OrderingMode.asc,
              ),
          (m) => OrderingTerm(
                expression: m.month,
                mode: OrderingMode.asc,
              ),
        ]))
        .get();

    final monthlyConcession = <int, double>{};
    for (final month in months) {
      final allocations = await (widget.database
            .select(widget.database.householdConcessionAllocations)
          ..where((a) => a.householdMonthId.equals(month.id)))
          .get();
      final allocated = allocations.fold<double>(
        0,
        (sum, item) => sum + item.amount,
      );
      monthlyConcession[month.id] = allocated > 0
          ? allocated
          : month.concession;
    }

    final monthlyPaid = <int, double>{};

    for (final payment in payments) {
      double remaining = payment.amount;

      // Opening balance is always the oldest due.
      if (remaining > 0 && openingRemaining > 0) {
        final amount = remaining < openingRemaining
            ? remaining
            : openingRemaining;
        await widget.database
            .into(widget.database.openingBalancePaymentAllocations)
            .insert(
          OpeningBalancePaymentAllocationsCompanion.insert(
            paymentId: payment.id,
            householdId: household.id,
            amount: amount,
          ),
        );
        openingRemaining -= amount;
        remaining -= amount;
      }

      // Then settle monthly dues oldest-first. A payment can never settle a
      // month later than the month in which it was actually received.
      for (final month in months) {
        if (remaining <= 0) break;

        final isFuture = month.year > payment.paymentDate.year ||
            (month.year == payment.paymentDate.year &&
                month.month > payment.paymentDate.month);
        if (isFuture) break;

        final alreadyPaid = monthlyPaid[month.id] ?? 0;
        final due = month.charge -
            (monthlyConcession[month.id] ?? 0) -
            alreadyPaid;
        if (due <= 0) continue;

        final amount = remaining < due ? remaining : due;
        await widget.database
            .into(widget.database.paymentAllocations)
            .insert(
          PaymentAllocationsCompanion.insert(
            paymentId: payment.id,
            householdMonthId: month.id,
            amount: amount,
          ),
        );
        monthlyPaid[month.id] = alreadyPaid + amount;
        remaining -= amount;
      }
    }
  }

  Future<void> _loadFeeCard() async {

    if (!mounted) return;

    setState(() {

      _loading = true;

    });

    final household = widget.household;

    // Repair legacy records created by the old "Opening first" payment flow.
    // A monthly transaction belongs only to its transaction month.

    // ----------------------------------------------------------

    // Opening balance
    // ----------------------------------------------------------

    _openingOriginalSignedBalance =
        household.openingBalanceType == 'ADVANCE'
            ? -household.openingBalance
            : household.openingBalance;

    _openingPaid = 0;
    _openingConcession = 0;

    // Opening DUE is a real outstanding item. Payments and concessions
    // allocated to it reduce only the remaining opening balance.
    if (household.openingBalanceType == 'DUE' &&
        household.openingBalance > 0) {
      final openingPayments = await (widget.database
            .select(widget.database.openingBalancePaymentAllocations)
          ..where(
            (a) => a.householdId.equals(household.id),
          ))
          .get();

      for (final allocation in openingPayments) {
        _openingPaid += allocation.amount;
      }

      final openingConcessions = await (widget.database
            .select(
              widget.database.openingBalanceConcessionAllocations,
            )
          ..where(
            (a) => a.householdId.equals(household.id),
          ))
          .get();

      for (final allocation in openingConcessions) {
        _openingConcession += allocation.amount;
      }

      _openingSignedBalance =
          household.openingBalance -
          _openingPaid -
          _openingConcession;

      if (_openingSignedBalance < 0) {
        _openingSignedBalance = 0;
      }
    } else {
      _openingSignedBalance = _openingOriginalSignedBalance;
    }

    // Load status history

    // ----------------------------------------------------------

    _statusHistory = await (widget.database

          .select(widget.database.householdStatusHistories)

        ..where(

          (s) => s.householdId.equals(household.id),

        )

        ..orderBy([

          (s) => OrderingTerm(

                expression: s.eventDate,

                mode: OrderingMode.asc,

              ),

        ]))

        .get();

    if (_statusHistory.isNotEmpty) {

      _latestStatus = _statusHistory.last;

      _isActive = _latestStatus!.status != 'CLOSED';

    } else {

      // Older records may not have status history.

      _isActive = household.isActive;

      _latestStatus = null;

    }

    // ----------------------------------------------------------

    // Decide whether a month should carry a charge

    // ----------------------------------------------------------

    bool shouldChargeMonth(DateTime month) {

      final monthStart = DateTime(

        month.year,

        month.month,

        1,

      );

      final monthEnd = DateTime(

        month.year,

        month.month + 1,

        0,

      );

      final joinedMonth = DateTime(

        household.joinedDate.year,

        household.joinedDate.month,

        1,

      );

      // Never create charges before the joining month.

      if (monthStart.isBefore(joinedMonth)) {

        return false;

      }

      bool active = true;

      for (final event in _statusHistory) {

        final eventDate = DateTime(

          event.eventDate.year,

          event.eventDate.month,

          event.eventDate.day,

        );

        // Events after this month's end do not affect this month.

        if (eventDate.isAfter(monthEnd)) {

          break;

        }

        if (event.status == 'CLOSED') {

          active = false;

          // Closing during this month means no charge

          // for the closing month.

          if (!eventDate.isBefore(monthStart) &&

              !eventDate.isAfter(monthEnd)) {

            return false;

          }

        }

        if (event.status == 'REOPENED') {

          // Reopening during this month means no charge

          // for the reopening month.

          if (!eventDate.isBefore(monthStart) &&

              !eventDate.isAfter(monthEnd)) {

            return false;

          }

          active = true;

        }

      }

      return active;

    }

    // ----------------------------------------------------------

    // Create/update monthly records

    // ----------------------------------------------------------

    final now = DateTime.now();

    DateTime month = DateTime(

      household.joinedDate.year,

      household.joinedDate.month,

    );

    final endMonth = DateTime(

      now.year,

      now.month,

    );

    while (!month.isAfter(endMonth)) {

      final chargeable = shouldChargeMonth(month);

      final existing = await (widget.database

            .select(widget.database.householdMonths)

          ..where(

            (m) =>

                m.householdId.equals(household.id) &

                m.year.equals(month.year) &

                m.month.equals(month.month),

          ))

          .getSingleOrNull();

      final correctCharge =

          chargeable ? household.monthlyCharge : 0.0;

      if (existing == null) {

        await widget.database

            .into(widget.database.householdMonths)

            .insert(

              HouseholdMonthsCompanion.insert(

                householdId: household.id,

                year: month.year,

                month: month.month,

                charge: Value(correctCharge),

              ),

            );

      } else if (existing.charge != correctCharge) {

        await (widget.database.update(

          widget.database.householdMonths,

        )..where(

            (m) => m.id.equals(existing.id),

          ))

            .write(

          HouseholdMonthsCompanion(

            charge: Value(correctCharge),

          ),

        );

      }

      month = DateTime(

        month.year,

        month.month + 1,

      );

    }

    // Rebuild allocations from the actual transaction dates.
    await _rebuildPaymentAllocations(household);

    // ----------------------------------------------------------

    // Load monthly records

    // ----------------------------------------------------------

    _months = await (widget.database

          .select(widget.database.householdMonths)

        ..where(

          (m) => m.householdId.equals(household.id),

        )

        ..orderBy([

          (m) => OrderingTerm(

                expression: m.year,

                mode: OrderingMode.asc,

              ),

          (m) => OrderingTerm(

                expression: m.month,

                mode: OrderingMode.asc,

              ),

        ]))

        .get();
    _paidByMonth.clear();
    _concessionByMonth.clear();
    _totalPaid = _openingPaid;
    _totalConcession = _openingConcession;
    _totalPayable = 0;
    _monthlyPaid = 0;


    // ----------------------------------------------------------

    // Load actual payments and actual concessions

    // ----------------------------------------------------------

    // ----------------------------------------------------------

// Load payment receipts

// ----------------------------------------------------------

_payments = await (widget.database

      .select(widget.database.householdPayments)

    ..where(

      (p) => p.householdId.equals(household.id),

    )

    ..orderBy([

      (p) => OrderingTerm(

            expression: p.paymentDate,

            mode: OrderingMode.desc,

          ),

    ]))

    .get();

    _transactionPaidByMonth.clear();
    for (final payment in _payments) {
      final key = '${payment.paymentDate.year}-${payment.paymentDate.month}';
      _transactionPaidByMonth[key] =
          (_transactionPaidByMonth[key] ?? 0) + payment.amount;
    }

// ----------------------------------------------------------

// Load concession receipts

// ----------------------------------------------------------

_concessions = await (widget.database

      .select(widget.database.householdConcessions)

    ..where(

      (c) => c.householdId.equals(household.id),

    )

    ..orderBy([

      (c) => OrderingTerm(

            expression: c.concessionDate,

            mode: OrderingMode.desc,

          ),

    ]))

    .get();

    _transactionConcessionByMonth.clear();
    for (final concession in _concessions) {
      final key =
          '${concession.concessionDate.year}-${concession.concessionDate.month}';
      _transactionConcessionByMonth[key] =
          (_transactionConcessionByMonth[key] ?? 0) + concession.amount;
    }

    for (final monthRecord in _months) {

      // --------------------------------------------------------

      // Payments allocated to this month

      // --------------------------------------------------------

      final paymentAllocations = await (widget.database

            .select(widget.database.paymentAllocations)

          ..where(

            (a) => a.householdMonthId.equals(

              monthRecord.id,

            ),

          ))

          .get();

      double paid = 0;

      for (final allocation in paymentAllocations) {

        paid += allocation.amount;

      }

      _paidByMonth[monthRecord.id] = paid;

      _monthlyPaid += paid;
      _totalPaid += paid;

      // --------------------------------------------------------

      // Concessions allocated to this month

      // --------------------------------------------------------

      final concessionAllocations = await (widget.database

            .select(

              widget.database.householdConcessionAllocations,

            )

          ..where(

            (a) => a.householdMonthId.equals(

              monthRecord.id,

            ),

          ))

          .get();

      double allocatedConcession = 0;

      for (final allocation in concessionAllocations) {

        allocatedConcession += allocation.amount;

      }

      // monthRecord.concession is retained for any older/manual

      // concession already stored directly on the month.

      final totalMonthConcession =
          allocatedConcession > 0
              ? allocatedConcession
              : monthRecord.concession;

      _concessionByMonth[monthRecord.id] =

          totalMonthConcession;

      _totalConcession += totalMonthConcession;

      // Monthly payable after the concession.

      _totalPayable +=

          monthRecord.charge - totalMonthConcession;

    }

    // ----------------------------------------------------------

    // Final outstanding balance

    //

    // Opening balance

    // + monthly charges

    // - monthly concessions

    // - payments

    // ----------------------------------------------------------
    // Actual receipts can be larger than the dues that were allocatable.
    // The unallocated remainder is an advance and must affect the signed
    // account balance without being assigned to an older month.
    final actualPaymentTotal = _payments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    final allocatedPaymentTotal = _openingPaid + _monthlyPaid;
    final unallocatedAdvance =
        actualPaymentTotal - allocatedPaymentTotal > 0
            ? actualPaymentTotal - allocatedPaymentTotal
            : 0.0;

    final runningBalance =
        _openingSignedBalance +
        _totalPayable -
        _monthlyPaid -
        unallocatedAdvance;

    _outstanding = runningBalance > 0 ? runningBalance : 0;
    _advance = runningBalance < 0 ? runningBalance.abs() : 0;

    if (!mounted) return;

    setState(() {

      _loading = false;

    });

  }

  // ============================================================

  // CLOSE ACCOUNT

  // ============================================================

  Future<void> _closeAccount() async {

    final selectedDate = await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: widget.household.joinedDate,

      lastDate: DateTime.now(),

      helpText: 'Select account closing date',

    );

    if (selectedDate == null) {

      return;

    }

    if (!_isActive) {

      return;

    }

    await widget.database

        .into(widget.database.householdStatusHistories)

        .insert(

          HouseholdStatusHistoriesCompanion.insert(

            householdId: widget.household.id,

            status: 'CLOSED',

            eventDate: selectedDate,

          ),

        );

    await (widget.database.update(

      widget.database.households,

    )..where(

        (h) => h.id.equals(widget.household.id),

      ))

        .write(

      const HouseholdsCompanion(

        isActive: Value(false),

      ),

    );

    if (!mounted) return;

    await _loadFeeCard();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(

          'Household account closed successfully.',

        ),

      ),

    );

  }

  // ============================================================

  // REOPEN ACCOUNT

  // ============================================================

  Future<void> _reopenAccount() async {

    if (_isActive) {

      return;

    }

    final lastClosedDate =

        _latestStatus?.eventDate ??

        widget.household.joinedDate;

    final minimumDate = DateTime(

      lastClosedDate.year,

      lastClosedDate.month,

      lastClosedDate.day + 1,

    );

    final today = DateTime.now();

    final selectedDate = await showDatePicker(

      context: context,

      initialDate:

          today.isBefore(minimumDate)

              ? minimumDate

              : today,

      firstDate: minimumDate,

      lastDate: DateTime(2100),

      helpText: 'Select account reopening date',

    );

    if (selectedDate == null) {

      return;

    }

    await widget.database

        .into(widget.database.householdStatusHistories)

        .insert(

          HouseholdStatusHistoriesCompanion.insert(

            householdId: widget.household.id,

            status: 'REOPENED',

            eventDate: selectedDate,

          ),

        );

    await (widget.database.update(

      widget.database.households,

    )..where(

        (h) => h.id.equals(widget.household.id),

      ))

        .write(

      const HouseholdsCompanion(

        isActive: Value(true),

      ),

    );

    if (!mounted) return;

    await _loadFeeCard();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text(

          'Household account reopened successfully.',

        ),

      ),

    );

  }

  // ============================================================

  // HELPERS

  // ============================================================

  String _monthName(int month) {

    const names = [

      'Jan',

      'Feb',

      'Mar',

      'Apr',

      'May',

      'Jun',

      'Jul',

      'Aug',

      'Sep',

      'Oct',

      'Nov',

      'Dec',

    ];

    return names[month - 1];

  }

  String _money(double value) {

    return '₹${value.toStringAsFixed(2)}';

  }

  String _openingBalanceText() {

    if (widget.household.openingBalance == 0) {

      return '₹0.00';

    }

    if (widget.household.openingBalanceType ==

        'ADVANCE') {

      return 'ADV ${_money(widget.household.openingBalance)}';

    }

    return _money(widget.household.openingBalance);

  }

  String _statusText() {

    return _isActive ? 'ACTIVE' : 'CLOSED';

  }

  Color _statusColor() {

    return _isActive

        ? Colors.green

        : Colors.red;

  }

  String _statusDateText() {

    if (_latestStatus == null) {

      return '';

    }

    final date = _latestStatus!.eventDate;

    return '${date.day.toString().padLeft(2, '0')}/'

        '${date.month.toString().padLeft(2, '0')}/'

        '${date.year}';

  }

  Future<List<String>> _transactionReceiptNumbersForMonth(
    int year,
    int month,
  ) async {
    final receipts = <String>[];

    for (final payment in _payments) {
      if (payment.paymentDate.year == year &&
          payment.paymentDate.month == month &&
          payment.receiptNumber != null &&
          payment.receiptNumber!.isNotEmpty) {
        receipts.add(payment.receiptNumber!);
      }
    }

    for (final concession in _concessions) {
      if (concession.concessionDate.year == year &&
          concession.concessionDate.month == month &&
          concession.receiptNumber != null &&
          concession.receiptNumber!.isNotEmpty) {
        receipts.add(concession.receiptNumber!);
      }
    }

    return receipts.toSet().toList();
  }

  Future<Uint8List> _buildMemberReceiptPdf(
    HouseholdPayment payment,
    double concession,
  ) async {
    final balance = await AccountingService.householdBalance(widget.database, widget.household.id);
    final balanceText = balance.outstanding > .005
        ? '₹${balance.outstanding.toStringAsFixed(2)} Due'
        : balance.advance > .005
            ? '₹${balance.advance.toStringAsFixed(2)} Advance'
            : '₹0.00';
    final settled = payment.amount + concession;
    final doc = ReceiptActions.thermalReceiptDocument(
      title: 'MONTHLY DONATION RECEIPT',
      documentNumber: payment.receiptNumber ?? 'Receipt',
      date: payment.paymentDate,
      rows: [
        ReceiptActions.thermalRow('Received from', widget.household.name),
        ReceiptActions.thermalRow('On account of', 'Monthly Donation'),
        ReceiptActions.thermalRow('Payment Mode', payment.paymentMode),
        ReceiptActions.thermalRow('Amount Received', 'INR ${payment.amount.toStringAsFixed(2)}'),
        ReceiptActions.thermalRow('Concession', 'INR ${concession.toStringAsFixed(2)}'),
      ],
      amountWords: ReceiptActions.amountInWords(payment.amount),
      totalSettled: 'INR ${settled.toStringAsFixed(2)}',
      balanceRemaining: balanceText,
    );
    return doc.save();
  }

  Future<Uint8List> _buildConcessionPdf(
    HouseholdConcession concession,
  ) async {
    final balance = await AccountingService.householdBalance(widget.database, widget.household.id);
    final balanceText = balance.outstanding > .005
        ? '₹${balance.outstanding.toStringAsFixed(2)} Due'
        : balance.advance > .005
            ? '₹${balance.advance.toStringAsFixed(2)} Advance'
            : '₹0.00';
    final doc = ReceiptActions.thermalReceiptDocument(
      title: 'MONTHLY DONATION CONCESSION',
      documentNumber: concession.receiptNumber ?? 'Concession',
      date: concession.concessionDate,
      rows: [
        ReceiptActions.thermalRow('Received from', widget.household.name),
        ReceiptActions.thermalRow('On account of', 'Monthly Donation'),
        ReceiptActions.thermalRow('Concession', 'INR ${concession.amount.toStringAsFixed(2)}'),
      ],
      totalSettled: 'INR ${concession.amount.toStringAsFixed(2)}',
      balanceRemaining: balanceText,
      remarks: concession.remarks,
    );
    return doc.save();
  }

  Future<void> _showReceiptActionsForPayment(
    HouseholdPayment payment,
    double concession,
  ) async {
    await ReceiptActions.showActionsDialog(
      context: context,
      documentNumber: payment.receiptNumber ?? 'Receipt',
      title: 'Receipt Options',
      shareMessage:
          'Baitul Maal - Monthly Donation Receipt ${payment.receiptNumber ?? ''}\n'
          'Member: ${widget.household.name}\n'
          'Amount: INR ${payment.amount.toStringAsFixed(2)}',
      buildPdf: () => _buildMemberReceiptPdf(payment, concession),
    );
  }

  Future<void> _showReceiptActionsForConcession(
    HouseholdConcession concession,
  ) async {
    await ReceiptActions.showActionsDialog(
      context: context,
      documentNumber: concession.receiptNumber ?? 'Concession',
      title: 'Receipt Options',
      shareMessage:
          'Baitul Maal - Concession ${concession.receiptNumber ?? ''}\n'
          'Member: ${widget.household.name}\n'
          'Amount: INR ${concession.amount.toStringAsFixed(2)}',
      buildPdf: () => _buildConcessionPdf(concession),
    );
  }

  Future<void> _showReceiptDetails(List<String> receiptNumbers) async {
    final payments = _payments
        .where((p) =>
            p.receiptNumber != null && receiptNumbers.contains(p.receiptNumber))
        .toList();
    final concessions = _concessions
        .where((c) =>
            c.receiptNumber != null && receiptNumbers.contains(c.receiptNumber))
        .toList();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Receipt Details'),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final payment in payments) ...[
                  Text(
                    payment.receiptNumber ?? 'Receipt',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text('Date: ${ReceiptActions.formatDate(payment.paymentDate)}'),
                  Text(
                    'Received: ${_money(payment.amount)}',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                  Text('Mode: ${payment.paymentMode}'),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.receipt_long, size: 18),
                    label: const Text('Print / Save / WhatsApp'),
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      final concession = _concessions
                          .where((c) => c.receiptNumber == payment.receiptNumber)
                          .fold<double>(0, (sum, c) => sum + c.amount);
                      await _showReceiptActionsForPayment(payment, concession);
                    },
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Transaction'),
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      final changed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTransactionPage(
                            database: widget.database,
                            source: LedgerSource.memberPayment,
                            id: payment.id,
                            title: 'Monthly Donation',
                          ),
                        ),
                      );
                      if (changed == true && mounted) await _loadFeeCard();
                    },
                  ),
                  const Divider(),
                ],
                for (final concession in concessions.where((c) =>
                    !payments.any((p) => p.receiptNumber == c.receiptNumber))) ...[
                  Text(
                    concession.receiptNumber ?? 'Concession',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                      'Date: ${ReceiptActions.formatDate(concession.concessionDate)}'),
                  Text(
                    'Concession: ${_money(concession.amount)}',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.receipt_long, size: 18),
                    label: const Text('Print / Save / WhatsApp'),
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await _showReceiptActionsForConcession(concession);
                    },
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Transaction'),
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      final changed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTransactionPage(
                            database: widget.database,
                            source: LedgerSource.memberConcession,
                            id: concession.id,
                            title: 'Concession',
                          ),
                        ),
                      );
                      if (changed == true && mounted) await _loadFeeCard();
                    },
                  ),
                  const Divider(),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household Fee Card'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Compact household summary with a light background.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.blue.shade100,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.household.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'HH-${widget.household.id.toString().padLeft(4, '0')}  •  '
                        'Start: ${_monthName(widget.household.joinedDate.month)} ${widget.household.joinedDate.year}  •  '
                        'Monthly: ${_money(widget.household.monthlyCharge)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Status: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _statusText(),
                            style: TextStyle(
                              color: _statusColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_latestStatus != null) ...[
                            const SizedBox(width: 10),
                            Text(_statusDateText()),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 14,
                        runSpacing: 2,
                        children: [
                          Text('Opening: ${_openingBalanceText()}'),
                          Text('Dues: ${_money(_totalPayable)}'),
                          Text('Paid: ${_money(_totalPaid)}'),
                          Text('Concession: ${_money(_totalConcession)}'),
                          Text(
                            _advance > 0
                                ? 'Advance: ${_money(_advance)}'
                                : 'Outstanding: ${_money(_outstanding)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _advance > 0
                                  ? Colors.blue.shade800
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HouseholdPaymentPage(
                                    database: widget.database,
                                    household: widget.household,
                                  ),
                                ),
                              );
                              if (!mounted) return;
                              await _loadFeeCard();
                            },
                            icon: const Icon(Icons.receipt_long, size: 18),
                            label: const Text('Receive Payment'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _isActive ? _closeAccount : null,
                            icon: const Icon(Icons.lock_outline, size: 18),
                            label: const Text('Close Account'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _isActive ? null : _reopenAccount,
                            icon: const Icon(Icons.lock_open, size: 18),
                            label: const Text('Reopen Account'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // The whole lower area scrolls vertically. This makes the
                // fee-card table appear before transaction history and keeps
                // several months visible at once on a phone.
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                          child: Text(
                            'Fee Card',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            dataTableTheme: DataTableThemeData(
                              headingRowColor: WidgetStateProperty.all(
                                Colors.blue.shade700,
                              ),
                              headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              dataTextStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              dividerThickness: 0.5,
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 8,
                              horizontalMargin: 6,
                              headingRowHeight: 34,
                              dataRowMinHeight: 32,
                              dataRowMaxHeight: 40,
                              columns: const [
                                DataColumn(label: Text('Month')),
                                DataColumn(label: Text('Payable')),
                                DataColumn(label: Text('Paid')),
                                DataColumn(label: Text('Concession')),
                                DataColumn(label: Text('Balance')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Rcpt No.')),
                              ],
                              rows: [
                                // Opening balance is the oldest accounting item.
                                if (widget.household.openingBalanceType == 'DUE' &&
                                    widget.household.openingBalance > 0)
                                  DataRow(
                                    color: WidgetStateProperty.all(
                                      _openingSignedBalance <= 0
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                    ),
                                    cells: [
                                      const DataCell(
                                        Text(
                                          'Opening',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _money(widget.household.openingBalance),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _openingPaid == 0
                                              ? '—'
                                              : _money(_openingPaid),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _openingConcession == 0
                                              ? '—'
                                              : _money(_openingConcession),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _money(_openingSignedBalance),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          _openingSignedBalance == 0 ? 'PAID' : 'DUE',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: _openingSignedBalance == 0
                                                ? Colors.green.shade700
                                                : Colors.red.shade700,
                                          ),
                                        ),
                                      ),
                                      const DataCell(
                                        Text(
                                          '—',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ...List<DataRow>.generate(
                                  _months.length,
                                  (index) {
                                    final row = _months[index];
                                    // Allocation data tells which older due this
                                    // payment settled. The Paid column must show
                                    // only money actually received in this month.
                                    final allocatedPaid =
                                        _paidByMonth[row.id] ?? 0;
                                    final allocatedConcession =
                                        _concessionByMonth[row.id] ?? 0;
                                    final transactionKey =
                                        '${row.year}-${row.month}';
                                    final paid =
                                        _transactionPaidByMonth[transactionKey] ?? 0;
                                    final concession =
                                        _transactionConcessionByMonth[transactionKey] ?? 0;

                                    // Status is based on the dues actually settled,
                                    // while Paid/Concession show the transaction in
                                    // the calendar month in which it was recorded.
                                    final monthCleared =
                                        allocatedPaid + allocatedConcession >=
                                            row.charge - 0.000001;
                                    final status = monthCleared
                                        ? 'PAID'
                                        : (allocatedPaid > 0 ||
                                                allocatedConcession > 0
                                            ? 'PAYMENT'
                                            : 'DUE');

                                    double runningBalance =
                                        _openingSignedBalance;
                                    for (int i = 0; i <= index; i++) {
                                      final earlier = _months[i];
                                      runningBalance +=
                                          earlier.charge -
                                          (_concessionByMonth[earlier.id] ?? 0) -
                                          (_paidByMonth[earlier.id] ?? 0);
                                    }

                                    final balanceText = runningBalance < 0
                                        ? 'ADV ${_money(runningBalance.abs())}'
                                        : _money(runningBalance);

                                    return DataRow(
                                      color: WidgetStateProperty.resolveWith<Color?>(
                                        (states) {
                                          if (status == 'DUE') {
                                            return Colors.red.shade50;
                                          }
                                          if (status == 'PAYMENT' || status == 'PAID') {
                                            return Colors.green.shade50;
                                          }
                                          return null;
                                        },
                                      ),
                                      cells: [
                                        DataCell(
                                          Text(
                                            '${_monthName(row.month)} ${row.year}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            _money(row.charge),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            paid == 0 ? '—' : _money(paid),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            concession == 0
                                                ? '—'
                                                : _money(concession),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            balanceText,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            status,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
                                              color: status == 'DUE'
                                                  ? Colors.red.shade700
                                                  : (status == 'PAYMENT' || status == 'PAID')
                                                      ? Colors.green.shade700
                                                      : Colors.black87,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 280,
                                            child: FutureBuilder<List<String>>(
                                              future: _transactionReceiptNumbersForMonth(
                                                row.year,
                                                row.month,
                                              ),
                                              builder: (context, snapshot) {
                                                final receipts =
                                                    snapshot.data ?? const <String>[];
                                                if (receipts.isEmpty) {
                                                  return const Text(
                                                    '—',
                                                    style: TextStyle(fontSize: 11),
                                                  );
                                                }
                                                return InkWell(
                                                  onTap: () => _showReceiptDetails(receipts),
                                                  child: Wrap(
                                                    spacing: 6,
                                                    runSpacing: 3,
                                                    children: receipts
                                                        .map(
                                                          (receipt) => Text(
                                                            receipt,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Colors.blue.shade800,
                                                              decoration: TextDecoration.underline,
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_advance > 0)
                          DataTable(
                            columnSpacing: 8,
                            horizontalMargin: 6,
                            dataRowMinHeight: 34,
                            dataRowMaxHeight: 42,
                            headingRowHeight: 0,
                            columns: const [
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink()),
                            ],
                            rows: [
                              DataRow(
                                color: WidgetStateProperty.all(Colors.blue.shade50),
                                cells: [
                                  const DataCell(Text('Advance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                                  const DataCell(Text('—', style: TextStyle(fontSize: 12))),
                                  const DataCell(Text('—', style: TextStyle(fontSize: 12))),
                                  const DataCell(Text('—', style: TextStyle(fontSize: 12))),
                                  DataCell(Text('ADV ${_money(_advance)}', style: TextStyle(fontSize: 12, color: Colors.blue.shade800, fontWeight: FontWeight.w600))),
                                  DataCell(Text('ADVANCE', style: TextStyle(fontSize: 11, color: Colors.blue.shade800, fontWeight: FontWeight.w600))),
                                  const DataCell(Text('—', style: TextStyle(fontSize: 11))),
                                ],
                              ),
                            ],
                          ),

                        const Divider(height: 24),

                        // Transaction history deliberately comes AFTER the
                        // complete fee card.
                        if (_payments.isNotEmpty || _concessions.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                            child: Row(
                              children: [
                                const Icon(Icons.receipt_long),
                                const SizedBox(width: 8),
                                Text(
                                  'Transaction History',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          ..._payments.map((payment) {
                            final concession = _concessions
                                .where(
                                  (c) => c.receiptNumber == payment.receiptNumber,
                                )
                                .fold<double>(0, (sum, c) => sum + c.amount);

                            return Card(
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                              color: Colors.deepPurple.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        payment.receiptNumber ?? 'Receipt',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${payment.paymentDate.day.toString().padLeft(2, '0')}/'
                                          '${payment.paymentDate.month.toString().padLeft(2, '0')}/'
                                          '${payment.paymentDate.year}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          payment.paymentMode,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Received: ${_money(payment.amount)}',
                                            style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        if (concession > 0)
                                          Expanded(
                                            child: Text(
                                              'Concession: ${_money(concession)}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () => _showReceiptActionsForPayment(payment, concession),
                                        icon: const Icon(Icons.receipt_long, size: 16),
                                        label: const Text('View / Print / Share'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          ..._concessions
                              .where(
                                (concession) => !_payments.any(
                                  (payment) =>
                                      payment.receiptNumber == concession.receiptNumber,
                                ),
                              )
                              .map((concession) {
                            return Card(
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                              color: Colors.red.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        concession.receiptNumber ?? 'Concession',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${concession.concessionDate.day.toString().padLeft(2, '0')}/'
                                          '${concession.concessionDate.month.toString().padLeft(2, '0')}/'
                                          '${concession.concessionDate.year}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const Text(
                                          'Concession only',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Concession: ${_money(concession.amount)}',
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (concession.remarks != null && concession.remarks!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          concession.remarks!,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () => _showReceiptActionsForConcession(concession),
                                        icon: const Icon(Icons.receipt_long, size: 16),
                                        label: const Text('View / Print / Share'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
