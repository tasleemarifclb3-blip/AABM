import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Households extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get parentage => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get whatsapp => text().nullable()();
  RealColumn get monthlyCharge => real().withDefault(const Constant(0.0))();
  DateTimeColumn get joinedDate => dateTime().withDefault(currentDateAndTime)();
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  TextColumn get openingBalanceType => text().withDefault(const Constant('DUE'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class HouseholdChargeHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get householdId => integer().references(Households, #id)();
  DateTimeColumn get effectiveFrom => dateTime()();
  DateTimeColumn get effectiveTo => dateTime().nullable()();
  RealColumn get monthlyCharge => real()();
}

class HouseholdMonths extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get householdId => integer().references(Households, #id)();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  RealColumn get charge => real().withDefault(const Constant(0.0))();
  RealColumn get concession => real().withDefault(const Constant(0.0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {householdId, year, month},
      ];
}

class HouseholdPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get householdId => integer().references(Households, #id)();
  DateTimeColumn get paymentDate => dateTime().withDefault(currentDateAndTime)();
  RealColumn get amount => real()();
  TextColumn get paymentMode => text()();
  TextColumn get receiptNumber => text().nullable()();
  TextColumn get username => text().withDefault(const Constant('Legacy'))();
}

class HouseholdConcessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get householdId => integer().references(Households, #id)();
  DateTimeColumn get concessionDate => dateTime().withDefault(currentDateAndTime)();
  RealColumn get amount => real()();
  TextColumn get receiptNumber => text().nullable()();
  TextColumn get remarks => text().nullable()();
  TextColumn get username => text().withDefault(const Constant('Legacy'))();
}

class HouseholdConcessionAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get concessionId => integer().references(HouseholdConcessions, #id)();
  IntColumn get householdMonthId => integer().references(HouseholdMonths, #id)();
  RealColumn get amount => real()();
}

class PaymentAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get paymentId => integer().references(HouseholdPayments, #id)();
  IntColumn get householdMonthId => integer().references(HouseholdMonths, #id)();
  RealColumn get amount => real()();
}

class OpeningBalancePaymentAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get paymentId => integer().references(HouseholdPayments, #id)();
  IntColumn get householdId => integer().references(Households, #id)();
  RealColumn get amount => real()();
}

class OpeningBalanceConcessionAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get concessionId => integer().references(HouseholdConcessions, #id)();
  IntColumn get householdId => integer().references(Households, #id)();
  RealColumn get amount => real()();
}

class HouseholdStatusHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get householdId => integer().references(Households, #id)();
  TextColumn get status => text()();
  DateTimeColumn get eventDate => dateTime()();
  TextColumn get notes => text().nullable()();
}

class FinancialTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get transactionDate => dateTime().withDefault(currentDateAndTime)();
  TextColumn get category => text()();
  TextColumn get paymentMode => text()();
  RealColumn get amount => real()();
  TextColumn get receiptNumber => text().nullable()();
  TextColumn get donorName => text().nullable()();
  TextColumn get remarks => text().nullable()();
  TextColumn get username => text().withDefault(const Constant('Legacy'))();
}

class ManualBalances extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get cashInHand => real().withDefault(const Constant(0.0))();
  RealColumn get bankBalance => real().withDefault(const Constant(0.0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class ZakaatBeneficiaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get aadhaarNumber => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get whatsapp => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class ZakaatDisbursements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get beneficiaryId => integer().nullable().references(ZakaatBeneficiaries, #id)();
  DateTimeColumn get disbursementDate => dateTime().withDefault(currentDateAndTime)();
  TextColumn get disbursementType => text().withDefault(const Constant('ONE_TIME'))();
  TextColumn get recipientName => text()();
  TextColumn get recipientAddress => text().nullable()();
  TextColumn get aadhaarNumber => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get amountInWords => text().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get issuingAuthorityReport => text().nullable()();
  TextColumn get chequeNumber => text().nullable()();
  TextColumn get paymentMode => text()();
  TextColumn get voucherNumber => text().nullable()();
  TextColumn get remarks => text().nullable()();
  TextColumn get verifiedBy1 => text().nullable()();
  TextColumn get verifiedBy2 => text().nullable()();
  TextColumn get verifiedBy3 => text().nullable()();
  TextColumn get verification => text().nullable()();
  BlobColumn get recipientSignature => blob().nullable()();
  BlobColumn get accountantSignature => blob().nullable()();
  TextColumn get username => text().withDefault(const Constant('Legacy'))();
}

/// Cash-flow adjustments which are not receipts and are therefore kept
/// separate from FinancialTransactions.
///
/// Supported adjustmentType values:
/// OTHER_EXPENSE       -> debit Donations
/// QARZA_DISBURSEMENT  -> debit Donations + debit Qarza receivable
/// QARZA_RECOVERY      -> credit Donations + credit Qarza receivable
/// SADQA_EXPENSE       -> debit Sadqa-e-Fitr
class FundAdjustments extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get transactionDate => dateTime().withDefault(currentDateAndTime)();
  TextColumn get adjustmentType => text()();
  RealColumn get amount => real()();
  TextColumn get paymentMode => text()();
  TextColumn get chequeNumber => text().nullable()();
  TextColumn get documentNumber => text().nullable()();
  TextColumn get partyName => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get aadhaarNumber => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get remarks => text().nullable()();
  TextColumn get verifiedBy1 => text().nullable()();
  TextColumn get verifiedBy2 => text().nullable()();
  TextColumn get verifiedBy3 => text().nullable()();
  TextColumn get verification => text().nullable()();
  BlobColumn get recipientSignature => blob().nullable()();
  BlobColumn get accountantSignature => blob().nullable()();
  TextColumn get username => text().withDefault(const Constant('Legacy'))();
}

@DriftDatabase(
  tables: [
    Households,
    HouseholdChargeHistories,
    HouseholdMonths,
    HouseholdPayments,
    PaymentAllocations,
    HouseholdStatusHistories,
    HouseholdConcessions,
    HouseholdConcessionAllocations,
    OpeningBalancePaymentAllocations,
    OpeningBalanceConcessionAllocations,
    FinancialTransactions,
    ManualBalances,
    ZakaatBeneficiaries,
    ZakaatDisbursements,
    FundAdjustments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          driftDatabase(
            name: 'baitul_maal',
            // Native platforms (Android/Windows) continue to use the
            // normal Drift database implementation.
            //
            // Web needs the SQLite WebAssembly module and Drift worker.
            // These files will be placed in the project's web/ folder.
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.dart.js'),
            ),
          ),
        );

  @override
  int get schemaVersion => 13;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async => migrator.createAll(),
        onUpgrade: (migrator, from, to) async {
          Future<void> addColumnIfMissing(
              String tableName, String columnName, String definition) async {
            final rows = await customSelect('PRAGMA table_info("$tableName")').get();
            final exists = rows.any((row) => row.read<String>('name') == columnName);
            if (!exists) {
              await customStatement(
                'ALTER TABLE "$tableName" ADD COLUMN "$columnName" $definition',
              );
            }
          }

          if (from < 2) {
            await migrator.createTable(householdChargeHistories);
            await migrator.createTable(householdMonths);
            await migrator.createTable(householdPayments);
            await migrator.createTable(paymentAllocations);
          }
          if (from < 3) {
            await addColumnIfMissing('households', 'opening_balance', 'REAL NOT NULL DEFAULT 0.0');
            await addColumnIfMissing('households', 'opening_balance_type', "TEXT NOT NULL DEFAULT 'DUE'");
            await migrator.createTable(householdStatusHistories);
            await customStatement('''
              INSERT INTO household_status_histories
                (household_id, status, event_date)
              SELECT id, 'STARTED', joined_date FROM households
            ''');
          }
          if (from < 4) {
            await migrator.createTable(householdConcessions);
            await migrator.createTable(householdConcessionAllocations);
          }
          if (from < 5) {
            await migrator.createTable(openingBalancePaymentAllocations);
            await migrator.createTable(openingBalanceConcessionAllocations);
          }
          if (from < 6) await migrator.createTable(financialTransactions);
          if (from < 7) await migrator.createTable(manualBalances);
          if (from < 8) {
            await migrator.createTable(zakaatBeneficiaries);
            await migrator.createTable(zakaatDisbursements);
          }
          // Version 9 added extra Zakaat fields and introduced FundAdjustments.
          if (from >= 8 && from < 9) {
            await addColumnIfMissing('zakaat_beneficiaries', 'aadhaar_number', 'TEXT');
            await addColumnIfMissing('zakaat_beneficiaries', 'phone_number', 'TEXT');
            await addColumnIfMissing('zakaat_disbursements', 'aadhaar_number', 'TEXT');
            await addColumnIfMissing('zakaat_disbursements', 'phone_number', 'TEXT');
            await addColumnIfMissing('zakaat_disbursements', 'recipient_signature', 'BLOB');
            await addColumnIfMissing('zakaat_disbursements', 'accountant_signature', 'BLOB');
          }
          if (from < 9) {
            // For databases below v9 the current table definition already
            // contains all fields required by the latest application.
            await migrator.createTable(fundAdjustments);
          } else {
            if (from < 10) {
              await addColumnIfMissing('fund_adjustments', 'recipient_signature', 'BLOB');
              await addColumnIfMissing('fund_adjustments', 'accountant_signature', 'BLOB');
            }
            if (from < 11) {
              await addColumnIfMissing('fund_adjustments', 'cheque_number', 'TEXT');
            }
          }
          if (from < 12) {
            await addColumnIfMissing('household_payments', 'username', "TEXT NOT NULL DEFAULT 'Legacy'");
            await addColumnIfMissing('household_concessions', 'username', "TEXT NOT NULL DEFAULT 'Legacy'");
            await addColumnIfMissing('financial_transactions', 'username', "TEXT NOT NULL DEFAULT 'Legacy'");
            await addColumnIfMissing('zakaat_disbursements', 'username', "TEXT NOT NULL DEFAULT 'Legacy'");
            await addColumnIfMissing('fund_adjustments', 'username', "TEXT NOT NULL DEFAULT 'Legacy'");
          }
          if (from < 13) {
            await addColumnIfMissing('zakaat_disbursements', 'verified_by_1', 'TEXT');
            await addColumnIfMissing('zakaat_disbursements', 'verified_by_2', 'TEXT');
            await addColumnIfMissing('zakaat_disbursements', 'verified_by_3', 'TEXT');
            await addColumnIfMissing('zakaat_disbursements', 'verification', 'TEXT');
            await addColumnIfMissing('fund_adjustments', 'address', 'TEXT');
            await addColumnIfMissing('fund_adjustments', 'aadhaar_number', 'TEXT');
            await addColumnIfMissing('fund_adjustments', 'phone_number', 'TEXT');
            await addColumnIfMissing('fund_adjustments', 'verified_by_1', 'TEXT');
            await addColumnIfMissing('fund_adjustments', 'verified_by_2', 'TEXT');
            await addColumnIfMissing('fund_adjustments', 'verified_by_3', 'TEXT');
            await addColumnIfMissing('fund_adjustments', 'verification', 'TEXT');
          }
        },
      );
}
