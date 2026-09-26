import 'package:drift/drift.dart';

import 'app_database.dart';
import 'workflow_service.dart';

class AccountingTotals {
  final double monthlyDonation;
  final double generalDonation;
  final double boxCollection;
  final double otherIncome;
  final double zakaatReceived;
  final double sadqaReceived;
  final double zakaatSpent;
  final double sadqaSpent;
  final double otherExpense;
  final double qarzaIssued;
  final double qarzaRecovered;
  final double qarzaWaived;
  final double donationOpening;
  final double zakaatOpening;

  const AccountingTotals({
    required this.monthlyDonation,
    required this.generalDonation,
    required this.boxCollection,
    required this.otherIncome,
    required this.zakaatReceived,
    required this.sadqaReceived,
    required this.zakaatSpent,
    required this.sadqaSpent,
    required this.otherExpense,
    required this.qarzaIssued,
    required this.qarzaRecovered,
    required this.qarzaWaived,
    required this.donationOpening,
    required this.zakaatOpening,
  });

  double get collected =>
      donationOpening +
      monthlyDonation +
      generalDonation +
      boxCollection +
      otherIncome +
      zakaatReceived +
      sadqaReceived;

  // A Qarza waiver is a fund allocation from Zakaat, but it is not a new
  // cash movement. It must therefore reduce the Zakaat fund while leaving the
  // overall cash-available figure unchanged. The waiver is included in
  // `spent`, then added back in `netAvailable` for this exact reason.
  double get spent => zakaatSpent + sadqaSpent + otherExpense;

  /// Net Qarza cash flow. A waiver reduces the borrower's receivable but does
  /// not represent a cash recovery, so it is deliberately excluded here.
  double get qarzaNet => qarzaRecovered - qarzaIssued;

  /// Overall cash available. A Qarza waiver moves an allocation from the
  /// Zakaat fund to settle a receivable without moving cash, so it cancels
  /// out of the total while still reducing the Zakaat balance.
  double get netAvailable => collected - spent + qarzaNet + qarzaWaived;

  double get donationFund =>
      donationOpening +
      monthlyDonation + generalDonation + boxCollection + otherIncome - otherExpense + qarzaNet;

  /// Available Zakaat allocation. A Qarza waiver is treated as Zakaat use and
  /// therefore reduces this fund balance. The value is clamped at zero so an
  /// old/invalid record cannot display a negative fund balance.
  double get zakaatFund =>
      (zakaatOpening + zakaatReceived - zakaatSpent).clamp(0, double.infinity).toDouble();

  double get sadqaFund => sadqaReceived - sadqaSpent;
}

class HouseholdBalance {
  final double outstanding;
  final double advance;

  const HouseholdBalance({required this.outstanding, required this.advance});
}

class AccountingService {
  static Future<AccountingTotals> totals(AppDatabase db) async {
    double monthly = 0;
    double general = 0;
    double box = 0;
    double other = 0;
    double zakaatReceived = 0;
    double sadqaReceived = 0;
    double zakaatSpent = 0;
    double sadqaSpent = 0;
    double otherExpense = 0;
    double qarzaIssued = 0;
    double qarzaRecovered = 0;
    double qarzaWaived = 0;

    final donationOpening = await WorkflowService.totalOpeningBalance(
      db,
      const ['MONTHLY_DONATION', 'GENERAL_DONATION', 'BOX_COLLECTION', 'OTHER_INCOME', 'OTHER_EXPENSE'],
    );
    final zakaatOpening = await WorkflowService.openingBalance(db, 'ZAKAAT');
    final nonEffective = await WorkflowService.nonEffectiveKeys(db);

    final payments = await db.select(db.householdPayments).get();
    for (final p in payments) {
      monthly += p.amount;
    }

    final transactions = await db.select(db.financialTransactions).get();
    for (final t in transactions) {
      switch (t.category.toUpperCase()) {
        case 'GD':
        case 'GENERAL_DONATION':
          general += t.amount;
          break;
        case 'BD':
        case 'BOX_DONATION':
          box += t.amount;
          break;
        case 'OI':
        case 'OTHER_INCOME':
          other += t.amount;
          break;
        case 'ZK':
        case 'ZAKAAT':
          zakaatReceived += t.amount;
          break;
        case 'SF':
        case 'SADQA_FITR':
          sadqaReceived += t.amount;
          break;
      }
    }

    final zakaatRows = await db.select(db.zakaatDisbursements).get();
    for (final row in zakaatRows) {
      if (nonEffective.contains('zakaat_disbursements:${row.id}')) continue;
      zakaatSpent += row.amount;
    }

    final adjustments = await db.select(db.fundAdjustments).get();
    for (final row in adjustments) {
      if ((row.adjustmentType == 'QARZA_DISBURSEMENT' || row.adjustmentType == 'OTHER_EXPENSE') &&
          nonEffective.contains('fund_adjustments:${row.id}')) {
        continue;
      }
      switch (row.adjustmentType) {
        case 'OTHER_EXPENSE':
          otherExpense += row.amount;
          break;
        case 'SADQA_EXPENSE':
          sadqaSpent += row.amount;
          break;
        case 'QARZA_DISBURSEMENT':
          qarzaIssued += row.amount;
          break;
        case 'QARZA_RECOVERY':
          qarzaRecovered += row.amount;
          break;
        case 'DELETED_RECEIPT':
          // Audit-only record. Never affects accounting totals.
          break;
      }
    }

    // A Qarza waiver is charged to the Zakaat fund. It reduces the Zakaat
    // allocation, while remaining a non-cash event for the overall cash total.
    final qarzaWaivers = await WorkflowService.qarzaWaivers(db);
    for (final waiver in qarzaWaivers) {
      zakaatSpent += waiver.amount;
      qarzaWaived += waiver.amount;
    }

    return AccountingTotals(
      monthlyDonation: monthly,
      generalDonation: general,
      boxCollection: box,
      otherIncome: other,
      zakaatReceived: zakaatReceived,
      sadqaReceived: sadqaReceived,
      zakaatSpent: zakaatSpent,
      sadqaSpent: sadqaSpent,
      otherExpense: otherExpense,
      qarzaIssued: qarzaIssued,
      qarzaRecovered: qarzaRecovered,
      qarzaWaived: qarzaWaived,
      donationOpening: donationOpening,
      zakaatOpening: zakaatOpening,
    );
  }

  static Future<double> availableDonations(AppDatabase db, {int? excludeAdjustmentId}) async {
    final t = await totals(db);
    var value = t.donationFund;
    if (excludeAdjustmentId != null) {
      final adjustments = await db.select(db.fundAdjustments).get();
      for (final a in adjustments) {
        if (a.id != excludeAdjustmentId) continue;
        if (a.adjustmentType == 'OTHER_EXPENSE' || a.adjustmentType == 'QARZA_DISBURSEMENT') {
          value += a.amount;
        } else if (a.adjustmentType == 'QARZA_RECOVERY') {
          value -= a.amount;
        }
      }
    }
    return value < 0 ? 0 : value;
  }

  static Future<double> availableZakaat(AppDatabase db, {int? excludeDisbursementId}) async {
    final t = await totals(db);
    var value = t.zakaatFund;
    if (excludeDisbursementId != null) {
      final rows = await db.select(db.zakaatDisbursements).get();
      for (final row in rows) {
        if (row.id == excludeDisbursementId) value += row.amount;
      }
    }
    return value < 0 ? 0 : value;
  }

  static Future<double> availableSadqa(AppDatabase db, {int? excludeAdjustmentId}) async {
    final t = await totals(db);
    var value = t.sadqaFund;
    if (excludeAdjustmentId != null) {
      final rows = await db.select(db.fundAdjustments).get();
      for (final row in rows) {
        if (row.id == excludeAdjustmentId && row.adjustmentType == 'SADQA_EXPENSE') value += row.amount;
      }
    }
    return value < 0 ? 0 : value;
  }

  static Future<double> qarzaOutstanding(AppDatabase db, {int? excludeAdjustmentId}) async {
    final rows = await db.select(db.fundAdjustments).get();
    final nonEffective = await WorkflowService.nonEffectiveKeys(db);
    var value = 0.0;
    for (final row in rows) {
      if (excludeAdjustmentId != null && row.id == excludeAdjustmentId) continue;
      if (nonEffective.contains('fund_adjustments:${row.id}')) continue;
      if (row.adjustmentType == 'QARZA_DISBURSEMENT') value += row.amount;
      if (row.adjustmentType == 'QARZA_RECOVERY') value -= row.amount;
    }
    final waivers = await WorkflowService.qarzaWaivers(db);
    for (final waiver in waivers) {
      final borrower = waiver.borrowerName.trim().toLowerCase();
      final hasBorrower = rows.any((r) =>
          (r.partyName ?? '').trim().toLowerCase() == borrower &&
          (r.adjustmentType == 'QARZA_DISBURSEMENT' || r.adjustmentType == 'QARZA_RECOVERY'));
      if (hasBorrower) value -= waiver.amount;
    }
    return value < 0 ? 0 : value;
  }

  static Future<void> rebuildHouseholdAllocations(
    AppDatabase db,
    int householdId, {
    bool transaction = true,
  }) async {
    Future<void> rebuild() async {
      final household = await (db.select(db.households)..where((h) => h.id.equals(householdId))).getSingle();
      final months = await (db.select(db.householdMonths)
            ..where((m) => m.householdId.equals(householdId))
            ..orderBy([(m) => OrderingTerm(expression: m.year), (m) => OrderingTerm(expression: m.month)]))
          .get();
      final payments = await (db.select(db.householdPayments)
            ..where((p) => p.householdId.equals(householdId))
            ..orderBy([(p) => OrderingTerm(expression: p.paymentDate), (p) => OrderingTerm(expression: p.id)]))
          .get();
      final concessions = await (db.select(db.householdConcessions)
            ..where((c) => c.householdId.equals(householdId))
            ..orderBy([(c) => OrderingTerm(expression: c.concessionDate), (c) => OrderingTerm(expression: c.id)]))
          .get();

      for (final p in payments) {
        await (db.delete(db.paymentAllocations)..where((a) => a.paymentId.equals(p.id))).go();
      }
      await (db.delete(db.openingBalancePaymentAllocations)..where((a) => a.householdId.equals(householdId))).go();
      for (final c in concessions) {
        await (db.delete(db.householdConcessionAllocations)..where((a) => a.concessionId.equals(c.id))).go();
      }
      await (db.delete(db.openingBalanceConcessionAllocations)..where((a) => a.householdId.equals(householdId))).go();

      double openingPaid = 0;
      double openingConceded = 0;

      for (final p in payments) {
        var remaining = p.amount;
        if (household.openingBalanceType == 'DUE' && household.openingBalance > 0 && remaining > 0) {
          final openRemaining = household.openingBalance - openingPaid - openingConceded;
          if (openRemaining > 0) {
            final alloc = remaining < openRemaining ? remaining : openRemaining;
            await db.into(db.openingBalancePaymentAllocations).insert(
              OpeningBalancePaymentAllocationsCompanion.insert(
                paymentId: p.id,
                householdId: householdId,
                amount: alloc,
              ),
            );
            openingPaid += alloc;
            remaining -= alloc;
          }
        }
        if (remaining <= 0) continue;

        for (final month in months) {
          if (remaining <= 0) break;
          final afterPaymentDate = month.year > p.paymentDate.year ||
              (month.year == p.paymentDate.year && month.month > p.paymentDate.month);
          if (afterPaymentDate) break;

          final paidRows = await (db.select(db.paymentAllocations)..where((a) => a.householdMonthId.equals(month.id))).get();
          final concededRows = await (db.select(db.householdConcessionAllocations)..where((a) => a.householdMonthId.equals(month.id))).get();
          final paid = paidRows.fold<double>(0, (sum, row) => sum + row.amount);
          final conceded = concededRows.fold<double>(0, (sum, row) => sum + row.amount);
          final due = month.charge - month.concession - paid - conceded;
          if (due <= 0) continue;
          final alloc = remaining < due ? remaining : due;
          await db.into(db.paymentAllocations).insert(
            PaymentAllocationsCompanion.insert(paymentId: p.id, householdMonthId: month.id, amount: alloc),
          );
          remaining -= alloc;
        }
      }

      for (final c in concessions) {
        var remaining = c.amount;
        if (household.openingBalanceType == 'DUE' && household.openingBalance > 0 && remaining > 0) {
          final openRemaining = household.openingBalance - openingPaid - openingConceded;
          if (openRemaining > 0) {
            final alloc = remaining < openRemaining ? remaining : openRemaining;
            await db.into(db.openingBalanceConcessionAllocations).insert(
              OpeningBalanceConcessionAllocationsCompanion.insert(
                concessionId: c.id,
                householdId: householdId,
                amount: alloc,
              ),
            );
            openingConceded += alloc;
            remaining -= alloc;
          }
        }
        if (remaining <= 0) continue;

        for (final month in months) {
          if (remaining <= 0) break;
          final afterDate = month.year > c.concessionDate.year ||
              (month.year == c.concessionDate.year && month.month > c.concessionDate.month);
          if (afterDate) break;

          final paidRows = await (db.select(db.paymentAllocations)..where((a) => a.householdMonthId.equals(month.id))).get();
          final concededRows = await (db.select(db.householdConcessionAllocations)..where((a) => a.householdMonthId.equals(month.id))).get();
          final paid = paidRows.fold<double>(0, (sum, row) => sum + row.amount);
          final conceded = concededRows.fold<double>(0, (sum, row) => sum + row.amount);
          final due = month.charge - month.concession - paid - conceded;
          if (due <= 0) continue;
          final alloc = remaining < due ? remaining : due;
          await db.into(db.householdConcessionAllocations).insert(
            HouseholdConcessionAllocationsCompanion.insert(concessionId: c.id, householdMonthId: month.id, amount: alloc),
          );
          remaining -= alloc;
        }
      }
    }

    if (transaction) {
      await db.transaction(rebuild);
    } else {
      await rebuild();
    }
  }

  static Future<HouseholdBalance> householdBalance(AppDatabase db, int householdId) async {
    final household = await (db.select(db.households)..where((h) => h.id.equals(householdId))).getSingle();
    final months = await (db.select(db.householdMonths)..where((m) => m.householdId.equals(householdId))).get();
    final payments = await (db.select(db.householdPayments)..where((p) => p.householdId.equals(householdId))).get();

    var signed = household.openingBalanceType == 'ADVANCE' ? -household.openingBalance : household.openingBalance;
    var payable = 0.0;
    for (final m in months) {
      final concessions = await (db.select(db.householdConcessionAllocations)..where((a) => a.householdMonthId.equals(m.id))).get();
      final conceded = concessions.fold<double>(0, (sum, row) => sum + row.amount);
      payable += m.charge - m.concession - conceded;
    }

    final paymentIds = payments.map((p) => p.id).toSet();
    final openingPaidRows = await (db.select(db.openingBalancePaymentAllocations)..where((a) => a.householdId.equals(householdId))).get();
    final monthlyPaidRows = await db.select(db.paymentAllocations).get();
    final openingPaid = openingPaidRows.fold<double>(0, (sum, row) => sum + row.amount);
    final monthlyPaid = monthlyPaidRows.where((a) => paymentIds.contains(a.paymentId)).fold<double>(0, (sum, row) => sum + row.amount);
    final totalPaid = payments.fold<double>(0, (sum, row) => sum + row.amount);
    signed += payable - openingPaid - monthlyPaid;
    final advance = (totalPaid - openingPaid - monthlyPaid).clamp(0, double.infinity).toDouble();
    signed -= advance;

    return signed >= 0
        ? HouseholdBalance(outstanding: signed, advance: 0)
        : HouseholdBalance(outstanding: 0, advance: -signed);
  }
}