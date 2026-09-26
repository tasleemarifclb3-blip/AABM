// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HouseholdsTable extends Households
    with TableInfo<$HouseholdsTable, Household> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentageMeta =
      const VerificationMeta('parentage');
  @override
  late final GeneratedColumn<String> parentage = GeneratedColumn<String>(
      'parentage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whatsappMeta =
      const VerificationMeta('whatsapp');
  @override
  late final GeneratedColumn<String> whatsapp = GeneratedColumn<String>(
      'whatsapp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _monthlyChargeMeta =
      const VerificationMeta('monthlyCharge');
  @override
  late final GeneratedColumn<double> monthlyCharge = GeneratedColumn<double>(
      'monthly_charge', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _joinedDateMeta =
      const VerificationMeta('joinedDate');
  @override
  late final GeneratedColumn<DateTime> joinedDate = GeneratedColumn<DateTime>(
      'joined_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _openingBalanceMeta =
      const VerificationMeta('openingBalance');
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
      'opening_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _openingBalanceTypeMeta =
      const VerificationMeta('openingBalanceType');
  @override
  late final GeneratedColumn<String> openingBalanceType =
      GeneratedColumn<String>('opening_balance_type', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('DUE'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        parentage,
        address,
        whatsapp,
        monthlyCharge,
        joinedDate,
        openingBalance,
        openingBalanceType,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'households';
  @override
  VerificationContext validateIntegrity(Insertable<Household> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parentage')) {
      context.handle(_parentageMeta,
          parentage.isAcceptableOrUnknown(data['parentage']!, _parentageMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('whatsapp')) {
      context.handle(_whatsappMeta,
          whatsapp.isAcceptableOrUnknown(data['whatsapp']!, _whatsappMeta));
    }
    if (data.containsKey('monthly_charge')) {
      context.handle(
          _monthlyChargeMeta,
          monthlyCharge.isAcceptableOrUnknown(
              data['monthly_charge']!, _monthlyChargeMeta));
    }
    if (data.containsKey('joined_date')) {
      context.handle(
          _joinedDateMeta,
          joinedDate.isAcceptableOrUnknown(
              data['joined_date']!, _joinedDateMeta));
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
          _openingBalanceMeta,
          openingBalance.isAcceptableOrUnknown(
              data['opening_balance']!, _openingBalanceMeta));
    }
    if (data.containsKey('opening_balance_type')) {
      context.handle(
          _openingBalanceTypeMeta,
          openingBalanceType.isAcceptableOrUnknown(
              data['opening_balance_type']!, _openingBalanceTypeMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Household map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Household(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parentage']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      whatsapp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}whatsapp']),
      monthlyCharge: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monthly_charge'])!,
      joinedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joined_date'])!,
      openingBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}opening_balance'])!,
      openingBalanceType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}opening_balance_type'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $HouseholdsTable createAlias(String alias) {
    return $HouseholdsTable(attachedDatabase, alias);
  }
}

class Household extends DataClass implements Insertable<Household> {
  final int id;
  final String name;
  final String? parentage;
  final String? address;
  final String? whatsapp;
  final double monthlyCharge;
  final DateTime joinedDate;
  final double openingBalance;
  final String openingBalanceType;
  final bool isActive;
  const Household(
      {required this.id,
      required this.name,
      this.parentage,
      this.address,
      this.whatsapp,
      required this.monthlyCharge,
      required this.joinedDate,
      required this.openingBalance,
      required this.openingBalanceType,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentage != null) {
      map['parentage'] = Variable<String>(parentage);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || whatsapp != null) {
      map['whatsapp'] = Variable<String>(whatsapp);
    }
    map['monthly_charge'] = Variable<double>(monthlyCharge);
    map['joined_date'] = Variable<DateTime>(joinedDate);
    map['opening_balance'] = Variable<double>(openingBalance);
    map['opening_balance_type'] = Variable<String>(openingBalanceType);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  HouseholdsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdsCompanion(
      id: Value(id),
      name: Value(name),
      parentage: parentage == null && nullToAbsent
          ? const Value.absent()
          : Value(parentage),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      whatsapp: whatsapp == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsapp),
      monthlyCharge: Value(monthlyCharge),
      joinedDate: Value(joinedDate),
      openingBalance: Value(openingBalance),
      openingBalanceType: Value(openingBalanceType),
      isActive: Value(isActive),
    );
  }

  factory Household.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Household(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentage: serializer.fromJson<String?>(json['parentage']),
      address: serializer.fromJson<String?>(json['address']),
      whatsapp: serializer.fromJson<String?>(json['whatsapp']),
      monthlyCharge: serializer.fromJson<double>(json['monthlyCharge']),
      joinedDate: serializer.fromJson<DateTime>(json['joinedDate']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      openingBalanceType:
          serializer.fromJson<String>(json['openingBalanceType']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'parentage': serializer.toJson<String?>(parentage),
      'address': serializer.toJson<String?>(address),
      'whatsapp': serializer.toJson<String?>(whatsapp),
      'monthlyCharge': serializer.toJson<double>(monthlyCharge),
      'joinedDate': serializer.toJson<DateTime>(joinedDate),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'openingBalanceType': serializer.toJson<String>(openingBalanceType),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Household copyWith(
          {int? id,
          String? name,
          Value<String?> parentage = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> whatsapp = const Value.absent(),
          double? monthlyCharge,
          DateTime? joinedDate,
          double? openingBalance,
          String? openingBalanceType,
          bool? isActive}) =>
      Household(
        id: id ?? this.id,
        name: name ?? this.name,
        parentage: parentage.present ? parentage.value : this.parentage,
        address: address.present ? address.value : this.address,
        whatsapp: whatsapp.present ? whatsapp.value : this.whatsapp,
        monthlyCharge: monthlyCharge ?? this.monthlyCharge,
        joinedDate: joinedDate ?? this.joinedDate,
        openingBalance: openingBalance ?? this.openingBalance,
        openingBalanceType: openingBalanceType ?? this.openingBalanceType,
        isActive: isActive ?? this.isActive,
      );
  Household copyWithCompanion(HouseholdsCompanion data) {
    return Household(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentage: data.parentage.present ? data.parentage.value : this.parentage,
      address: data.address.present ? data.address.value : this.address,
      whatsapp: data.whatsapp.present ? data.whatsapp.value : this.whatsapp,
      monthlyCharge: data.monthlyCharge.present
          ? data.monthlyCharge.value
          : this.monthlyCharge,
      joinedDate:
          data.joinedDate.present ? data.joinedDate.value : this.joinedDate,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      openingBalanceType: data.openingBalanceType.present
          ? data.openingBalanceType.value
          : this.openingBalanceType,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Household(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentage: $parentage, ')
          ..write('address: $address, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('monthlyCharge: $monthlyCharge, ')
          ..write('joinedDate: $joinedDate, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('openingBalanceType: $openingBalanceType, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentage, address, whatsapp,
      monthlyCharge, joinedDate, openingBalance, openingBalanceType, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Household &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentage == this.parentage &&
          other.address == this.address &&
          other.whatsapp == this.whatsapp &&
          other.monthlyCharge == this.monthlyCharge &&
          other.joinedDate == this.joinedDate &&
          other.openingBalance == this.openingBalance &&
          other.openingBalanceType == this.openingBalanceType &&
          other.isActive == this.isActive);
}

class HouseholdsCompanion extends UpdateCompanion<Household> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> parentage;
  final Value<String?> address;
  final Value<String?> whatsapp;
  final Value<double> monthlyCharge;
  final Value<DateTime> joinedDate;
  final Value<double> openingBalance;
  final Value<String> openingBalanceType;
  final Value<bool> isActive;
  const HouseholdsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentage = const Value.absent(),
    this.address = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.monthlyCharge = const Value.absent(),
    this.joinedDate = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.openingBalanceType = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  HouseholdsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentage = const Value.absent(),
    this.address = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.monthlyCharge = const Value.absent(),
    this.joinedDate = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.openingBalanceType = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Household> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? parentage,
    Expression<String>? address,
    Expression<String>? whatsapp,
    Expression<double>? monthlyCharge,
    Expression<DateTime>? joinedDate,
    Expression<double>? openingBalance,
    Expression<String>? openingBalanceType,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentage != null) 'parentage': parentage,
      if (address != null) 'address': address,
      if (whatsapp != null) 'whatsapp': whatsapp,
      if (monthlyCharge != null) 'monthly_charge': monthlyCharge,
      if (joinedDate != null) 'joined_date': joinedDate,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (openingBalanceType != null)
        'opening_balance_type': openingBalanceType,
      if (isActive != null) 'is_active': isActive,
    });
  }

  HouseholdsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? parentage,
      Value<String?>? address,
      Value<String?>? whatsapp,
      Value<double>? monthlyCharge,
      Value<DateTime>? joinedDate,
      Value<double>? openingBalance,
      Value<String>? openingBalanceType,
      Value<bool>? isActive}) {
    return HouseholdsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentage: parentage ?? this.parentage,
      address: address ?? this.address,
      whatsapp: whatsapp ?? this.whatsapp,
      monthlyCharge: monthlyCharge ?? this.monthlyCharge,
      joinedDate: joinedDate ?? this.joinedDate,
      openingBalance: openingBalance ?? this.openingBalance,
      openingBalanceType: openingBalanceType ?? this.openingBalanceType,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentage.present) {
      map['parentage'] = Variable<String>(parentage.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (whatsapp.present) {
      map['whatsapp'] = Variable<String>(whatsapp.value);
    }
    if (monthlyCharge.present) {
      map['monthly_charge'] = Variable<double>(monthlyCharge.value);
    }
    if (joinedDate.present) {
      map['joined_date'] = Variable<DateTime>(joinedDate.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (openingBalanceType.present) {
      map['opening_balance_type'] = Variable<String>(openingBalanceType.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentage: $parentage, ')
          ..write('address: $address, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('monthlyCharge: $monthlyCharge, ')
          ..write('joinedDate: $joinedDate, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('openingBalanceType: $openingBalanceType, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $HouseholdChargeHistoriesTable extends HouseholdChargeHistories
    with TableInfo<$HouseholdChargeHistoriesTable, HouseholdChargeHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdChargeHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
      'household_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _effectiveFromMeta =
      const VerificationMeta('effectiveFrom');
  @override
  late final GeneratedColumn<DateTime> effectiveFrom =
      GeneratedColumn<DateTime>('effective_from', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _effectiveToMeta =
      const VerificationMeta('effectiveTo');
  @override
  late final GeneratedColumn<DateTime> effectiveTo = GeneratedColumn<DateTime>(
      'effective_to', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _monthlyChargeMeta =
      const VerificationMeta('monthlyCharge');
  @override
  late final GeneratedColumn<double> monthlyCharge = GeneratedColumn<double>(
      'monthly_charge', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, householdId, effectiveFrom, effectiveTo, monthlyCharge];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_charge_histories';
  @override
  VerificationContext validateIntegrity(
      Insertable<HouseholdChargeHistory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('effective_from')) {
      context.handle(
          _effectiveFromMeta,
          effectiveFrom.isAcceptableOrUnknown(
              data['effective_from']!, _effectiveFromMeta));
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    if (data.containsKey('effective_to')) {
      context.handle(
          _effectiveToMeta,
          effectiveTo.isAcceptableOrUnknown(
              data['effective_to']!, _effectiveToMeta));
    }
    if (data.containsKey('monthly_charge')) {
      context.handle(
          _monthlyChargeMeta,
          monthlyCharge.isAcceptableOrUnknown(
              data['monthly_charge']!, _monthlyChargeMeta));
    } else if (isInserting) {
      context.missing(_monthlyChargeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdChargeHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdChargeHistory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}household_id'])!,
      effectiveFrom: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}effective_from'])!,
      effectiveTo: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}effective_to']),
      monthlyCharge: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monthly_charge'])!,
    );
  }

  @override
  $HouseholdChargeHistoriesTable createAlias(String alias) {
    return $HouseholdChargeHistoriesTable(attachedDatabase, alias);
  }
}

class HouseholdChargeHistory extends DataClass
    implements Insertable<HouseholdChargeHistory> {
  final int id;
  final int householdId;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final double monthlyCharge;
  const HouseholdChargeHistory(
      {required this.id,
      required this.householdId,
      required this.effectiveFrom,
      this.effectiveTo,
      required this.monthlyCharge});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['effective_from'] = Variable<DateTime>(effectiveFrom);
    if (!nullToAbsent || effectiveTo != null) {
      map['effective_to'] = Variable<DateTime>(effectiveTo);
    }
    map['monthly_charge'] = Variable<double>(monthlyCharge);
    return map;
  }

  HouseholdChargeHistoriesCompanion toCompanion(bool nullToAbsent) {
    return HouseholdChargeHistoriesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      effectiveFrom: Value(effectiveFrom),
      effectiveTo: effectiveTo == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveTo),
      monthlyCharge: Value(monthlyCharge),
    );
  }

  factory HouseholdChargeHistory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdChargeHistory(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      effectiveFrom: serializer.fromJson<DateTime>(json['effectiveFrom']),
      effectiveTo: serializer.fromJson<DateTime?>(json['effectiveTo']),
      monthlyCharge: serializer.fromJson<double>(json['monthlyCharge']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'effectiveFrom': serializer.toJson<DateTime>(effectiveFrom),
      'effectiveTo': serializer.toJson<DateTime?>(effectiveTo),
      'monthlyCharge': serializer.toJson<double>(monthlyCharge),
    };
  }

  HouseholdChargeHistory copyWith(
          {int? id,
          int? householdId,
          DateTime? effectiveFrom,
          Value<DateTime?> effectiveTo = const Value.absent(),
          double? monthlyCharge}) =>
      HouseholdChargeHistory(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        effectiveFrom: effectiveFrom ?? this.effectiveFrom,
        effectiveTo: effectiveTo.present ? effectiveTo.value : this.effectiveTo,
        monthlyCharge: monthlyCharge ?? this.monthlyCharge,
      );
  HouseholdChargeHistory copyWithCompanion(
      HouseholdChargeHistoriesCompanion data) {
    return HouseholdChargeHistory(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
      effectiveTo:
          data.effectiveTo.present ? data.effectiveTo.value : this.effectiveTo,
      monthlyCharge: data.monthlyCharge.present
          ? data.monthlyCharge.value
          : this.monthlyCharge,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdChargeHistory(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('monthlyCharge: $monthlyCharge')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, householdId, effectiveFrom, effectiveTo, monthlyCharge);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdChargeHistory &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.effectiveFrom == this.effectiveFrom &&
          other.effectiveTo == this.effectiveTo &&
          other.monthlyCharge == this.monthlyCharge);
}

class HouseholdChargeHistoriesCompanion
    extends UpdateCompanion<HouseholdChargeHistory> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<DateTime> effectiveFrom;
  final Value<DateTime?> effectiveTo;
  final Value<double> monthlyCharge;
  const HouseholdChargeHistoriesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.effectiveTo = const Value.absent(),
    this.monthlyCharge = const Value.absent(),
  });
  HouseholdChargeHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    required DateTime effectiveFrom,
    this.effectiveTo = const Value.absent(),
    required double monthlyCharge,
  })  : householdId = Value(householdId),
        effectiveFrom = Value(effectiveFrom),
        monthlyCharge = Value(monthlyCharge);
  static Insertable<HouseholdChargeHistory> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<DateTime>? effectiveFrom,
    Expression<DateTime>? effectiveTo,
    Expression<double>? monthlyCharge,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (effectiveTo != null) 'effective_to': effectiveTo,
      if (monthlyCharge != null) 'monthly_charge': monthlyCharge,
    });
  }

  HouseholdChargeHistoriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? householdId,
      Value<DateTime>? effectiveFrom,
      Value<DateTime?>? effectiveTo,
      Value<double>? monthlyCharge}) {
    return HouseholdChargeHistoriesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      monthlyCharge: monthlyCharge ?? this.monthlyCharge,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<DateTime>(effectiveFrom.value);
    }
    if (effectiveTo.present) {
      map['effective_to'] = Variable<DateTime>(effectiveTo.value);
    }
    if (monthlyCharge.present) {
      map['monthly_charge'] = Variable<double>(monthlyCharge.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdChargeHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('monthlyCharge: $monthlyCharge')
          ..write(')'))
        .toString();
  }
}

class $HouseholdMonthsTable extends HouseholdMonths
    with TableInfo<$HouseholdMonthsTable, HouseholdMonth> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdMonthsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
      'household_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chargeMeta = const VerificationMeta('charge');
  @override
  late final GeneratedColumn<double> charge = GeneratedColumn<double>(
      'charge', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _concessionMeta =
      const VerificationMeta('concession');
  @override
  late final GeneratedColumn<double> concession = GeneratedColumn<double>(
      'concession', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, householdId, year, month, charge, concession];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_months';
  @override
  VerificationContext validateIntegrity(Insertable<HouseholdMonth> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('charge')) {
      context.handle(_chargeMeta,
          charge.isAcceptableOrUnknown(data['charge']!, _chargeMeta));
    }
    if (data.containsKey('concession')) {
      context.handle(
          _concessionMeta,
          concession.isAcceptableOrUnknown(
              data['concession']!, _concessionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {householdId, year, month},
      ];
  @override
  HouseholdMonth map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdMonth(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}household_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      charge: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}charge'])!,
      concession: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}concession'])!,
    );
  }

  @override
  $HouseholdMonthsTable createAlias(String alias) {
    return $HouseholdMonthsTable(attachedDatabase, alias);
  }
}

class HouseholdMonth extends DataClass implements Insertable<HouseholdMonth> {
  final int id;
  final int householdId;
  final int year;
  final int month;
  final double charge;
  final double concession;
  const HouseholdMonth(
      {required this.id,
      required this.householdId,
      required this.year,
      required this.month,
      required this.charge,
      required this.concession});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['charge'] = Variable<double>(charge);
    map['concession'] = Variable<double>(concession);
    return map;
  }

  HouseholdMonthsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdMonthsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      year: Value(year),
      month: Value(month),
      charge: Value(charge),
      concession: Value(concession),
    );
  }

  factory HouseholdMonth.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdMonth(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      charge: serializer.fromJson<double>(json['charge']),
      concession: serializer.fromJson<double>(json['concession']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'charge': serializer.toJson<double>(charge),
      'concession': serializer.toJson<double>(concession),
    };
  }

  HouseholdMonth copyWith(
          {int? id,
          int? householdId,
          int? year,
          int? month,
          double? charge,
          double? concession}) =>
      HouseholdMonth(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        year: year ?? this.year,
        month: month ?? this.month,
        charge: charge ?? this.charge,
        concession: concession ?? this.concession,
      );
  HouseholdMonth copyWithCompanion(HouseholdMonthsCompanion data) {
    return HouseholdMonth(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      charge: data.charge.present ? data.charge.value : this.charge,
      concession:
          data.concession.present ? data.concession.value : this.concession,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdMonth(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('charge: $charge, ')
          ..write('concession: $concession')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, householdId, year, month, charge, concession);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdMonth &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.year == this.year &&
          other.month == this.month &&
          other.charge == this.charge &&
          other.concession == this.concession);
}

class HouseholdMonthsCompanion extends UpdateCompanion<HouseholdMonth> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<int> year;
  final Value<int> month;
  final Value<double> charge;
  final Value<double> concession;
  const HouseholdMonthsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.charge = const Value.absent(),
    this.concession = const Value.absent(),
  });
  HouseholdMonthsCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    required int year,
    required int month,
    this.charge = const Value.absent(),
    this.concession = const Value.absent(),
  })  : householdId = Value(householdId),
        year = Value(year),
        month = Value(month);
  static Insertable<HouseholdMonth> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<int>? year,
    Expression<int>? month,
    Expression<double>? charge,
    Expression<double>? concession,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (charge != null) 'charge': charge,
      if (concession != null) 'concession': concession,
    });
  }

  HouseholdMonthsCompanion copyWith(
      {Value<int>? id,
      Value<int>? householdId,
      Value<int>? year,
      Value<int>? month,
      Value<double>? charge,
      Value<double>? concession}) {
    return HouseholdMonthsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      year: year ?? this.year,
      month: month ?? this.month,
      charge: charge ?? this.charge,
      concession: concession ?? this.concession,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (charge.present) {
      map['charge'] = Variable<double>(charge.value);
    }
    if (concession.present) {
      map['concession'] = Variable<double>(concession.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdMonthsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('charge: $charge, ')
          ..write('concession: $concession')
          ..write(')'))
        .toString();
  }
}

class $HouseholdPaymentsTable extends HouseholdPayments
    with TableInfo<$HouseholdPaymentsTable, HouseholdPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
      'household_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _paymentDateMeta =
      const VerificationMeta('paymentDate');
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
      'payment_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentModeMeta =
      const VerificationMeta('paymentMode');
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
      'payment_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receiptNumberMeta =
      const VerificationMeta('receiptNumber');
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
      'receipt_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Legacy'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        paymentDate,
        amount,
        paymentMode,
        receiptNumber,
        username
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_payments';
  @override
  VerificationContext validateIntegrity(Insertable<HouseholdPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
          _paymentDateMeta,
          paymentDate.isAcceptableOrUnknown(
              data['payment_date']!, _paymentDateMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
          _paymentModeMeta,
          paymentMode.isAcceptableOrUnknown(
              data['payment_mode']!, _paymentModeMeta));
    } else if (isInserting) {
      context.missing(_paymentModeMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
          _receiptNumberMeta,
          receiptNumber.isAcceptableOrUnknown(
              data['receipt_number']!, _receiptNumberMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}household_id'])!,
      paymentDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}payment_date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      receiptNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_number']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
    );
  }

  @override
  $HouseholdPaymentsTable createAlias(String alias) {
    return $HouseholdPaymentsTable(attachedDatabase, alias);
  }
}

class HouseholdPayment extends DataClass
    implements Insertable<HouseholdPayment> {
  final int id;
  final int householdId;
  final DateTime paymentDate;
  final double amount;
  final String paymentMode;
  final String? receiptNumber;
  final String username;
  const HouseholdPayment(
      {required this.id,
      required this.householdId,
      required this.paymentDate,
      required this.amount,
      required this.paymentMode,
      this.receiptNumber,
      required this.username});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['payment_date'] = Variable<DateTime>(paymentDate);
    map['amount'] = Variable<double>(amount);
    map['payment_mode'] = Variable<String>(paymentMode);
    if (!nullToAbsent || receiptNumber != null) {
      map['receipt_number'] = Variable<String>(receiptNumber);
    }
    map['username'] = Variable<String>(username);
    return map;
  }

  HouseholdPaymentsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdPaymentsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      paymentDate: Value(paymentDate),
      amount: Value(amount),
      paymentMode: Value(paymentMode),
      receiptNumber: receiptNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptNumber),
      username: Value(username),
    );
  }

  factory HouseholdPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdPayment(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      receiptNumber: serializer.fromJson<String?>(json['receiptNumber']),
      username: serializer.fromJson<String>(json['username']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'amount': serializer.toJson<double>(amount),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'receiptNumber': serializer.toJson<String?>(receiptNumber),
      'username': serializer.toJson<String>(username),
    };
  }

  HouseholdPayment copyWith(
          {int? id,
          int? householdId,
          DateTime? paymentDate,
          double? amount,
          String? paymentMode,
          Value<String?> receiptNumber = const Value.absent(),
          String? username}) =>
      HouseholdPayment(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        paymentDate: paymentDate ?? this.paymentDate,
        amount: amount ?? this.amount,
        paymentMode: paymentMode ?? this.paymentMode,
        receiptNumber:
            receiptNumber.present ? receiptNumber.value : this.receiptNumber,
        username: username ?? this.username,
      );
  HouseholdPayment copyWithCompanion(HouseholdPaymentsCompanion data) {
    return HouseholdPayment(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      paymentDate:
          data.paymentDate.present ? data.paymentDate.value : this.paymentDate,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      username: data.username.present ? data.username.value : this.username,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdPayment(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('amount: $amount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, paymentDate, amount,
      paymentMode, receiptNumber, username);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdPayment &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.paymentDate == this.paymentDate &&
          other.amount == this.amount &&
          other.paymentMode == this.paymentMode &&
          other.receiptNumber == this.receiptNumber &&
          other.username == this.username);
}

class HouseholdPaymentsCompanion extends UpdateCompanion<HouseholdPayment> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<DateTime> paymentDate;
  final Value<double> amount;
  final Value<String> paymentMode;
  final Value<String?> receiptNumber;
  final Value<String> username;
  const HouseholdPaymentsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.username = const Value.absent(),
  });
  HouseholdPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    this.paymentDate = const Value.absent(),
    required double amount,
    required String paymentMode,
    this.receiptNumber = const Value.absent(),
    this.username = const Value.absent(),
  })  : householdId = Value(householdId),
        amount = Value(amount),
        paymentMode = Value(paymentMode);
  static Insertable<HouseholdPayment> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<DateTime>? paymentDate,
    Expression<double>? amount,
    Expression<String>? paymentMode,
    Expression<String>? receiptNumber,
    Expression<String>? username,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (amount != null) 'amount': amount,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (username != null) 'username': username,
    });
  }

  HouseholdPaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? householdId,
      Value<DateTime>? paymentDate,
      Value<double>? amount,
      Value<String>? paymentMode,
      Value<String?>? receiptNumber,
      Value<String>? username}) {
    return HouseholdPaymentsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      paymentDate: paymentDate ?? this.paymentDate,
      amount: amount ?? this.amount,
      paymentMode: paymentMode ?? this.paymentMode,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      username: username ?? this.username,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('amount: $amount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }
}

class $PaymentAllocationsTable extends PaymentAllocations
    with TableInfo<$PaymentAllocationsTable, PaymentAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _paymentIdMeta =
      const VerificationMeta('paymentId');
  @override
  late final GeneratedColumn<int> paymentId = GeneratedColumn<int>(
      'payment_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES household_payments (id)'));
  static const VerificationMeta _householdMonthIdMeta =
      const VerificationMeta('householdMonthId');
  @override
  late final GeneratedColumn<int> householdMonthId = GeneratedColumn<int>(
      'household_month_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES household_months (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, paymentId, householdMonthId, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_allocations';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payment_id')) {
      context.handle(_paymentIdMeta,
          paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta));
    } else if (isInserting) {
      context.missing(_paymentIdMeta);
    }
    if (data.containsKey('household_month_id')) {
      context.handle(
          _householdMonthIdMeta,
          householdMonthId.isAcceptableOrUnknown(
              data['household_month_id']!, _householdMonthIdMeta));
    } else if (isInserting) {
      context.missing(_householdMonthIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      paymentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payment_id'])!,
      householdMonthId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}household_month_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $PaymentAllocationsTable createAlias(String alias) {
    return $PaymentAllocationsTable(attachedDatabase, alias);
  }
}

class PaymentAllocation extends DataClass
    implements Insertable<PaymentAllocation> {
  final int id;
  final int paymentId;
  final int householdMonthId;
  final double amount;
  const PaymentAllocation(
      {required this.id,
      required this.paymentId,
      required this.householdMonthId,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['payment_id'] = Variable<int>(paymentId);
    map['household_month_id'] = Variable<int>(householdMonthId);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  PaymentAllocationsCompanion toCompanion(bool nullToAbsent) {
    return PaymentAllocationsCompanion(
      id: Value(id),
      paymentId: Value(paymentId),
      householdMonthId: Value(householdMonthId),
      amount: Value(amount),
    );
  }

  factory PaymentAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentAllocation(
      id: serializer.fromJson<int>(json['id']),
      paymentId: serializer.fromJson<int>(json['paymentId']),
      householdMonthId: serializer.fromJson<int>(json['householdMonthId']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'paymentId': serializer.toJson<int>(paymentId),
      'householdMonthId': serializer.toJson<int>(householdMonthId),
      'amount': serializer.toJson<double>(amount),
    };
  }

  PaymentAllocation copyWith(
          {int? id, int? paymentId, int? householdMonthId, double? amount}) =>
      PaymentAllocation(
        id: id ?? this.id,
        paymentId: paymentId ?? this.paymentId,
        householdMonthId: householdMonthId ?? this.householdMonthId,
        amount: amount ?? this.amount,
      );
  PaymentAllocation copyWithCompanion(PaymentAllocationsCompanion data) {
    return PaymentAllocation(
      id: data.id.present ? data.id.value : this.id,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      householdMonthId: data.householdMonthId.present
          ? data.householdMonthId.value
          : this.householdMonthId,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocation(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('householdMonthId: $householdMonthId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, paymentId, householdMonthId, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentAllocation &&
          other.id == this.id &&
          other.paymentId == this.paymentId &&
          other.householdMonthId == this.householdMonthId &&
          other.amount == this.amount);
}

class PaymentAllocationsCompanion extends UpdateCompanion<PaymentAllocation> {
  final Value<int> id;
  final Value<int> paymentId;
  final Value<int> householdMonthId;
  final Value<double> amount;
  const PaymentAllocationsCompanion({
    this.id = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.householdMonthId = const Value.absent(),
    this.amount = const Value.absent(),
  });
  PaymentAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int paymentId,
    required int householdMonthId,
    required double amount,
  })  : paymentId = Value(paymentId),
        householdMonthId = Value(householdMonthId),
        amount = Value(amount);
  static Insertable<PaymentAllocation> custom({
    Expression<int>? id,
    Expression<int>? paymentId,
    Expression<int>? householdMonthId,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentId != null) 'payment_id': paymentId,
      if (householdMonthId != null) 'household_month_id': householdMonthId,
      if (amount != null) 'amount': amount,
    });
  }

  PaymentAllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? paymentId,
      Value<int>? householdMonthId,
      Value<double>? amount}) {
    return PaymentAllocationsCompanion(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      householdMonthId: householdMonthId ?? this.householdMonthId,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<int>(paymentId.value);
    }
    if (householdMonthId.present) {
      map['household_month_id'] = Variable<int>(householdMonthId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('householdMonthId: $householdMonthId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $HouseholdStatusHistoriesTable extends HouseholdStatusHistories
    with TableInfo<$HouseholdStatusHistoriesTable, HouseholdStatusHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdStatusHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
      'household_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventDateMeta =
      const VerificationMeta('eventDate');
  @override
  late final GeneratedColumn<DateTime> eventDate = GeneratedColumn<DateTime>(
      'event_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, householdId, status, eventDate, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_status_histories';
  @override
  VerificationContext validateIntegrity(
      Insertable<HouseholdStatusHistory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('event_date')) {
      context.handle(_eventDateMeta,
          eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta));
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdStatusHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdStatusHistory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}household_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      eventDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}event_date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $HouseholdStatusHistoriesTable createAlias(String alias) {
    return $HouseholdStatusHistoriesTable(attachedDatabase, alias);
  }
}

class HouseholdStatusHistory extends DataClass
    implements Insertable<HouseholdStatusHistory> {
  final int id;
  final int householdId;
  final String status;
  final DateTime eventDate;
  final String? notes;
  const HouseholdStatusHistory(
      {required this.id,
      required this.householdId,
      required this.status,
      required this.eventDate,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['status'] = Variable<String>(status);
    map['event_date'] = Variable<DateTime>(eventDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  HouseholdStatusHistoriesCompanion toCompanion(bool nullToAbsent) {
    return HouseholdStatusHistoriesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      status: Value(status),
      eventDate: Value(eventDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory HouseholdStatusHistory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdStatusHistory(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      status: serializer.fromJson<String>(json['status']),
      eventDate: serializer.fromJson<DateTime>(json['eventDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'status': serializer.toJson<String>(status),
      'eventDate': serializer.toJson<DateTime>(eventDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  HouseholdStatusHistory copyWith(
          {int? id,
          int? householdId,
          String? status,
          DateTime? eventDate,
          Value<String?> notes = const Value.absent()}) =>
      HouseholdStatusHistory(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        status: status ?? this.status,
        eventDate: eventDate ?? this.eventDate,
        notes: notes.present ? notes.value : this.notes,
      );
  HouseholdStatusHistory copyWithCompanion(
      HouseholdStatusHistoriesCompanion data) {
    return HouseholdStatusHistory(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      status: data.status.present ? data.status.value : this.status,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdStatusHistory(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('status: $status, ')
          ..write('eventDate: $eventDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, status, eventDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdStatusHistory &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.status == this.status &&
          other.eventDate == this.eventDate &&
          other.notes == this.notes);
}

class HouseholdStatusHistoriesCompanion
    extends UpdateCompanion<HouseholdStatusHistory> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<String> status;
  final Value<DateTime> eventDate;
  final Value<String?> notes;
  const HouseholdStatusHistoriesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.status = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  HouseholdStatusHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    required String status,
    required DateTime eventDate,
    this.notes = const Value.absent(),
  })  : householdId = Value(householdId),
        status = Value(status),
        eventDate = Value(eventDate);
  static Insertable<HouseholdStatusHistory> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<String>? status,
    Expression<DateTime>? eventDate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (status != null) 'status': status,
      if (eventDate != null) 'event_date': eventDate,
      if (notes != null) 'notes': notes,
    });
  }

  HouseholdStatusHistoriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? householdId,
      Value<String>? status,
      Value<DateTime>? eventDate,
      Value<String?>? notes}) {
    return HouseholdStatusHistoriesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      status: status ?? this.status,
      eventDate: eventDate ?? this.eventDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdStatusHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('status: $status, ')
          ..write('eventDate: $eventDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $HouseholdConcessionsTable extends HouseholdConcessions
    with TableInfo<$HouseholdConcessionsTable, HouseholdConcession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdConcessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
      'household_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _concessionDateMeta =
      const VerificationMeta('concessionDate');
  @override
  late final GeneratedColumn<DateTime> concessionDate =
      GeneratedColumn<DateTime>('concession_date', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _receiptNumberMeta =
      const VerificationMeta('receiptNumber');
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
      'receipt_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Legacy'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        concessionDate,
        amount,
        receiptNumber,
        remarks,
        username
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_concessions';
  @override
  VerificationContext validateIntegrity(
      Insertable<HouseholdConcession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('concession_date')) {
      context.handle(
          _concessionDateMeta,
          concessionDate.isAcceptableOrUnknown(
              data['concession_date']!, _concessionDateMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
          _receiptNumberMeta,
          receiptNumber.isAcceptableOrUnknown(
              data['receipt_number']!, _receiptNumberMeta));
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdConcession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdConcession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}household_id'])!,
      concessionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}concession_date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      receiptNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_number']),
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
    );
  }

  @override
  $HouseholdConcessionsTable createAlias(String alias) {
    return $HouseholdConcessionsTable(attachedDatabase, alias);
  }
}

class HouseholdConcession extends DataClass
    implements Insertable<HouseholdConcession> {
  final int id;
  final int householdId;
  final DateTime concessionDate;
  final double amount;
  final String? receiptNumber;
  final String? remarks;
  final String username;
  const HouseholdConcession(
      {required this.id,
      required this.householdId,
      required this.concessionDate,
      required this.amount,
      this.receiptNumber,
      this.remarks,
      required this.username});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['household_id'] = Variable<int>(householdId);
    map['concession_date'] = Variable<DateTime>(concessionDate);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || receiptNumber != null) {
      map['receipt_number'] = Variable<String>(receiptNumber);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['username'] = Variable<String>(username);
    return map;
  }

  HouseholdConcessionsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdConcessionsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      concessionDate: Value(concessionDate),
      amount: Value(amount),
      receiptNumber: receiptNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptNumber),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      username: Value(username),
    );
  }

  factory HouseholdConcession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdConcession(
      id: serializer.fromJson<int>(json['id']),
      householdId: serializer.fromJson<int>(json['householdId']),
      concessionDate: serializer.fromJson<DateTime>(json['concessionDate']),
      amount: serializer.fromJson<double>(json['amount']),
      receiptNumber: serializer.fromJson<String?>(json['receiptNumber']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      username: serializer.fromJson<String>(json['username']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'householdId': serializer.toJson<int>(householdId),
      'concessionDate': serializer.toJson<DateTime>(concessionDate),
      'amount': serializer.toJson<double>(amount),
      'receiptNumber': serializer.toJson<String?>(receiptNumber),
      'remarks': serializer.toJson<String?>(remarks),
      'username': serializer.toJson<String>(username),
    };
  }

  HouseholdConcession copyWith(
          {int? id,
          int? householdId,
          DateTime? concessionDate,
          double? amount,
          Value<String?> receiptNumber = const Value.absent(),
          Value<String?> remarks = const Value.absent(),
          String? username}) =>
      HouseholdConcession(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        concessionDate: concessionDate ?? this.concessionDate,
        amount: amount ?? this.amount,
        receiptNumber:
            receiptNumber.present ? receiptNumber.value : this.receiptNumber,
        remarks: remarks.present ? remarks.value : this.remarks,
        username: username ?? this.username,
      );
  HouseholdConcession copyWithCompanion(HouseholdConcessionsCompanion data) {
    return HouseholdConcession(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      concessionDate: data.concessionDate.present
          ? data.concessionDate.value
          : this.concessionDate,
      amount: data.amount.present ? data.amount.value : this.amount,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      username: data.username.present ? data.username.value : this.username,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdConcession(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('concessionDate: $concessionDate, ')
          ..write('amount: $amount, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('remarks: $remarks, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, concessionDate, amount,
      receiptNumber, remarks, username);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdConcession &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.concessionDate == this.concessionDate &&
          other.amount == this.amount &&
          other.receiptNumber == this.receiptNumber &&
          other.remarks == this.remarks &&
          other.username == this.username);
}

class HouseholdConcessionsCompanion
    extends UpdateCompanion<HouseholdConcession> {
  final Value<int> id;
  final Value<int> householdId;
  final Value<DateTime> concessionDate;
  final Value<double> amount;
  final Value<String?> receiptNumber;
  final Value<String?> remarks;
  final Value<String> username;
  const HouseholdConcessionsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.concessionDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.remarks = const Value.absent(),
    this.username = const Value.absent(),
  });
  HouseholdConcessionsCompanion.insert({
    this.id = const Value.absent(),
    required int householdId,
    this.concessionDate = const Value.absent(),
    required double amount,
    this.receiptNumber = const Value.absent(),
    this.remarks = const Value.absent(),
    this.username = const Value.absent(),
  })  : householdId = Value(householdId),
        amount = Value(amount);
  static Insertable<HouseholdConcession> custom({
    Expression<int>? id,
    Expression<int>? householdId,
    Expression<DateTime>? concessionDate,
    Expression<double>? amount,
    Expression<String>? receiptNumber,
    Expression<String>? remarks,
    Expression<String>? username,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (concessionDate != null) 'concession_date': concessionDate,
      if (amount != null) 'amount': amount,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (remarks != null) 'remarks': remarks,
      if (username != null) 'username': username,
    });
  }

  HouseholdConcessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? householdId,
      Value<DateTime>? concessionDate,
      Value<double>? amount,
      Value<String?>? receiptNumber,
      Value<String?>? remarks,
      Value<String>? username}) {
    return HouseholdConcessionsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      concessionDate: concessionDate ?? this.concessionDate,
      amount: amount ?? this.amount,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      remarks: remarks ?? this.remarks,
      username: username ?? this.username,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (concessionDate.present) {
      map['concession_date'] = Variable<DateTime>(concessionDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdConcessionsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('concessionDate: $concessionDate, ')
          ..write('amount: $amount, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('remarks: $remarks, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }
}

class $HouseholdConcessionAllocationsTable
    extends HouseholdConcessionAllocations
    with
        TableInfo<$HouseholdConcessionAllocationsTable,
            HouseholdConcessionAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdConcessionAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _concessionIdMeta =
      const VerificationMeta('concessionId');
  @override
  late final GeneratedColumn<int> concessionId = GeneratedColumn<int>(
      'concession_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES household_concessions (id)'));
  static const VerificationMeta _householdMonthIdMeta =
      const VerificationMeta('householdMonthId');
  @override
  late final GeneratedColumn<int> householdMonthId = GeneratedColumn<int>(
      'household_month_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES household_months (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, concessionId, householdMonthId, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_concession_allocations';
  @override
  VerificationContext validateIntegrity(
      Insertable<HouseholdConcessionAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concession_id')) {
      context.handle(
          _concessionIdMeta,
          concessionId.isAcceptableOrUnknown(
              data['concession_id']!, _concessionIdMeta));
    } else if (isInserting) {
      context.missing(_concessionIdMeta);
    }
    if (data.containsKey('household_month_id')) {
      context.handle(
          _householdMonthIdMeta,
          householdMonthId.isAcceptableOrUnknown(
              data['household_month_id']!, _householdMonthIdMeta));
    } else if (isInserting) {
      context.missing(_householdMonthIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdConcessionAllocation map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdConcessionAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      concessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}concession_id'])!,
      householdMonthId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}household_month_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $HouseholdConcessionAllocationsTable createAlias(String alias) {
    return $HouseholdConcessionAllocationsTable(attachedDatabase, alias);
  }
}

class HouseholdConcessionAllocation extends DataClass
    implements Insertable<HouseholdConcessionAllocation> {
  final int id;
  final int concessionId;
  final int householdMonthId;
  final double amount;
  const HouseholdConcessionAllocation(
      {required this.id,
      required this.concessionId,
      required this.householdMonthId,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['concession_id'] = Variable<int>(concessionId);
    map['household_month_id'] = Variable<int>(householdMonthId);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  HouseholdConcessionAllocationsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdConcessionAllocationsCompanion(
      id: Value(id),
      concessionId: Value(concessionId),
      householdMonthId: Value(householdMonthId),
      amount: Value(amount),
    );
  }

  factory HouseholdConcessionAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdConcessionAllocation(
      id: serializer.fromJson<int>(json['id']),
      concessionId: serializer.fromJson<int>(json['concessionId']),
      householdMonthId: serializer.fromJson<int>(json['householdMonthId']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'concessionId': serializer.toJson<int>(concessionId),
      'householdMonthId': serializer.toJson<int>(householdMonthId),
      'amount': serializer.toJson<double>(amount),
    };
  }

  HouseholdConcessionAllocation copyWith(
          {int? id,
          int? concessionId,
          int? householdMonthId,
          double? amount}) =>
      HouseholdConcessionAllocation(
        id: id ?? this.id,
        concessionId: concessionId ?? this.concessionId,
        householdMonthId: householdMonthId ?? this.householdMonthId,
        amount: amount ?? this.amount,
      );
  HouseholdConcessionAllocation copyWithCompanion(
      HouseholdConcessionAllocationsCompanion data) {
    return HouseholdConcessionAllocation(
      id: data.id.present ? data.id.value : this.id,
      concessionId: data.concessionId.present
          ? data.concessionId.value
          : this.concessionId,
      householdMonthId: data.householdMonthId.present
          ? data.householdMonthId.value
          : this.householdMonthId,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdConcessionAllocation(')
          ..write('id: $id, ')
          ..write('concessionId: $concessionId, ')
          ..write('householdMonthId: $householdMonthId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, concessionId, householdMonthId, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdConcessionAllocation &&
          other.id == this.id &&
          other.concessionId == this.concessionId &&
          other.householdMonthId == this.householdMonthId &&
          other.amount == this.amount);
}

class HouseholdConcessionAllocationsCompanion
    extends UpdateCompanion<HouseholdConcessionAllocation> {
  final Value<int> id;
  final Value<int> concessionId;
  final Value<int> householdMonthId;
  final Value<double> amount;
  const HouseholdConcessionAllocationsCompanion({
    this.id = const Value.absent(),
    this.concessionId = const Value.absent(),
    this.householdMonthId = const Value.absent(),
    this.amount = const Value.absent(),
  });
  HouseholdConcessionAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int concessionId,
    required int householdMonthId,
    required double amount,
  })  : concessionId = Value(concessionId),
        householdMonthId = Value(householdMonthId),
        amount = Value(amount);
  static Insertable<HouseholdConcessionAllocation> custom({
    Expression<int>? id,
    Expression<int>? concessionId,
    Expression<int>? householdMonthId,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (concessionId != null) 'concession_id': concessionId,
      if (householdMonthId != null) 'household_month_id': householdMonthId,
      if (amount != null) 'amount': amount,
    });
  }

  HouseholdConcessionAllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? concessionId,
      Value<int>? householdMonthId,
      Value<double>? amount}) {
    return HouseholdConcessionAllocationsCompanion(
      id: id ?? this.id,
      concessionId: concessionId ?? this.concessionId,
      householdMonthId: householdMonthId ?? this.householdMonthId,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (concessionId.present) {
      map['concession_id'] = Variable<int>(concessionId.value);
    }
    if (householdMonthId.present) {
      map['household_month_id'] = Variable<int>(householdMonthId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdConcessionAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('concessionId: $concessionId, ')
          ..write('householdMonthId: $householdMonthId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $OpeningBalancePaymentAllocationsTable
    extends OpeningBalancePaymentAllocations
    with
        TableInfo<$OpeningBalancePaymentAllocationsTable,
            OpeningBalancePaymentAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OpeningBalancePaymentAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _paymentIdMeta =
      const VerificationMeta('paymentId');
  @override
  late final GeneratedColumn<int> paymentId = GeneratedColumn<int>(
      'payment_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES household_payments (id)'));
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
      'household_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, paymentId, householdId, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'opening_balance_payment_allocations';
  @override
  VerificationContext validateIntegrity(
      Insertable<OpeningBalancePaymentAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payment_id')) {
      context.handle(_paymentIdMeta,
          paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta));
    } else if (isInserting) {
      context.missing(_paymentIdMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OpeningBalancePaymentAllocation map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OpeningBalancePaymentAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      paymentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payment_id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}household_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $OpeningBalancePaymentAllocationsTable createAlias(String alias) {
    return $OpeningBalancePaymentAllocationsTable(attachedDatabase, alias);
  }
}

class OpeningBalancePaymentAllocation extends DataClass
    implements Insertable<OpeningBalancePaymentAllocation> {
  final int id;
  final int paymentId;
  final int householdId;
  final double amount;
  const OpeningBalancePaymentAllocation(
      {required this.id,
      required this.paymentId,
      required this.householdId,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['payment_id'] = Variable<int>(paymentId);
    map['household_id'] = Variable<int>(householdId);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  OpeningBalancePaymentAllocationsCompanion toCompanion(bool nullToAbsent) {
    return OpeningBalancePaymentAllocationsCompanion(
      id: Value(id),
      paymentId: Value(paymentId),
      householdId: Value(householdId),
      amount: Value(amount),
    );
  }

  factory OpeningBalancePaymentAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OpeningBalancePaymentAllocation(
      id: serializer.fromJson<int>(json['id']),
      paymentId: serializer.fromJson<int>(json['paymentId']),
      householdId: serializer.fromJson<int>(json['householdId']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'paymentId': serializer.toJson<int>(paymentId),
      'householdId': serializer.toJson<int>(householdId),
      'amount': serializer.toJson<double>(amount),
    };
  }

  OpeningBalancePaymentAllocation copyWith(
          {int? id, int? paymentId, int? householdId, double? amount}) =>
      OpeningBalancePaymentAllocation(
        id: id ?? this.id,
        paymentId: paymentId ?? this.paymentId,
        householdId: householdId ?? this.householdId,
        amount: amount ?? this.amount,
      );
  OpeningBalancePaymentAllocation copyWithCompanion(
      OpeningBalancePaymentAllocationsCompanion data) {
    return OpeningBalancePaymentAllocation(
      id: data.id.present ? data.id.value : this.id,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OpeningBalancePaymentAllocation(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('householdId: $householdId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, paymentId, householdId, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OpeningBalancePaymentAllocation &&
          other.id == this.id &&
          other.paymentId == this.paymentId &&
          other.householdId == this.householdId &&
          other.amount == this.amount);
}

class OpeningBalancePaymentAllocationsCompanion
    extends UpdateCompanion<OpeningBalancePaymentAllocation> {
  final Value<int> id;
  final Value<int> paymentId;
  final Value<int> householdId;
  final Value<double> amount;
  const OpeningBalancePaymentAllocationsCompanion({
    this.id = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.householdId = const Value.absent(),
    this.amount = const Value.absent(),
  });
  OpeningBalancePaymentAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int paymentId,
    required int householdId,
    required double amount,
  })  : paymentId = Value(paymentId),
        householdId = Value(householdId),
        amount = Value(amount);
  static Insertable<OpeningBalancePaymentAllocation> custom({
    Expression<int>? id,
    Expression<int>? paymentId,
    Expression<int>? householdId,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentId != null) 'payment_id': paymentId,
      if (householdId != null) 'household_id': householdId,
      if (amount != null) 'amount': amount,
    });
  }

  OpeningBalancePaymentAllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? paymentId,
      Value<int>? householdId,
      Value<double>? amount}) {
    return OpeningBalancePaymentAllocationsCompanion(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      householdId: householdId ?? this.householdId,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<int>(paymentId.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpeningBalancePaymentAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('householdId: $householdId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $OpeningBalanceConcessionAllocationsTable
    extends OpeningBalanceConcessionAllocations
    with
        TableInfo<$OpeningBalanceConcessionAllocationsTable,
            OpeningBalanceConcessionAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OpeningBalanceConcessionAllocationsTable(this.attachedDatabase,
      [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _concessionIdMeta =
      const VerificationMeta('concessionId');
  @override
  late final GeneratedColumn<int> concessionId = GeneratedColumn<int>(
      'concession_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES household_concessions (id)'));
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<int> householdId = GeneratedColumn<int>(
      'household_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, concessionId, householdId, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'opening_balance_concession_allocations';
  @override
  VerificationContext validateIntegrity(
      Insertable<OpeningBalanceConcessionAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concession_id')) {
      context.handle(
          _concessionIdMeta,
          concessionId.isAcceptableOrUnknown(
              data['concession_id']!, _concessionIdMeta));
    } else if (isInserting) {
      context.missing(_concessionIdMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OpeningBalanceConcessionAllocation map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OpeningBalanceConcessionAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      concessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}concession_id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}household_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $OpeningBalanceConcessionAllocationsTable createAlias(String alias) {
    return $OpeningBalanceConcessionAllocationsTable(attachedDatabase, alias);
  }
}

class OpeningBalanceConcessionAllocation extends DataClass
    implements Insertable<OpeningBalanceConcessionAllocation> {
  final int id;
  final int concessionId;
  final int householdId;
  final double amount;
  const OpeningBalanceConcessionAllocation(
      {required this.id,
      required this.concessionId,
      required this.householdId,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['concession_id'] = Variable<int>(concessionId);
    map['household_id'] = Variable<int>(householdId);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  OpeningBalanceConcessionAllocationsCompanion toCompanion(bool nullToAbsent) {
    return OpeningBalanceConcessionAllocationsCompanion(
      id: Value(id),
      concessionId: Value(concessionId),
      householdId: Value(householdId),
      amount: Value(amount),
    );
  }

  factory OpeningBalanceConcessionAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OpeningBalanceConcessionAllocation(
      id: serializer.fromJson<int>(json['id']),
      concessionId: serializer.fromJson<int>(json['concessionId']),
      householdId: serializer.fromJson<int>(json['householdId']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'concessionId': serializer.toJson<int>(concessionId),
      'householdId': serializer.toJson<int>(householdId),
      'amount': serializer.toJson<double>(amount),
    };
  }

  OpeningBalanceConcessionAllocation copyWith(
          {int? id, int? concessionId, int? householdId, double? amount}) =>
      OpeningBalanceConcessionAllocation(
        id: id ?? this.id,
        concessionId: concessionId ?? this.concessionId,
        householdId: householdId ?? this.householdId,
        amount: amount ?? this.amount,
      );
  OpeningBalanceConcessionAllocation copyWithCompanion(
      OpeningBalanceConcessionAllocationsCompanion data) {
    return OpeningBalanceConcessionAllocation(
      id: data.id.present ? data.id.value : this.id,
      concessionId: data.concessionId.present
          ? data.concessionId.value
          : this.concessionId,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OpeningBalanceConcessionAllocation(')
          ..write('id: $id, ')
          ..write('concessionId: $concessionId, ')
          ..write('householdId: $householdId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, concessionId, householdId, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OpeningBalanceConcessionAllocation &&
          other.id == this.id &&
          other.concessionId == this.concessionId &&
          other.householdId == this.householdId &&
          other.amount == this.amount);
}

class OpeningBalanceConcessionAllocationsCompanion
    extends UpdateCompanion<OpeningBalanceConcessionAllocation> {
  final Value<int> id;
  final Value<int> concessionId;
  final Value<int> householdId;
  final Value<double> amount;
  const OpeningBalanceConcessionAllocationsCompanion({
    this.id = const Value.absent(),
    this.concessionId = const Value.absent(),
    this.householdId = const Value.absent(),
    this.amount = const Value.absent(),
  });
  OpeningBalanceConcessionAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int concessionId,
    required int householdId,
    required double amount,
  })  : concessionId = Value(concessionId),
        householdId = Value(householdId),
        amount = Value(amount);
  static Insertable<OpeningBalanceConcessionAllocation> custom({
    Expression<int>? id,
    Expression<int>? concessionId,
    Expression<int>? householdId,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (concessionId != null) 'concession_id': concessionId,
      if (householdId != null) 'household_id': householdId,
      if (amount != null) 'amount': amount,
    });
  }

  OpeningBalanceConcessionAllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? concessionId,
      Value<int>? householdId,
      Value<double>? amount}) {
    return OpeningBalanceConcessionAllocationsCompanion(
      id: id ?? this.id,
      concessionId: concessionId ?? this.concessionId,
      householdId: householdId ?? this.householdId,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (concessionId.present) {
      map['concession_id'] = Variable<int>(concessionId.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<int>(householdId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpeningBalanceConcessionAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('concessionId: $concessionId, ')
          ..write('householdId: $householdId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $FinancialTransactionsTable extends FinancialTransactions
    with TableInfo<$FinancialTransactionsTable, FinancialTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentModeMeta =
      const VerificationMeta('paymentMode');
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
      'payment_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _receiptNumberMeta =
      const VerificationMeta('receiptNumber');
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
      'receipt_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _donorNameMeta =
      const VerificationMeta('donorName');
  @override
  late final GeneratedColumn<String> donorName = GeneratedColumn<String>(
      'donor_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Legacy'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transactionDate,
        category,
        paymentMode,
        amount,
        receiptNumber,
        donorName,
        remarks,
        username
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<FinancialTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
          _paymentModeMeta,
          paymentMode.isAcceptableOrUnknown(
              data['payment_mode']!, _paymentModeMeta));
    } else if (isInserting) {
      context.missing(_paymentModeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
          _receiptNumberMeta,
          receiptNumber.isAcceptableOrUnknown(
              data['receipt_number']!, _receiptNumberMeta));
    }
    if (data.containsKey('donor_name')) {
      context.handle(_donorNameMeta,
          donorName.isAcceptableOrUnknown(data['donor_name']!, _donorNameMeta));
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      receiptNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_number']),
      donorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}donor_name']),
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
    );
  }

  @override
  $FinancialTransactionsTable createAlias(String alias) {
    return $FinancialTransactionsTable(attachedDatabase, alias);
  }
}

class FinancialTransaction extends DataClass
    implements Insertable<FinancialTransaction> {
  final int id;
  final DateTime transactionDate;
  final String category;
  final String paymentMode;
  final double amount;
  final String? receiptNumber;
  final String? donorName;
  final String? remarks;
  final String username;
  const FinancialTransaction(
      {required this.id,
      required this.transactionDate,
      required this.category,
      required this.paymentMode,
      required this.amount,
      this.receiptNumber,
      this.donorName,
      this.remarks,
      required this.username});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['category'] = Variable<String>(category);
    map['payment_mode'] = Variable<String>(paymentMode);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || receiptNumber != null) {
      map['receipt_number'] = Variable<String>(receiptNumber);
    }
    if (!nullToAbsent || donorName != null) {
      map['donor_name'] = Variable<String>(donorName);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['username'] = Variable<String>(username);
    return map;
  }

  FinancialTransactionsCompanion toCompanion(bool nullToAbsent) {
    return FinancialTransactionsCompanion(
      id: Value(id),
      transactionDate: Value(transactionDate),
      category: Value(category),
      paymentMode: Value(paymentMode),
      amount: Value(amount),
      receiptNumber: receiptNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptNumber),
      donorName: donorName == null && nullToAbsent
          ? const Value.absent()
          : Value(donorName),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      username: Value(username),
    );
  }

  factory FinancialTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialTransaction(
      id: serializer.fromJson<int>(json['id']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      category: serializer.fromJson<String>(json['category']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      amount: serializer.fromJson<double>(json['amount']),
      receiptNumber: serializer.fromJson<String?>(json['receiptNumber']),
      donorName: serializer.fromJson<String?>(json['donorName']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      username: serializer.fromJson<String>(json['username']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'category': serializer.toJson<String>(category),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'amount': serializer.toJson<double>(amount),
      'receiptNumber': serializer.toJson<String?>(receiptNumber),
      'donorName': serializer.toJson<String?>(donorName),
      'remarks': serializer.toJson<String?>(remarks),
      'username': serializer.toJson<String>(username),
    };
  }

  FinancialTransaction copyWith(
          {int? id,
          DateTime? transactionDate,
          String? category,
          String? paymentMode,
          double? amount,
          Value<String?> receiptNumber = const Value.absent(),
          Value<String?> donorName = const Value.absent(),
          Value<String?> remarks = const Value.absent(),
          String? username}) =>
      FinancialTransaction(
        id: id ?? this.id,
        transactionDate: transactionDate ?? this.transactionDate,
        category: category ?? this.category,
        paymentMode: paymentMode ?? this.paymentMode,
        amount: amount ?? this.amount,
        receiptNumber:
            receiptNumber.present ? receiptNumber.value : this.receiptNumber,
        donorName: donorName.present ? donorName.value : this.donorName,
        remarks: remarks.present ? remarks.value : this.remarks,
        username: username ?? this.username,
      );
  FinancialTransaction copyWithCompanion(FinancialTransactionsCompanion data) {
    return FinancialTransaction(
      id: data.id.present ? data.id.value : this.id,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      category: data.category.present ? data.category.value : this.category,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      amount: data.amount.present ? data.amount.value : this.amount,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      donorName: data.donorName.present ? data.donorName.value : this.donorName,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      username: data.username.present ? data.username.value : this.username,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialTransaction(')
          ..write('id: $id, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('category: $category, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('amount: $amount, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('donorName: $donorName, ')
          ..write('remarks: $remarks, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transactionDate, category, paymentMode,
      amount, receiptNumber, donorName, remarks, username);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialTransaction &&
          other.id == this.id &&
          other.transactionDate == this.transactionDate &&
          other.category == this.category &&
          other.paymentMode == this.paymentMode &&
          other.amount == this.amount &&
          other.receiptNumber == this.receiptNumber &&
          other.donorName == this.donorName &&
          other.remarks == this.remarks &&
          other.username == this.username);
}

class FinancialTransactionsCompanion
    extends UpdateCompanion<FinancialTransaction> {
  final Value<int> id;
  final Value<DateTime> transactionDate;
  final Value<String> category;
  final Value<String> paymentMode;
  final Value<double> amount;
  final Value<String?> receiptNumber;
  final Value<String?> donorName;
  final Value<String?> remarks;
  final Value<String> username;
  const FinancialTransactionsCompanion({
    this.id = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.category = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.amount = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.donorName = const Value.absent(),
    this.remarks = const Value.absent(),
    this.username = const Value.absent(),
  });
  FinancialTransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.transactionDate = const Value.absent(),
    required String category,
    required String paymentMode,
    required double amount,
    this.receiptNumber = const Value.absent(),
    this.donorName = const Value.absent(),
    this.remarks = const Value.absent(),
    this.username = const Value.absent(),
  })  : category = Value(category),
        paymentMode = Value(paymentMode),
        amount = Value(amount);
  static Insertable<FinancialTransaction> custom({
    Expression<int>? id,
    Expression<DateTime>? transactionDate,
    Expression<String>? category,
    Expression<String>? paymentMode,
    Expression<double>? amount,
    Expression<String>? receiptNumber,
    Expression<String>? donorName,
    Expression<String>? remarks,
    Expression<String>? username,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (category != null) 'category': category,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (amount != null) 'amount': amount,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (donorName != null) 'donor_name': donorName,
      if (remarks != null) 'remarks': remarks,
      if (username != null) 'username': username,
    });
  }

  FinancialTransactionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? transactionDate,
      Value<String>? category,
      Value<String>? paymentMode,
      Value<double>? amount,
      Value<String?>? receiptNumber,
      Value<String?>? donorName,
      Value<String?>? remarks,
      Value<String>? username}) {
    return FinancialTransactionsCompanion(
      id: id ?? this.id,
      transactionDate: transactionDate ?? this.transactionDate,
      category: category ?? this.category,
      paymentMode: paymentMode ?? this.paymentMode,
      amount: amount ?? this.amount,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      donorName: donorName ?? this.donorName,
      remarks: remarks ?? this.remarks,
      username: username ?? this.username,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (donorName.present) {
      map['donor_name'] = Variable<String>(donorName.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('category: $category, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('amount: $amount, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('donorName: $donorName, ')
          ..write('remarks: $remarks, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }
}

class $ManualBalancesTable extends ManualBalances
    with TableInfo<$ManualBalancesTable, ManualBalance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManualBalancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cashInHandMeta =
      const VerificationMeta('cashInHand');
  @override
  late final GeneratedColumn<double> cashInHand = GeneratedColumn<double>(
      'cash_in_hand', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bankBalanceMeta =
      const VerificationMeta('bankBalance');
  @override
  late final GeneratedColumn<double> bankBalance = GeneratedColumn<double>(
      'bank_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, cashInHand, bankBalance, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manual_balances';
  @override
  VerificationContext validateIntegrity(Insertable<ManualBalance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cash_in_hand')) {
      context.handle(
          _cashInHandMeta,
          cashInHand.isAcceptableOrUnknown(
              data['cash_in_hand']!, _cashInHandMeta));
    }
    if (data.containsKey('bank_balance')) {
      context.handle(
          _bankBalanceMeta,
          bankBalance.isAcceptableOrUnknown(
              data['bank_balance']!, _bankBalanceMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ManualBalance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManualBalance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cashInHand: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cash_in_hand'])!,
      bankBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bank_balance'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ManualBalancesTable createAlias(String alias) {
    return $ManualBalancesTable(attachedDatabase, alias);
  }
}

class ManualBalance extends DataClass implements Insertable<ManualBalance> {
  final int id;
  final double cashInHand;
  final double bankBalance;
  final DateTime updatedAt;
  const ManualBalance(
      {required this.id,
      required this.cashInHand,
      required this.bankBalance,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cash_in_hand'] = Variable<double>(cashInHand);
    map['bank_balance'] = Variable<double>(bankBalance);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ManualBalancesCompanion toCompanion(bool nullToAbsent) {
    return ManualBalancesCompanion(
      id: Value(id),
      cashInHand: Value(cashInHand),
      bankBalance: Value(bankBalance),
      updatedAt: Value(updatedAt),
    );
  }

  factory ManualBalance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManualBalance(
      id: serializer.fromJson<int>(json['id']),
      cashInHand: serializer.fromJson<double>(json['cashInHand']),
      bankBalance: serializer.fromJson<double>(json['bankBalance']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cashInHand': serializer.toJson<double>(cashInHand),
      'bankBalance': serializer.toJson<double>(bankBalance),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ManualBalance copyWith(
          {int? id,
          double? cashInHand,
          double? bankBalance,
          DateTime? updatedAt}) =>
      ManualBalance(
        id: id ?? this.id,
        cashInHand: cashInHand ?? this.cashInHand,
        bankBalance: bankBalance ?? this.bankBalance,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ManualBalance copyWithCompanion(ManualBalancesCompanion data) {
    return ManualBalance(
      id: data.id.present ? data.id.value : this.id,
      cashInHand:
          data.cashInHand.present ? data.cashInHand.value : this.cashInHand,
      bankBalance:
          data.bankBalance.present ? data.bankBalance.value : this.bankBalance,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManualBalance(')
          ..write('id: $id, ')
          ..write('cashInHand: $cashInHand, ')
          ..write('bankBalance: $bankBalance, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cashInHand, bankBalance, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManualBalance &&
          other.id == this.id &&
          other.cashInHand == this.cashInHand &&
          other.bankBalance == this.bankBalance &&
          other.updatedAt == this.updatedAt);
}

class ManualBalancesCompanion extends UpdateCompanion<ManualBalance> {
  final Value<int> id;
  final Value<double> cashInHand;
  final Value<double> bankBalance;
  final Value<DateTime> updatedAt;
  const ManualBalancesCompanion({
    this.id = const Value.absent(),
    this.cashInHand = const Value.absent(),
    this.bankBalance = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ManualBalancesCompanion.insert({
    this.id = const Value.absent(),
    this.cashInHand = const Value.absent(),
    this.bankBalance = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<ManualBalance> custom({
    Expression<int>? id,
    Expression<double>? cashInHand,
    Expression<double>? bankBalance,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cashInHand != null) 'cash_in_hand': cashInHand,
      if (bankBalance != null) 'bank_balance': bankBalance,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ManualBalancesCompanion copyWith(
      {Value<int>? id,
      Value<double>? cashInHand,
      Value<double>? bankBalance,
      Value<DateTime>? updatedAt}) {
    return ManualBalancesCompanion(
      id: id ?? this.id,
      cashInHand: cashInHand ?? this.cashInHand,
      bankBalance: bankBalance ?? this.bankBalance,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cashInHand.present) {
      map['cash_in_hand'] = Variable<double>(cashInHand.value);
    }
    if (bankBalance.present) {
      map['bank_balance'] = Variable<double>(bankBalance.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManualBalancesCompanion(')
          ..write('id: $id, ')
          ..write('cashInHand: $cashInHand, ')
          ..write('bankBalance: $bankBalance, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ZakaatBeneficiariesTable extends ZakaatBeneficiaries
    with TableInfo<$ZakaatBeneficiariesTable, ZakaatBeneficiary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZakaatBeneficiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aadhaarNumberMeta =
      const VerificationMeta('aadhaarNumber');
  @override
  late final GeneratedColumn<String> aadhaarNumber = GeneratedColumn<String>(
      'aadhaar_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whatsappMeta =
      const VerificationMeta('whatsapp');
  @override
  late final GeneratedColumn<String> whatsapp = GeneratedColumn<String>(
      'whatsapp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        address,
        aadhaarNumber,
        phoneNumber,
        whatsapp,
        notes,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zakaat_beneficiaries';
  @override
  VerificationContext validateIntegrity(Insertable<ZakaatBeneficiary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('aadhaar_number')) {
      context.handle(
          _aadhaarNumberMeta,
          aadhaarNumber.isAcceptableOrUnknown(
              data['aadhaar_number']!, _aadhaarNumberMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('whatsapp')) {
      context.handle(_whatsappMeta,
          whatsapp.isAcceptableOrUnknown(data['whatsapp']!, _whatsappMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZakaatBeneficiary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZakaatBeneficiary(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      aadhaarNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aadhaar_number']),
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      whatsapp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}whatsapp']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ZakaatBeneficiariesTable createAlias(String alias) {
    return $ZakaatBeneficiariesTable(attachedDatabase, alias);
  }
}

class ZakaatBeneficiary extends DataClass
    implements Insertable<ZakaatBeneficiary> {
  final int id;
  final String name;
  final String? address;
  final String? aadhaarNumber;
  final String? phoneNumber;
  final String? whatsapp;
  final String? notes;
  final bool isActive;
  const ZakaatBeneficiary(
      {required this.id,
      required this.name,
      this.address,
      this.aadhaarNumber,
      this.phoneNumber,
      this.whatsapp,
      this.notes,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || aadhaarNumber != null) {
      map['aadhaar_number'] = Variable<String>(aadhaarNumber);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || whatsapp != null) {
      map['whatsapp'] = Variable<String>(whatsapp);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ZakaatBeneficiariesCompanion toCompanion(bool nullToAbsent) {
    return ZakaatBeneficiariesCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      aadhaarNumber: aadhaarNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(aadhaarNumber),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      whatsapp: whatsapp == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsapp),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isActive: Value(isActive),
    );
  }

  factory ZakaatBeneficiary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZakaatBeneficiary(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      aadhaarNumber: serializer.fromJson<String?>(json['aadhaarNumber']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      whatsapp: serializer.fromJson<String?>(json['whatsapp']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'aadhaarNumber': serializer.toJson<String?>(aadhaarNumber),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'whatsapp': serializer.toJson<String?>(whatsapp),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ZakaatBeneficiary copyWith(
          {int? id,
          String? name,
          Value<String?> address = const Value.absent(),
          Value<String?> aadhaarNumber = const Value.absent(),
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> whatsapp = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isActive}) =>
      ZakaatBeneficiary(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address.present ? address.value : this.address,
        aadhaarNumber:
            aadhaarNumber.present ? aadhaarNumber.value : this.aadhaarNumber,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        whatsapp: whatsapp.present ? whatsapp.value : this.whatsapp,
        notes: notes.present ? notes.value : this.notes,
        isActive: isActive ?? this.isActive,
      );
  ZakaatBeneficiary copyWithCompanion(ZakaatBeneficiariesCompanion data) {
    return ZakaatBeneficiary(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      aadhaarNumber: data.aadhaarNumber.present
          ? data.aadhaarNumber.value
          : this.aadhaarNumber,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      whatsapp: data.whatsapp.present ? data.whatsapp.value : this.whatsapp,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZakaatBeneficiary(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('aadhaarNumber: $aadhaarNumber, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, address, aadhaarNumber, phoneNumber, whatsapp, notes, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZakaatBeneficiary &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.aadhaarNumber == this.aadhaarNumber &&
          other.phoneNumber == this.phoneNumber &&
          other.whatsapp == this.whatsapp &&
          other.notes == this.notes &&
          other.isActive == this.isActive);
}

class ZakaatBeneficiariesCompanion extends UpdateCompanion<ZakaatBeneficiary> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> aadhaarNumber;
  final Value<String?> phoneNumber;
  final Value<String?> whatsapp;
  final Value<String?> notes;
  final Value<bool> isActive;
  const ZakaatBeneficiariesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.aadhaarNumber = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ZakaatBeneficiariesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.aadhaarNumber = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ZakaatBeneficiary> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? aadhaarNumber,
    Expression<String>? phoneNumber,
    Expression<String>? whatsapp,
    Expression<String>? notes,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (aadhaarNumber != null) 'aadhaar_number': aadhaarNumber,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (whatsapp != null) 'whatsapp': whatsapp,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ZakaatBeneficiariesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? address,
      Value<String?>? aadhaarNumber,
      Value<String?>? phoneNumber,
      Value<String?>? whatsapp,
      Value<String?>? notes,
      Value<bool>? isActive}) {
    return ZakaatBeneficiariesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsapp: whatsapp ?? this.whatsapp,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (aadhaarNumber.present) {
      map['aadhaar_number'] = Variable<String>(aadhaarNumber.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (whatsapp.present) {
      map['whatsapp'] = Variable<String>(whatsapp.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZakaatBeneficiariesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('aadhaarNumber: $aadhaarNumber, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ZakaatDisbursementsTable extends ZakaatDisbursements
    with TableInfo<$ZakaatDisbursementsTable, ZakaatDisbursement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZakaatDisbursementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _beneficiaryIdMeta =
      const VerificationMeta('beneficiaryId');
  @override
  late final GeneratedColumn<int> beneficiaryId = GeneratedColumn<int>(
      'beneficiary_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES zakaat_beneficiaries (id)'));
  static const VerificationMeta _disbursementDateMeta =
      const VerificationMeta('disbursementDate');
  @override
  late final GeneratedColumn<DateTime> disbursementDate =
      GeneratedColumn<DateTime>('disbursement_date', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _disbursementTypeMeta =
      const VerificationMeta('disbursementType');
  @override
  late final GeneratedColumn<String> disbursementType = GeneratedColumn<String>(
      'disbursement_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ONE_TIME'));
  static const VerificationMeta _recipientNameMeta =
      const VerificationMeta('recipientName');
  @override
  late final GeneratedColumn<String> recipientName = GeneratedColumn<String>(
      'recipient_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientAddressMeta =
      const VerificationMeta('recipientAddress');
  @override
  late final GeneratedColumn<String> recipientAddress = GeneratedColumn<String>(
      'recipient_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aadhaarNumberMeta =
      const VerificationMeta('aadhaarNumber');
  @override
  late final GeneratedColumn<String> aadhaarNumber = GeneratedColumn<String>(
      'aadhaar_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountInWordsMeta =
      const VerificationMeta('amountInWords');
  @override
  late final GeneratedColumn<String> amountInWords = GeneratedColumn<String>(
      'amount_in_words', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _issuingAuthorityReportMeta =
      const VerificationMeta('issuingAuthorityReport');
  @override
  late final GeneratedColumn<String> issuingAuthorityReport =
      GeneratedColumn<String>('issuing_authority_report', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chequeNumberMeta =
      const VerificationMeta('chequeNumber');
  @override
  late final GeneratedColumn<String> chequeNumber = GeneratedColumn<String>(
      'cheque_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentModeMeta =
      const VerificationMeta('paymentMode');
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
      'payment_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _voucherNumberMeta =
      const VerificationMeta('voucherNumber');
  @override
  late final GeneratedColumn<String> voucherNumber = GeneratedColumn<String>(
      'voucher_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verifiedBy1Meta =
      const VerificationMeta('verifiedBy1');
  @override
  late final GeneratedColumn<String> verifiedBy1 = GeneratedColumn<String>(
      'verified_by1', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verifiedBy2Meta =
      const VerificationMeta('verifiedBy2');
  @override
  late final GeneratedColumn<String> verifiedBy2 = GeneratedColumn<String>(
      'verified_by2', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verifiedBy3Meta =
      const VerificationMeta('verifiedBy3');
  @override
  late final GeneratedColumn<String> verifiedBy3 = GeneratedColumn<String>(
      'verified_by3', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verificationMeta =
      const VerificationMeta('verification');
  @override
  late final GeneratedColumn<String> verification = GeneratedColumn<String>(
      'verification', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recipientSignatureMeta =
      const VerificationMeta('recipientSignature');
  @override
  late final GeneratedColumn<Uint8List> recipientSignature =
      GeneratedColumn<Uint8List>('recipient_signature', aliasedName, true,
          type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _accountantSignatureMeta =
      const VerificationMeta('accountantSignature');
  @override
  late final GeneratedColumn<Uint8List> accountantSignature =
      GeneratedColumn<Uint8List>('accountant_signature', aliasedName, true,
          type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Legacy'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        beneficiaryId,
        disbursementDate,
        disbursementType,
        recipientName,
        recipientAddress,
        aadhaarNumber,
        phoneNumber,
        amount,
        amountInWords,
        reason,
        issuingAuthorityReport,
        chequeNumber,
        paymentMode,
        voucherNumber,
        remarks,
        verifiedBy1,
        verifiedBy2,
        verifiedBy3,
        verification,
        recipientSignature,
        accountantSignature,
        username
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zakaat_disbursements';
  @override
  VerificationContext validateIntegrity(Insertable<ZakaatDisbursement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('beneficiary_id')) {
      context.handle(
          _beneficiaryIdMeta,
          beneficiaryId.isAcceptableOrUnknown(
              data['beneficiary_id']!, _beneficiaryIdMeta));
    }
    if (data.containsKey('disbursement_date')) {
      context.handle(
          _disbursementDateMeta,
          disbursementDate.isAcceptableOrUnknown(
              data['disbursement_date']!, _disbursementDateMeta));
    }
    if (data.containsKey('disbursement_type')) {
      context.handle(
          _disbursementTypeMeta,
          disbursementType.isAcceptableOrUnknown(
              data['disbursement_type']!, _disbursementTypeMeta));
    }
    if (data.containsKey('recipient_name')) {
      context.handle(
          _recipientNameMeta,
          recipientName.isAcceptableOrUnknown(
              data['recipient_name']!, _recipientNameMeta));
    } else if (isInserting) {
      context.missing(_recipientNameMeta);
    }
    if (data.containsKey('recipient_address')) {
      context.handle(
          _recipientAddressMeta,
          recipientAddress.isAcceptableOrUnknown(
              data['recipient_address']!, _recipientAddressMeta));
    }
    if (data.containsKey('aadhaar_number')) {
      context.handle(
          _aadhaarNumberMeta,
          aadhaarNumber.isAcceptableOrUnknown(
              data['aadhaar_number']!, _aadhaarNumberMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('amount_in_words')) {
      context.handle(
          _amountInWordsMeta,
          amountInWords.isAcceptableOrUnknown(
              data['amount_in_words']!, _amountInWordsMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('issuing_authority_report')) {
      context.handle(
          _issuingAuthorityReportMeta,
          issuingAuthorityReport.isAcceptableOrUnknown(
              data['issuing_authority_report']!, _issuingAuthorityReportMeta));
    }
    if (data.containsKey('cheque_number')) {
      context.handle(
          _chequeNumberMeta,
          chequeNumber.isAcceptableOrUnknown(
              data['cheque_number']!, _chequeNumberMeta));
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
          _paymentModeMeta,
          paymentMode.isAcceptableOrUnknown(
              data['payment_mode']!, _paymentModeMeta));
    } else if (isInserting) {
      context.missing(_paymentModeMeta);
    }
    if (data.containsKey('voucher_number')) {
      context.handle(
          _voucherNumberMeta,
          voucherNumber.isAcceptableOrUnknown(
              data['voucher_number']!, _voucherNumberMeta));
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('verified_by1')) {
      context.handle(
          _verifiedBy1Meta,
          verifiedBy1.isAcceptableOrUnknown(
              data['verified_by1']!, _verifiedBy1Meta));
    }
    if (data.containsKey('verified_by2')) {
      context.handle(
          _verifiedBy2Meta,
          verifiedBy2.isAcceptableOrUnknown(
              data['verified_by2']!, _verifiedBy2Meta));
    }
    if (data.containsKey('verified_by3')) {
      context.handle(
          _verifiedBy3Meta,
          verifiedBy3.isAcceptableOrUnknown(
              data['verified_by3']!, _verifiedBy3Meta));
    }
    if (data.containsKey('verification')) {
      context.handle(
          _verificationMeta,
          verification.isAcceptableOrUnknown(
              data['verification']!, _verificationMeta));
    }
    if (data.containsKey('recipient_signature')) {
      context.handle(
          _recipientSignatureMeta,
          recipientSignature.isAcceptableOrUnknown(
              data['recipient_signature']!, _recipientSignatureMeta));
    }
    if (data.containsKey('accountant_signature')) {
      context.handle(
          _accountantSignatureMeta,
          accountantSignature.isAcceptableOrUnknown(
              data['accountant_signature']!, _accountantSignatureMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZakaatDisbursement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZakaatDisbursement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      beneficiaryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}beneficiary_id']),
      disbursementDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}disbursement_date'])!,
      disbursementType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}disbursement_type'])!,
      recipientName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipient_name'])!,
      recipientAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recipient_address']),
      aadhaarNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aadhaar_number']),
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      amountInWords: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount_in_words']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      issuingAuthorityReport: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}issuing_authority_report']),
      chequeNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cheque_number']),
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      voucherNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voucher_number']),
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks']),
      verifiedBy1: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verified_by1']),
      verifiedBy2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verified_by2']),
      verifiedBy3: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verified_by3']),
      verification: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verification']),
      recipientSignature: attachedDatabase.typeMapping.read(
          DriftSqlType.blob, data['${effectivePrefix}recipient_signature']),
      accountantSignature: attachedDatabase.typeMapping.read(
          DriftSqlType.blob, data['${effectivePrefix}accountant_signature']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
    );
  }

  @override
  $ZakaatDisbursementsTable createAlias(String alias) {
    return $ZakaatDisbursementsTable(attachedDatabase, alias);
  }
}

class ZakaatDisbursement extends DataClass
    implements Insertable<ZakaatDisbursement> {
  final int id;
  final int? beneficiaryId;
  final DateTime disbursementDate;
  final String disbursementType;
  final String recipientName;
  final String? recipientAddress;
  final String? aadhaarNumber;
  final String? phoneNumber;
  final double amount;
  final String? amountInWords;
  final String? reason;
  final String? issuingAuthorityReport;
  final String? chequeNumber;
  final String paymentMode;
  final String? voucherNumber;
  final String? remarks;
  final String? verifiedBy1;
  final String? verifiedBy2;
  final String? verifiedBy3;
  final String? verification;
  final Uint8List? recipientSignature;
  final Uint8List? accountantSignature;
  final String username;
  const ZakaatDisbursement(
      {required this.id,
      this.beneficiaryId,
      required this.disbursementDate,
      required this.disbursementType,
      required this.recipientName,
      this.recipientAddress,
      this.aadhaarNumber,
      this.phoneNumber,
      required this.amount,
      this.amountInWords,
      this.reason,
      this.issuingAuthorityReport,
      this.chequeNumber,
      required this.paymentMode,
      this.voucherNumber,
      this.remarks,
      this.verifiedBy1,
      this.verifiedBy2,
      this.verifiedBy3,
      this.verification,
      this.recipientSignature,
      this.accountantSignature,
      required this.username});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || beneficiaryId != null) {
      map['beneficiary_id'] = Variable<int>(beneficiaryId);
    }
    map['disbursement_date'] = Variable<DateTime>(disbursementDate);
    map['disbursement_type'] = Variable<String>(disbursementType);
    map['recipient_name'] = Variable<String>(recipientName);
    if (!nullToAbsent || recipientAddress != null) {
      map['recipient_address'] = Variable<String>(recipientAddress);
    }
    if (!nullToAbsent || aadhaarNumber != null) {
      map['aadhaar_number'] = Variable<String>(aadhaarNumber);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || amountInWords != null) {
      map['amount_in_words'] = Variable<String>(amountInWords);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || issuingAuthorityReport != null) {
      map['issuing_authority_report'] =
          Variable<String>(issuingAuthorityReport);
    }
    if (!nullToAbsent || chequeNumber != null) {
      map['cheque_number'] = Variable<String>(chequeNumber);
    }
    map['payment_mode'] = Variable<String>(paymentMode);
    if (!nullToAbsent || voucherNumber != null) {
      map['voucher_number'] = Variable<String>(voucherNumber);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    if (!nullToAbsent || verifiedBy1 != null) {
      map['verified_by1'] = Variable<String>(verifiedBy1);
    }
    if (!nullToAbsent || verifiedBy2 != null) {
      map['verified_by2'] = Variable<String>(verifiedBy2);
    }
    if (!nullToAbsent || verifiedBy3 != null) {
      map['verified_by3'] = Variable<String>(verifiedBy3);
    }
    if (!nullToAbsent || verification != null) {
      map['verification'] = Variable<String>(verification);
    }
    if (!nullToAbsent || recipientSignature != null) {
      map['recipient_signature'] = Variable<Uint8List>(recipientSignature);
    }
    if (!nullToAbsent || accountantSignature != null) {
      map['accountant_signature'] = Variable<Uint8List>(accountantSignature);
    }
    map['username'] = Variable<String>(username);
    return map;
  }

  ZakaatDisbursementsCompanion toCompanion(bool nullToAbsent) {
    return ZakaatDisbursementsCompanion(
      id: Value(id),
      beneficiaryId: beneficiaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(beneficiaryId),
      disbursementDate: Value(disbursementDate),
      disbursementType: Value(disbursementType),
      recipientName: Value(recipientName),
      recipientAddress: recipientAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(recipientAddress),
      aadhaarNumber: aadhaarNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(aadhaarNumber),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      amount: Value(amount),
      amountInWords: amountInWords == null && nullToAbsent
          ? const Value.absent()
          : Value(amountInWords),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      issuingAuthorityReport: issuingAuthorityReport == null && nullToAbsent
          ? const Value.absent()
          : Value(issuingAuthorityReport),
      chequeNumber: chequeNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(chequeNumber),
      paymentMode: Value(paymentMode),
      voucherNumber: voucherNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(voucherNumber),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      verifiedBy1: verifiedBy1 == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedBy1),
      verifiedBy2: verifiedBy2 == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedBy2),
      verifiedBy3: verifiedBy3 == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedBy3),
      verification: verification == null && nullToAbsent
          ? const Value.absent()
          : Value(verification),
      recipientSignature: recipientSignature == null && nullToAbsent
          ? const Value.absent()
          : Value(recipientSignature),
      accountantSignature: accountantSignature == null && nullToAbsent
          ? const Value.absent()
          : Value(accountantSignature),
      username: Value(username),
    );
  }

  factory ZakaatDisbursement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZakaatDisbursement(
      id: serializer.fromJson<int>(json['id']),
      beneficiaryId: serializer.fromJson<int?>(json['beneficiaryId']),
      disbursementDate: serializer.fromJson<DateTime>(json['disbursementDate']),
      disbursementType: serializer.fromJson<String>(json['disbursementType']),
      recipientName: serializer.fromJson<String>(json['recipientName']),
      recipientAddress: serializer.fromJson<String?>(json['recipientAddress']),
      aadhaarNumber: serializer.fromJson<String?>(json['aadhaarNumber']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      amount: serializer.fromJson<double>(json['amount']),
      amountInWords: serializer.fromJson<String?>(json['amountInWords']),
      reason: serializer.fromJson<String?>(json['reason']),
      issuingAuthorityReport:
          serializer.fromJson<String?>(json['issuingAuthorityReport']),
      chequeNumber: serializer.fromJson<String?>(json['chequeNumber']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      voucherNumber: serializer.fromJson<String?>(json['voucherNumber']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      verifiedBy1: serializer.fromJson<String?>(json['verifiedBy1']),
      verifiedBy2: serializer.fromJson<String?>(json['verifiedBy2']),
      verifiedBy3: serializer.fromJson<String?>(json['verifiedBy3']),
      verification: serializer.fromJson<String?>(json['verification']),
      recipientSignature:
          serializer.fromJson<Uint8List?>(json['recipientSignature']),
      accountantSignature:
          serializer.fromJson<Uint8List?>(json['accountantSignature']),
      username: serializer.fromJson<String>(json['username']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'beneficiaryId': serializer.toJson<int?>(beneficiaryId),
      'disbursementDate': serializer.toJson<DateTime>(disbursementDate),
      'disbursementType': serializer.toJson<String>(disbursementType),
      'recipientName': serializer.toJson<String>(recipientName),
      'recipientAddress': serializer.toJson<String?>(recipientAddress),
      'aadhaarNumber': serializer.toJson<String?>(aadhaarNumber),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'amount': serializer.toJson<double>(amount),
      'amountInWords': serializer.toJson<String?>(amountInWords),
      'reason': serializer.toJson<String?>(reason),
      'issuingAuthorityReport':
          serializer.toJson<String?>(issuingAuthorityReport),
      'chequeNumber': serializer.toJson<String?>(chequeNumber),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'voucherNumber': serializer.toJson<String?>(voucherNumber),
      'remarks': serializer.toJson<String?>(remarks),
      'verifiedBy1': serializer.toJson<String?>(verifiedBy1),
      'verifiedBy2': serializer.toJson<String?>(verifiedBy2),
      'verifiedBy3': serializer.toJson<String?>(verifiedBy3),
      'verification': serializer.toJson<String?>(verification),
      'recipientSignature': serializer.toJson<Uint8List?>(recipientSignature),
      'accountantSignature': serializer.toJson<Uint8List?>(accountantSignature),
      'username': serializer.toJson<String>(username),
    };
  }

  ZakaatDisbursement copyWith(
          {int? id,
          Value<int?> beneficiaryId = const Value.absent(),
          DateTime? disbursementDate,
          String? disbursementType,
          String? recipientName,
          Value<String?> recipientAddress = const Value.absent(),
          Value<String?> aadhaarNumber = const Value.absent(),
          Value<String?> phoneNumber = const Value.absent(),
          double? amount,
          Value<String?> amountInWords = const Value.absent(),
          Value<String?> reason = const Value.absent(),
          Value<String?> issuingAuthorityReport = const Value.absent(),
          Value<String?> chequeNumber = const Value.absent(),
          String? paymentMode,
          Value<String?> voucherNumber = const Value.absent(),
          Value<String?> remarks = const Value.absent(),
          Value<String?> verifiedBy1 = const Value.absent(),
          Value<String?> verifiedBy2 = const Value.absent(),
          Value<String?> verifiedBy3 = const Value.absent(),
          Value<String?> verification = const Value.absent(),
          Value<Uint8List?> recipientSignature = const Value.absent(),
          Value<Uint8List?> accountantSignature = const Value.absent(),
          String? username}) =>
      ZakaatDisbursement(
        id: id ?? this.id,
        beneficiaryId:
            beneficiaryId.present ? beneficiaryId.value : this.beneficiaryId,
        disbursementDate: disbursementDate ?? this.disbursementDate,
        disbursementType: disbursementType ?? this.disbursementType,
        recipientName: recipientName ?? this.recipientName,
        recipientAddress: recipientAddress.present
            ? recipientAddress.value
            : this.recipientAddress,
        aadhaarNumber:
            aadhaarNumber.present ? aadhaarNumber.value : this.aadhaarNumber,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        amount: amount ?? this.amount,
        amountInWords:
            amountInWords.present ? amountInWords.value : this.amountInWords,
        reason: reason.present ? reason.value : this.reason,
        issuingAuthorityReport: issuingAuthorityReport.present
            ? issuingAuthorityReport.value
            : this.issuingAuthorityReport,
        chequeNumber:
            chequeNumber.present ? chequeNumber.value : this.chequeNumber,
        paymentMode: paymentMode ?? this.paymentMode,
        voucherNumber:
            voucherNumber.present ? voucherNumber.value : this.voucherNumber,
        remarks: remarks.present ? remarks.value : this.remarks,
        verifiedBy1: verifiedBy1.present ? verifiedBy1.value : this.verifiedBy1,
        verifiedBy2: verifiedBy2.present ? verifiedBy2.value : this.verifiedBy2,
        verifiedBy3: verifiedBy3.present ? verifiedBy3.value : this.verifiedBy3,
        verification:
            verification.present ? verification.value : this.verification,
        recipientSignature: recipientSignature.present
            ? recipientSignature.value
            : this.recipientSignature,
        accountantSignature: accountantSignature.present
            ? accountantSignature.value
            : this.accountantSignature,
        username: username ?? this.username,
      );
  ZakaatDisbursement copyWithCompanion(ZakaatDisbursementsCompanion data) {
    return ZakaatDisbursement(
      id: data.id.present ? data.id.value : this.id,
      beneficiaryId: data.beneficiaryId.present
          ? data.beneficiaryId.value
          : this.beneficiaryId,
      disbursementDate: data.disbursementDate.present
          ? data.disbursementDate.value
          : this.disbursementDate,
      disbursementType: data.disbursementType.present
          ? data.disbursementType.value
          : this.disbursementType,
      recipientName: data.recipientName.present
          ? data.recipientName.value
          : this.recipientName,
      recipientAddress: data.recipientAddress.present
          ? data.recipientAddress.value
          : this.recipientAddress,
      aadhaarNumber: data.aadhaarNumber.present
          ? data.aadhaarNumber.value
          : this.aadhaarNumber,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      amount: data.amount.present ? data.amount.value : this.amount,
      amountInWords: data.amountInWords.present
          ? data.amountInWords.value
          : this.amountInWords,
      reason: data.reason.present ? data.reason.value : this.reason,
      issuingAuthorityReport: data.issuingAuthorityReport.present
          ? data.issuingAuthorityReport.value
          : this.issuingAuthorityReport,
      chequeNumber: data.chequeNumber.present
          ? data.chequeNumber.value
          : this.chequeNumber,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      voucherNumber: data.voucherNumber.present
          ? data.voucherNumber.value
          : this.voucherNumber,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      verifiedBy1:
          data.verifiedBy1.present ? data.verifiedBy1.value : this.verifiedBy1,
      verifiedBy2:
          data.verifiedBy2.present ? data.verifiedBy2.value : this.verifiedBy2,
      verifiedBy3:
          data.verifiedBy3.present ? data.verifiedBy3.value : this.verifiedBy3,
      verification: data.verification.present
          ? data.verification.value
          : this.verification,
      recipientSignature: data.recipientSignature.present
          ? data.recipientSignature.value
          : this.recipientSignature,
      accountantSignature: data.accountantSignature.present
          ? data.accountantSignature.value
          : this.accountantSignature,
      username: data.username.present ? data.username.value : this.username,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZakaatDisbursement(')
          ..write('id: $id, ')
          ..write('beneficiaryId: $beneficiaryId, ')
          ..write('disbursementDate: $disbursementDate, ')
          ..write('disbursementType: $disbursementType, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientAddress: $recipientAddress, ')
          ..write('aadhaarNumber: $aadhaarNumber, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('amount: $amount, ')
          ..write('amountInWords: $amountInWords, ')
          ..write('reason: $reason, ')
          ..write('issuingAuthorityReport: $issuingAuthorityReport, ')
          ..write('chequeNumber: $chequeNumber, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('voucherNumber: $voucherNumber, ')
          ..write('remarks: $remarks, ')
          ..write('verifiedBy1: $verifiedBy1, ')
          ..write('verifiedBy2: $verifiedBy2, ')
          ..write('verifiedBy3: $verifiedBy3, ')
          ..write('verification: $verification, ')
          ..write('recipientSignature: $recipientSignature, ')
          ..write('accountantSignature: $accountantSignature, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        beneficiaryId,
        disbursementDate,
        disbursementType,
        recipientName,
        recipientAddress,
        aadhaarNumber,
        phoneNumber,
        amount,
        amountInWords,
        reason,
        issuingAuthorityReport,
        chequeNumber,
        paymentMode,
        voucherNumber,
        remarks,
        verifiedBy1,
        verifiedBy2,
        verifiedBy3,
        verification,
        $driftBlobEquality.hash(recipientSignature),
        $driftBlobEquality.hash(accountantSignature),
        username
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZakaatDisbursement &&
          other.id == this.id &&
          other.beneficiaryId == this.beneficiaryId &&
          other.disbursementDate == this.disbursementDate &&
          other.disbursementType == this.disbursementType &&
          other.recipientName == this.recipientName &&
          other.recipientAddress == this.recipientAddress &&
          other.aadhaarNumber == this.aadhaarNumber &&
          other.phoneNumber == this.phoneNumber &&
          other.amount == this.amount &&
          other.amountInWords == this.amountInWords &&
          other.reason == this.reason &&
          other.issuingAuthorityReport == this.issuingAuthorityReport &&
          other.chequeNumber == this.chequeNumber &&
          other.paymentMode == this.paymentMode &&
          other.voucherNumber == this.voucherNumber &&
          other.remarks == this.remarks &&
          other.verifiedBy1 == this.verifiedBy1 &&
          other.verifiedBy2 == this.verifiedBy2 &&
          other.verifiedBy3 == this.verifiedBy3 &&
          other.verification == this.verification &&
          $driftBlobEquality.equals(
              other.recipientSignature, this.recipientSignature) &&
          $driftBlobEquality.equals(
              other.accountantSignature, this.accountantSignature) &&
          other.username == this.username);
}

class ZakaatDisbursementsCompanion extends UpdateCompanion<ZakaatDisbursement> {
  final Value<int> id;
  final Value<int?> beneficiaryId;
  final Value<DateTime> disbursementDate;
  final Value<String> disbursementType;
  final Value<String> recipientName;
  final Value<String?> recipientAddress;
  final Value<String?> aadhaarNumber;
  final Value<String?> phoneNumber;
  final Value<double> amount;
  final Value<String?> amountInWords;
  final Value<String?> reason;
  final Value<String?> issuingAuthorityReport;
  final Value<String?> chequeNumber;
  final Value<String> paymentMode;
  final Value<String?> voucherNumber;
  final Value<String?> remarks;
  final Value<String?> verifiedBy1;
  final Value<String?> verifiedBy2;
  final Value<String?> verifiedBy3;
  final Value<String?> verification;
  final Value<Uint8List?> recipientSignature;
  final Value<Uint8List?> accountantSignature;
  final Value<String> username;
  const ZakaatDisbursementsCompanion({
    this.id = const Value.absent(),
    this.beneficiaryId = const Value.absent(),
    this.disbursementDate = const Value.absent(),
    this.disbursementType = const Value.absent(),
    this.recipientName = const Value.absent(),
    this.recipientAddress = const Value.absent(),
    this.aadhaarNumber = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountInWords = const Value.absent(),
    this.reason = const Value.absent(),
    this.issuingAuthorityReport = const Value.absent(),
    this.chequeNumber = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.voucherNumber = const Value.absent(),
    this.remarks = const Value.absent(),
    this.verifiedBy1 = const Value.absent(),
    this.verifiedBy2 = const Value.absent(),
    this.verifiedBy3 = const Value.absent(),
    this.verification = const Value.absent(),
    this.recipientSignature = const Value.absent(),
    this.accountantSignature = const Value.absent(),
    this.username = const Value.absent(),
  });
  ZakaatDisbursementsCompanion.insert({
    this.id = const Value.absent(),
    this.beneficiaryId = const Value.absent(),
    this.disbursementDate = const Value.absent(),
    this.disbursementType = const Value.absent(),
    required String recipientName,
    this.recipientAddress = const Value.absent(),
    this.aadhaarNumber = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    required double amount,
    this.amountInWords = const Value.absent(),
    this.reason = const Value.absent(),
    this.issuingAuthorityReport = const Value.absent(),
    this.chequeNumber = const Value.absent(),
    required String paymentMode,
    this.voucherNumber = const Value.absent(),
    this.remarks = const Value.absent(),
    this.verifiedBy1 = const Value.absent(),
    this.verifiedBy2 = const Value.absent(),
    this.verifiedBy3 = const Value.absent(),
    this.verification = const Value.absent(),
    this.recipientSignature = const Value.absent(),
    this.accountantSignature = const Value.absent(),
    this.username = const Value.absent(),
  })  : recipientName = Value(recipientName),
        amount = Value(amount),
        paymentMode = Value(paymentMode);
  static Insertable<ZakaatDisbursement> custom({
    Expression<int>? id,
    Expression<int>? beneficiaryId,
    Expression<DateTime>? disbursementDate,
    Expression<String>? disbursementType,
    Expression<String>? recipientName,
    Expression<String>? recipientAddress,
    Expression<String>? aadhaarNumber,
    Expression<String>? phoneNumber,
    Expression<double>? amount,
    Expression<String>? amountInWords,
    Expression<String>? reason,
    Expression<String>? issuingAuthorityReport,
    Expression<String>? chequeNumber,
    Expression<String>? paymentMode,
    Expression<String>? voucherNumber,
    Expression<String>? remarks,
    Expression<String>? verifiedBy1,
    Expression<String>? verifiedBy2,
    Expression<String>? verifiedBy3,
    Expression<String>? verification,
    Expression<Uint8List>? recipientSignature,
    Expression<Uint8List>? accountantSignature,
    Expression<String>? username,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (beneficiaryId != null) 'beneficiary_id': beneficiaryId,
      if (disbursementDate != null) 'disbursement_date': disbursementDate,
      if (disbursementType != null) 'disbursement_type': disbursementType,
      if (recipientName != null) 'recipient_name': recipientName,
      if (recipientAddress != null) 'recipient_address': recipientAddress,
      if (aadhaarNumber != null) 'aadhaar_number': aadhaarNumber,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (amount != null) 'amount': amount,
      if (amountInWords != null) 'amount_in_words': amountInWords,
      if (reason != null) 'reason': reason,
      if (issuingAuthorityReport != null)
        'issuing_authority_report': issuingAuthorityReport,
      if (chequeNumber != null) 'cheque_number': chequeNumber,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (voucherNumber != null) 'voucher_number': voucherNumber,
      if (remarks != null) 'remarks': remarks,
      if (verifiedBy1 != null) 'verified_by1': verifiedBy1,
      if (verifiedBy2 != null) 'verified_by2': verifiedBy2,
      if (verifiedBy3 != null) 'verified_by3': verifiedBy3,
      if (verification != null) 'verification': verification,
      if (recipientSignature != null) 'recipient_signature': recipientSignature,
      if (accountantSignature != null)
        'accountant_signature': accountantSignature,
      if (username != null) 'username': username,
    });
  }

  ZakaatDisbursementsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? beneficiaryId,
      Value<DateTime>? disbursementDate,
      Value<String>? disbursementType,
      Value<String>? recipientName,
      Value<String?>? recipientAddress,
      Value<String?>? aadhaarNumber,
      Value<String?>? phoneNumber,
      Value<double>? amount,
      Value<String?>? amountInWords,
      Value<String?>? reason,
      Value<String?>? issuingAuthorityReport,
      Value<String?>? chequeNumber,
      Value<String>? paymentMode,
      Value<String?>? voucherNumber,
      Value<String?>? remarks,
      Value<String?>? verifiedBy1,
      Value<String?>? verifiedBy2,
      Value<String?>? verifiedBy3,
      Value<String?>? verification,
      Value<Uint8List?>? recipientSignature,
      Value<Uint8List?>? accountantSignature,
      Value<String>? username}) {
    return ZakaatDisbursementsCompanion(
      id: id ?? this.id,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      disbursementDate: disbursementDate ?? this.disbursementDate,
      disbursementType: disbursementType ?? this.disbursementType,
      recipientName: recipientName ?? this.recipientName,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      amount: amount ?? this.amount,
      amountInWords: amountInWords ?? this.amountInWords,
      reason: reason ?? this.reason,
      issuingAuthorityReport:
          issuingAuthorityReport ?? this.issuingAuthorityReport,
      chequeNumber: chequeNumber ?? this.chequeNumber,
      paymentMode: paymentMode ?? this.paymentMode,
      voucherNumber: voucherNumber ?? this.voucherNumber,
      remarks: remarks ?? this.remarks,
      verifiedBy1: verifiedBy1 ?? this.verifiedBy1,
      verifiedBy2: verifiedBy2 ?? this.verifiedBy2,
      verifiedBy3: verifiedBy3 ?? this.verifiedBy3,
      verification: verification ?? this.verification,
      recipientSignature: recipientSignature ?? this.recipientSignature,
      accountantSignature: accountantSignature ?? this.accountantSignature,
      username: username ?? this.username,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (beneficiaryId.present) {
      map['beneficiary_id'] = Variable<int>(beneficiaryId.value);
    }
    if (disbursementDate.present) {
      map['disbursement_date'] = Variable<DateTime>(disbursementDate.value);
    }
    if (disbursementType.present) {
      map['disbursement_type'] = Variable<String>(disbursementType.value);
    }
    if (recipientName.present) {
      map['recipient_name'] = Variable<String>(recipientName.value);
    }
    if (recipientAddress.present) {
      map['recipient_address'] = Variable<String>(recipientAddress.value);
    }
    if (aadhaarNumber.present) {
      map['aadhaar_number'] = Variable<String>(aadhaarNumber.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (amountInWords.present) {
      map['amount_in_words'] = Variable<String>(amountInWords.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (issuingAuthorityReport.present) {
      map['issuing_authority_report'] =
          Variable<String>(issuingAuthorityReport.value);
    }
    if (chequeNumber.present) {
      map['cheque_number'] = Variable<String>(chequeNumber.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (voucherNumber.present) {
      map['voucher_number'] = Variable<String>(voucherNumber.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (verifiedBy1.present) {
      map['verified_by1'] = Variable<String>(verifiedBy1.value);
    }
    if (verifiedBy2.present) {
      map['verified_by2'] = Variable<String>(verifiedBy2.value);
    }
    if (verifiedBy3.present) {
      map['verified_by3'] = Variable<String>(verifiedBy3.value);
    }
    if (verification.present) {
      map['verification'] = Variable<String>(verification.value);
    }
    if (recipientSignature.present) {
      map['recipient_signature'] =
          Variable<Uint8List>(recipientSignature.value);
    }
    if (accountantSignature.present) {
      map['accountant_signature'] =
          Variable<Uint8List>(accountantSignature.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZakaatDisbursementsCompanion(')
          ..write('id: $id, ')
          ..write('beneficiaryId: $beneficiaryId, ')
          ..write('disbursementDate: $disbursementDate, ')
          ..write('disbursementType: $disbursementType, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientAddress: $recipientAddress, ')
          ..write('aadhaarNumber: $aadhaarNumber, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('amount: $amount, ')
          ..write('amountInWords: $amountInWords, ')
          ..write('reason: $reason, ')
          ..write('issuingAuthorityReport: $issuingAuthorityReport, ')
          ..write('chequeNumber: $chequeNumber, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('voucherNumber: $voucherNumber, ')
          ..write('remarks: $remarks, ')
          ..write('verifiedBy1: $verifiedBy1, ')
          ..write('verifiedBy2: $verifiedBy2, ')
          ..write('verifiedBy3: $verifiedBy3, ')
          ..write('verification: $verification, ')
          ..write('recipientSignature: $recipientSignature, ')
          ..write('accountantSignature: $accountantSignature, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }
}

class $FundAdjustmentsTable extends FundAdjustments
    with TableInfo<$FundAdjustmentsTable, FundAdjustment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FundAdjustmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _adjustmentTypeMeta =
      const VerificationMeta('adjustmentType');
  @override
  late final GeneratedColumn<String> adjustmentType = GeneratedColumn<String>(
      'adjustment_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentModeMeta =
      const VerificationMeta('paymentMode');
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
      'payment_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chequeNumberMeta =
      const VerificationMeta('chequeNumber');
  @override
  late final GeneratedColumn<String> chequeNumber = GeneratedColumn<String>(
      'cheque_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _documentNumberMeta =
      const VerificationMeta('documentNumber');
  @override
  late final GeneratedColumn<String> documentNumber = GeneratedColumn<String>(
      'document_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _partyNameMeta =
      const VerificationMeta('partyName');
  @override
  late final GeneratedColumn<String> partyName = GeneratedColumn<String>(
      'party_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aadhaarNumberMeta =
      const VerificationMeta('aadhaarNumber');
  @override
  late final GeneratedColumn<String> aadhaarNumber = GeneratedColumn<String>(
      'aadhaar_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remarksMeta =
      const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
      'remarks', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verifiedBy1Meta =
      const VerificationMeta('verifiedBy1');
  @override
  late final GeneratedColumn<String> verifiedBy1 = GeneratedColumn<String>(
      'verified_by1', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verifiedBy2Meta =
      const VerificationMeta('verifiedBy2');
  @override
  late final GeneratedColumn<String> verifiedBy2 = GeneratedColumn<String>(
      'verified_by2', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verifiedBy3Meta =
      const VerificationMeta('verifiedBy3');
  @override
  late final GeneratedColumn<String> verifiedBy3 = GeneratedColumn<String>(
      'verified_by3', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _verificationMeta =
      const VerificationMeta('verification');
  @override
  late final GeneratedColumn<String> verification = GeneratedColumn<String>(
      'verification', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recipientSignatureMeta =
      const VerificationMeta('recipientSignature');
  @override
  late final GeneratedColumn<Uint8List> recipientSignature =
      GeneratedColumn<Uint8List>('recipient_signature', aliasedName, true,
          type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _accountantSignatureMeta =
      const VerificationMeta('accountantSignature');
  @override
  late final GeneratedColumn<Uint8List> accountantSignature =
      GeneratedColumn<Uint8List>('accountant_signature', aliasedName, true,
          type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Legacy'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transactionDate,
        adjustmentType,
        amount,
        paymentMode,
        chequeNumber,
        documentNumber,
        partyName,
        address,
        aadhaarNumber,
        phoneNumber,
        remarks,
        verifiedBy1,
        verifiedBy2,
        verifiedBy3,
        verification,
        recipientSignature,
        accountantSignature,
        username
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fund_adjustments';
  @override
  VerificationContext validateIntegrity(Insertable<FundAdjustment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    }
    if (data.containsKey('adjustment_type')) {
      context.handle(
          _adjustmentTypeMeta,
          adjustmentType.isAcceptableOrUnknown(
              data['adjustment_type']!, _adjustmentTypeMeta));
    } else if (isInserting) {
      context.missing(_adjustmentTypeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
          _paymentModeMeta,
          paymentMode.isAcceptableOrUnknown(
              data['payment_mode']!, _paymentModeMeta));
    } else if (isInserting) {
      context.missing(_paymentModeMeta);
    }
    if (data.containsKey('cheque_number')) {
      context.handle(
          _chequeNumberMeta,
          chequeNumber.isAcceptableOrUnknown(
              data['cheque_number']!, _chequeNumberMeta));
    }
    if (data.containsKey('document_number')) {
      context.handle(
          _documentNumberMeta,
          documentNumber.isAcceptableOrUnknown(
              data['document_number']!, _documentNumberMeta));
    }
    if (data.containsKey('party_name')) {
      context.handle(_partyNameMeta,
          partyName.isAcceptableOrUnknown(data['party_name']!, _partyNameMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('aadhaar_number')) {
      context.handle(
          _aadhaarNumberMeta,
          aadhaarNumber.isAcceptableOrUnknown(
              data['aadhaar_number']!, _aadhaarNumberMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('verified_by1')) {
      context.handle(
          _verifiedBy1Meta,
          verifiedBy1.isAcceptableOrUnknown(
              data['verified_by1']!, _verifiedBy1Meta));
    }
    if (data.containsKey('verified_by2')) {
      context.handle(
          _verifiedBy2Meta,
          verifiedBy2.isAcceptableOrUnknown(
              data['verified_by2']!, _verifiedBy2Meta));
    }
    if (data.containsKey('verified_by3')) {
      context.handle(
          _verifiedBy3Meta,
          verifiedBy3.isAcceptableOrUnknown(
              data['verified_by3']!, _verifiedBy3Meta));
    }
    if (data.containsKey('verification')) {
      context.handle(
          _verificationMeta,
          verification.isAcceptableOrUnknown(
              data['verification']!, _verificationMeta));
    }
    if (data.containsKey('recipient_signature')) {
      context.handle(
          _recipientSignatureMeta,
          recipientSignature.isAcceptableOrUnknown(
              data['recipient_signature']!, _recipientSignatureMeta));
    }
    if (data.containsKey('accountant_signature')) {
      context.handle(
          _accountantSignatureMeta,
          accountantSignature.isAcceptableOrUnknown(
              data['accountant_signature']!, _accountantSignatureMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FundAdjustment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FundAdjustment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      adjustmentType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}adjustment_type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      chequeNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cheque_number']),
      documentNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_number']),
      partyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}party_name']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      aadhaarNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}aadhaar_number']),
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      remarks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remarks']),
      verifiedBy1: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verified_by1']),
      verifiedBy2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verified_by2']),
      verifiedBy3: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verified_by3']),
      verification: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verification']),
      recipientSignature: attachedDatabase.typeMapping.read(
          DriftSqlType.blob, data['${effectivePrefix}recipient_signature']),
      accountantSignature: attachedDatabase.typeMapping.read(
          DriftSqlType.blob, data['${effectivePrefix}accountant_signature']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
    );
  }

  @override
  $FundAdjustmentsTable createAlias(String alias) {
    return $FundAdjustmentsTable(attachedDatabase, alias);
  }
}

class FundAdjustment extends DataClass implements Insertable<FundAdjustment> {
  final int id;
  final DateTime transactionDate;
  final String adjustmentType;
  final double amount;
  final String paymentMode;
  final String? chequeNumber;
  final String? documentNumber;
  final String? partyName;
  final String? address;
  final String? aadhaarNumber;
  final String? phoneNumber;
  final String? remarks;
  final String? verifiedBy1;
  final String? verifiedBy2;
  final String? verifiedBy3;
  final String? verification;
  final Uint8List? recipientSignature;
  final Uint8List? accountantSignature;
  final String username;
  const FundAdjustment(
      {required this.id,
      required this.transactionDate,
      required this.adjustmentType,
      required this.amount,
      required this.paymentMode,
      this.chequeNumber,
      this.documentNumber,
      this.partyName,
      this.address,
      this.aadhaarNumber,
      this.phoneNumber,
      this.remarks,
      this.verifiedBy1,
      this.verifiedBy2,
      this.verifiedBy3,
      this.verification,
      this.recipientSignature,
      this.accountantSignature,
      required this.username});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['adjustment_type'] = Variable<String>(adjustmentType);
    map['amount'] = Variable<double>(amount);
    map['payment_mode'] = Variable<String>(paymentMode);
    if (!nullToAbsent || chequeNumber != null) {
      map['cheque_number'] = Variable<String>(chequeNumber);
    }
    if (!nullToAbsent || documentNumber != null) {
      map['document_number'] = Variable<String>(documentNumber);
    }
    if (!nullToAbsent || partyName != null) {
      map['party_name'] = Variable<String>(partyName);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || aadhaarNumber != null) {
      map['aadhaar_number'] = Variable<String>(aadhaarNumber);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    if (!nullToAbsent || verifiedBy1 != null) {
      map['verified_by1'] = Variable<String>(verifiedBy1);
    }
    if (!nullToAbsent || verifiedBy2 != null) {
      map['verified_by2'] = Variable<String>(verifiedBy2);
    }
    if (!nullToAbsent || verifiedBy3 != null) {
      map['verified_by3'] = Variable<String>(verifiedBy3);
    }
    if (!nullToAbsent || verification != null) {
      map['verification'] = Variable<String>(verification);
    }
    if (!nullToAbsent || recipientSignature != null) {
      map['recipient_signature'] = Variable<Uint8List>(recipientSignature);
    }
    if (!nullToAbsent || accountantSignature != null) {
      map['accountant_signature'] = Variable<Uint8List>(accountantSignature);
    }
    map['username'] = Variable<String>(username);
    return map;
  }

  FundAdjustmentsCompanion toCompanion(bool nullToAbsent) {
    return FundAdjustmentsCompanion(
      id: Value(id),
      transactionDate: Value(transactionDate),
      adjustmentType: Value(adjustmentType),
      amount: Value(amount),
      paymentMode: Value(paymentMode),
      chequeNumber: chequeNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(chequeNumber),
      documentNumber: documentNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(documentNumber),
      partyName: partyName == null && nullToAbsent
          ? const Value.absent()
          : Value(partyName),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      aadhaarNumber: aadhaarNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(aadhaarNumber),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      verifiedBy1: verifiedBy1 == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedBy1),
      verifiedBy2: verifiedBy2 == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedBy2),
      verifiedBy3: verifiedBy3 == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedBy3),
      verification: verification == null && nullToAbsent
          ? const Value.absent()
          : Value(verification),
      recipientSignature: recipientSignature == null && nullToAbsent
          ? const Value.absent()
          : Value(recipientSignature),
      accountantSignature: accountantSignature == null && nullToAbsent
          ? const Value.absent()
          : Value(accountantSignature),
      username: Value(username),
    );
  }

  factory FundAdjustment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FundAdjustment(
      id: serializer.fromJson<int>(json['id']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      adjustmentType: serializer.fromJson<String>(json['adjustmentType']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      chequeNumber: serializer.fromJson<String?>(json['chequeNumber']),
      documentNumber: serializer.fromJson<String?>(json['documentNumber']),
      partyName: serializer.fromJson<String?>(json['partyName']),
      address: serializer.fromJson<String?>(json['address']),
      aadhaarNumber: serializer.fromJson<String?>(json['aadhaarNumber']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      verifiedBy1: serializer.fromJson<String?>(json['verifiedBy1']),
      verifiedBy2: serializer.fromJson<String?>(json['verifiedBy2']),
      verifiedBy3: serializer.fromJson<String?>(json['verifiedBy3']),
      verification: serializer.fromJson<String?>(json['verification']),
      recipientSignature:
          serializer.fromJson<Uint8List?>(json['recipientSignature']),
      accountantSignature:
          serializer.fromJson<Uint8List?>(json['accountantSignature']),
      username: serializer.fromJson<String>(json['username']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'adjustmentType': serializer.toJson<String>(adjustmentType),
      'amount': serializer.toJson<double>(amount),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'chequeNumber': serializer.toJson<String?>(chequeNumber),
      'documentNumber': serializer.toJson<String?>(documentNumber),
      'partyName': serializer.toJson<String?>(partyName),
      'address': serializer.toJson<String?>(address),
      'aadhaarNumber': serializer.toJson<String?>(aadhaarNumber),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'remarks': serializer.toJson<String?>(remarks),
      'verifiedBy1': serializer.toJson<String?>(verifiedBy1),
      'verifiedBy2': serializer.toJson<String?>(verifiedBy2),
      'verifiedBy3': serializer.toJson<String?>(verifiedBy3),
      'verification': serializer.toJson<String?>(verification),
      'recipientSignature': serializer.toJson<Uint8List?>(recipientSignature),
      'accountantSignature': serializer.toJson<Uint8List?>(accountantSignature),
      'username': serializer.toJson<String>(username),
    };
  }

  FundAdjustment copyWith(
          {int? id,
          DateTime? transactionDate,
          String? adjustmentType,
          double? amount,
          String? paymentMode,
          Value<String?> chequeNumber = const Value.absent(),
          Value<String?> documentNumber = const Value.absent(),
          Value<String?> partyName = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> aadhaarNumber = const Value.absent(),
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> remarks = const Value.absent(),
          Value<String?> verifiedBy1 = const Value.absent(),
          Value<String?> verifiedBy2 = const Value.absent(),
          Value<String?> verifiedBy3 = const Value.absent(),
          Value<String?> verification = const Value.absent(),
          Value<Uint8List?> recipientSignature = const Value.absent(),
          Value<Uint8List?> accountantSignature = const Value.absent(),
          String? username}) =>
      FundAdjustment(
        id: id ?? this.id,
        transactionDate: transactionDate ?? this.transactionDate,
        adjustmentType: adjustmentType ?? this.adjustmentType,
        amount: amount ?? this.amount,
        paymentMode: paymentMode ?? this.paymentMode,
        chequeNumber:
            chequeNumber.present ? chequeNumber.value : this.chequeNumber,
        documentNumber:
            documentNumber.present ? documentNumber.value : this.documentNumber,
        partyName: partyName.present ? partyName.value : this.partyName,
        address: address.present ? address.value : this.address,
        aadhaarNumber:
            aadhaarNumber.present ? aadhaarNumber.value : this.aadhaarNumber,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        remarks: remarks.present ? remarks.value : this.remarks,
        verifiedBy1: verifiedBy1.present ? verifiedBy1.value : this.verifiedBy1,
        verifiedBy2: verifiedBy2.present ? verifiedBy2.value : this.verifiedBy2,
        verifiedBy3: verifiedBy3.present ? verifiedBy3.value : this.verifiedBy3,
        verification:
            verification.present ? verification.value : this.verification,
        recipientSignature: recipientSignature.present
            ? recipientSignature.value
            : this.recipientSignature,
        accountantSignature: accountantSignature.present
            ? accountantSignature.value
            : this.accountantSignature,
        username: username ?? this.username,
      );
  FundAdjustment copyWithCompanion(FundAdjustmentsCompanion data) {
    return FundAdjustment(
      id: data.id.present ? data.id.value : this.id,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      adjustmentType: data.adjustmentType.present
          ? data.adjustmentType.value
          : this.adjustmentType,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      chequeNumber: data.chequeNumber.present
          ? data.chequeNumber.value
          : this.chequeNumber,
      documentNumber: data.documentNumber.present
          ? data.documentNumber.value
          : this.documentNumber,
      partyName: data.partyName.present ? data.partyName.value : this.partyName,
      address: data.address.present ? data.address.value : this.address,
      aadhaarNumber: data.aadhaarNumber.present
          ? data.aadhaarNumber.value
          : this.aadhaarNumber,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      verifiedBy1:
          data.verifiedBy1.present ? data.verifiedBy1.value : this.verifiedBy1,
      verifiedBy2:
          data.verifiedBy2.present ? data.verifiedBy2.value : this.verifiedBy2,
      verifiedBy3:
          data.verifiedBy3.present ? data.verifiedBy3.value : this.verifiedBy3,
      verification: data.verification.present
          ? data.verification.value
          : this.verification,
      recipientSignature: data.recipientSignature.present
          ? data.recipientSignature.value
          : this.recipientSignature,
      accountantSignature: data.accountantSignature.present
          ? data.accountantSignature.value
          : this.accountantSignature,
      username: data.username.present ? data.username.value : this.username,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FundAdjustment(')
          ..write('id: $id, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('adjustmentType: $adjustmentType, ')
          ..write('amount: $amount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('chequeNumber: $chequeNumber, ')
          ..write('documentNumber: $documentNumber, ')
          ..write('partyName: $partyName, ')
          ..write('address: $address, ')
          ..write('aadhaarNumber: $aadhaarNumber, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('remarks: $remarks, ')
          ..write('verifiedBy1: $verifiedBy1, ')
          ..write('verifiedBy2: $verifiedBy2, ')
          ..write('verifiedBy3: $verifiedBy3, ')
          ..write('verification: $verification, ')
          ..write('recipientSignature: $recipientSignature, ')
          ..write('accountantSignature: $accountantSignature, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      transactionDate,
      adjustmentType,
      amount,
      paymentMode,
      chequeNumber,
      documentNumber,
      partyName,
      address,
      aadhaarNumber,
      phoneNumber,
      remarks,
      verifiedBy1,
      verifiedBy2,
      verifiedBy3,
      verification,
      $driftBlobEquality.hash(recipientSignature),
      $driftBlobEquality.hash(accountantSignature),
      username);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FundAdjustment &&
          other.id == this.id &&
          other.transactionDate == this.transactionDate &&
          other.adjustmentType == this.adjustmentType &&
          other.amount == this.amount &&
          other.paymentMode == this.paymentMode &&
          other.chequeNumber == this.chequeNumber &&
          other.documentNumber == this.documentNumber &&
          other.partyName == this.partyName &&
          other.address == this.address &&
          other.aadhaarNumber == this.aadhaarNumber &&
          other.phoneNumber == this.phoneNumber &&
          other.remarks == this.remarks &&
          other.verifiedBy1 == this.verifiedBy1 &&
          other.verifiedBy2 == this.verifiedBy2 &&
          other.verifiedBy3 == this.verifiedBy3 &&
          other.verification == this.verification &&
          $driftBlobEquality.equals(
              other.recipientSignature, this.recipientSignature) &&
          $driftBlobEquality.equals(
              other.accountantSignature, this.accountantSignature) &&
          other.username == this.username);
}

class FundAdjustmentsCompanion extends UpdateCompanion<FundAdjustment> {
  final Value<int> id;
  final Value<DateTime> transactionDate;
  final Value<String> adjustmentType;
  final Value<double> amount;
  final Value<String> paymentMode;
  final Value<String?> chequeNumber;
  final Value<String?> documentNumber;
  final Value<String?> partyName;
  final Value<String?> address;
  final Value<String?> aadhaarNumber;
  final Value<String?> phoneNumber;
  final Value<String?> remarks;
  final Value<String?> verifiedBy1;
  final Value<String?> verifiedBy2;
  final Value<String?> verifiedBy3;
  final Value<String?> verification;
  final Value<Uint8List?> recipientSignature;
  final Value<Uint8List?> accountantSignature;
  final Value<String> username;
  const FundAdjustmentsCompanion({
    this.id = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.adjustmentType = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.chequeNumber = const Value.absent(),
    this.documentNumber = const Value.absent(),
    this.partyName = const Value.absent(),
    this.address = const Value.absent(),
    this.aadhaarNumber = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.remarks = const Value.absent(),
    this.verifiedBy1 = const Value.absent(),
    this.verifiedBy2 = const Value.absent(),
    this.verifiedBy3 = const Value.absent(),
    this.verification = const Value.absent(),
    this.recipientSignature = const Value.absent(),
    this.accountantSignature = const Value.absent(),
    this.username = const Value.absent(),
  });
  FundAdjustmentsCompanion.insert({
    this.id = const Value.absent(),
    this.transactionDate = const Value.absent(),
    required String adjustmentType,
    required double amount,
    required String paymentMode,
    this.chequeNumber = const Value.absent(),
    this.documentNumber = const Value.absent(),
    this.partyName = const Value.absent(),
    this.address = const Value.absent(),
    this.aadhaarNumber = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.remarks = const Value.absent(),
    this.verifiedBy1 = const Value.absent(),
    this.verifiedBy2 = const Value.absent(),
    this.verifiedBy3 = const Value.absent(),
    this.verification = const Value.absent(),
    this.recipientSignature = const Value.absent(),
    this.accountantSignature = const Value.absent(),
    this.username = const Value.absent(),
  })  : adjustmentType = Value(adjustmentType),
        amount = Value(amount),
        paymentMode = Value(paymentMode);
  static Insertable<FundAdjustment> custom({
    Expression<int>? id,
    Expression<DateTime>? transactionDate,
    Expression<String>? adjustmentType,
    Expression<double>? amount,
    Expression<String>? paymentMode,
    Expression<String>? chequeNumber,
    Expression<String>? documentNumber,
    Expression<String>? partyName,
    Expression<String>? address,
    Expression<String>? aadhaarNumber,
    Expression<String>? phoneNumber,
    Expression<String>? remarks,
    Expression<String>? verifiedBy1,
    Expression<String>? verifiedBy2,
    Expression<String>? verifiedBy3,
    Expression<String>? verification,
    Expression<Uint8List>? recipientSignature,
    Expression<Uint8List>? accountantSignature,
    Expression<String>? username,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (adjustmentType != null) 'adjustment_type': adjustmentType,
      if (amount != null) 'amount': amount,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (chequeNumber != null) 'cheque_number': chequeNumber,
      if (documentNumber != null) 'document_number': documentNumber,
      if (partyName != null) 'party_name': partyName,
      if (address != null) 'address': address,
      if (aadhaarNumber != null) 'aadhaar_number': aadhaarNumber,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (remarks != null) 'remarks': remarks,
      if (verifiedBy1 != null) 'verified_by1': verifiedBy1,
      if (verifiedBy2 != null) 'verified_by2': verifiedBy2,
      if (verifiedBy3 != null) 'verified_by3': verifiedBy3,
      if (verification != null) 'verification': verification,
      if (recipientSignature != null) 'recipient_signature': recipientSignature,
      if (accountantSignature != null)
        'accountant_signature': accountantSignature,
      if (username != null) 'username': username,
    });
  }

  FundAdjustmentsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? transactionDate,
      Value<String>? adjustmentType,
      Value<double>? amount,
      Value<String>? paymentMode,
      Value<String?>? chequeNumber,
      Value<String?>? documentNumber,
      Value<String?>? partyName,
      Value<String?>? address,
      Value<String?>? aadhaarNumber,
      Value<String?>? phoneNumber,
      Value<String?>? remarks,
      Value<String?>? verifiedBy1,
      Value<String?>? verifiedBy2,
      Value<String?>? verifiedBy3,
      Value<String?>? verification,
      Value<Uint8List?>? recipientSignature,
      Value<Uint8List?>? accountantSignature,
      Value<String>? username}) {
    return FundAdjustmentsCompanion(
      id: id ?? this.id,
      transactionDate: transactionDate ?? this.transactionDate,
      adjustmentType: adjustmentType ?? this.adjustmentType,
      amount: amount ?? this.amount,
      paymentMode: paymentMode ?? this.paymentMode,
      chequeNumber: chequeNumber ?? this.chequeNumber,
      documentNumber: documentNumber ?? this.documentNumber,
      partyName: partyName ?? this.partyName,
      address: address ?? this.address,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      remarks: remarks ?? this.remarks,
      verifiedBy1: verifiedBy1 ?? this.verifiedBy1,
      verifiedBy2: verifiedBy2 ?? this.verifiedBy2,
      verifiedBy3: verifiedBy3 ?? this.verifiedBy3,
      verification: verification ?? this.verification,
      recipientSignature: recipientSignature ?? this.recipientSignature,
      accountantSignature: accountantSignature ?? this.accountantSignature,
      username: username ?? this.username,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (adjustmentType.present) {
      map['adjustment_type'] = Variable<String>(adjustmentType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (chequeNumber.present) {
      map['cheque_number'] = Variable<String>(chequeNumber.value);
    }
    if (documentNumber.present) {
      map['document_number'] = Variable<String>(documentNumber.value);
    }
    if (partyName.present) {
      map['party_name'] = Variable<String>(partyName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (aadhaarNumber.present) {
      map['aadhaar_number'] = Variable<String>(aadhaarNumber.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (verifiedBy1.present) {
      map['verified_by1'] = Variable<String>(verifiedBy1.value);
    }
    if (verifiedBy2.present) {
      map['verified_by2'] = Variable<String>(verifiedBy2.value);
    }
    if (verifiedBy3.present) {
      map['verified_by3'] = Variable<String>(verifiedBy3.value);
    }
    if (verification.present) {
      map['verification'] = Variable<String>(verification.value);
    }
    if (recipientSignature.present) {
      map['recipient_signature'] =
          Variable<Uint8List>(recipientSignature.value);
    }
    if (accountantSignature.present) {
      map['accountant_signature'] =
          Variable<Uint8List>(accountantSignature.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FundAdjustmentsCompanion(')
          ..write('id: $id, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('adjustmentType: $adjustmentType, ')
          ..write('amount: $amount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('chequeNumber: $chequeNumber, ')
          ..write('documentNumber: $documentNumber, ')
          ..write('partyName: $partyName, ')
          ..write('address: $address, ')
          ..write('aadhaarNumber: $aadhaarNumber, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('remarks: $remarks, ')
          ..write('verifiedBy1: $verifiedBy1, ')
          ..write('verifiedBy2: $verifiedBy2, ')
          ..write('verifiedBy3: $verifiedBy3, ')
          ..write('verification: $verification, ')
          ..write('recipientSignature: $recipientSignature, ')
          ..write('accountantSignature: $accountantSignature, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HouseholdsTable households = $HouseholdsTable(this);
  late final $HouseholdChargeHistoriesTable householdChargeHistories =
      $HouseholdChargeHistoriesTable(this);
  late final $HouseholdMonthsTable householdMonths =
      $HouseholdMonthsTable(this);
  late final $HouseholdPaymentsTable householdPayments =
      $HouseholdPaymentsTable(this);
  late final $PaymentAllocationsTable paymentAllocations =
      $PaymentAllocationsTable(this);
  late final $HouseholdStatusHistoriesTable householdStatusHistories =
      $HouseholdStatusHistoriesTable(this);
  late final $HouseholdConcessionsTable householdConcessions =
      $HouseholdConcessionsTable(this);
  late final $HouseholdConcessionAllocationsTable
      householdConcessionAllocations =
      $HouseholdConcessionAllocationsTable(this);
  late final $OpeningBalancePaymentAllocationsTable
      openingBalancePaymentAllocations =
      $OpeningBalancePaymentAllocationsTable(this);
  late final $OpeningBalanceConcessionAllocationsTable
      openingBalanceConcessionAllocations =
      $OpeningBalanceConcessionAllocationsTable(this);
  late final $FinancialTransactionsTable financialTransactions =
      $FinancialTransactionsTable(this);
  late final $ManualBalancesTable manualBalances = $ManualBalancesTable(this);
  late final $ZakaatBeneficiariesTable zakaatBeneficiaries =
      $ZakaatBeneficiariesTable(this);
  late final $ZakaatDisbursementsTable zakaatDisbursements =
      $ZakaatDisbursementsTable(this);
  late final $FundAdjustmentsTable fundAdjustments =
      $FundAdjustmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        households,
        householdChargeHistories,
        householdMonths,
        householdPayments,
        paymentAllocations,
        householdStatusHistories,
        householdConcessions,
        householdConcessionAllocations,
        openingBalancePaymentAllocations,
        openingBalanceConcessionAllocations,
        financialTransactions,
        manualBalances,
        zakaatBeneficiaries,
        zakaatDisbursements,
        fundAdjustments
      ];
}

typedef $$HouseholdsTableCreateCompanionBuilder = HouseholdsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> parentage,
  Value<String?> address,
  Value<String?> whatsapp,
  Value<double> monthlyCharge,
  Value<DateTime> joinedDate,
  Value<double> openingBalance,
  Value<String> openingBalanceType,
  Value<bool> isActive,
});
typedef $$HouseholdsTableUpdateCompanionBuilder = HouseholdsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> parentage,
  Value<String?> address,
  Value<String?> whatsapp,
  Value<double> monthlyCharge,
  Value<DateTime> joinedDate,
  Value<double> openingBalance,
  Value<String> openingBalanceType,
  Value<bool> isActive,
});

final class $$HouseholdsTableReferences
    extends BaseReferences<_$AppDatabase, $HouseholdsTable, Household> {
  $$HouseholdsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HouseholdChargeHistoriesTable,
      List<HouseholdChargeHistory>> _householdChargeHistoriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.householdChargeHistories,
          aliasName:
              'households__id__household_charge_histories__household_id');

  $$HouseholdChargeHistoriesTableProcessedTableManager
      get householdChargeHistoriesRefs {
    final manager = $$HouseholdChargeHistoriesTableTableManager(
            $_db, $_db.householdChargeHistories)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_householdChargeHistoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HouseholdMonthsTable, List<HouseholdMonth>>
      _householdMonthsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.householdMonths,
              aliasName: 'households__id__household_months__household_id');

  $$HouseholdMonthsTableProcessedTableManager get householdMonthsRefs {
    final manager = $$HouseholdMonthsTableTableManager(
            $_db, $_db.householdMonths)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_householdMonthsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HouseholdPaymentsTable, List<HouseholdPayment>>
      _householdPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.householdPayments,
              aliasName: 'households__id__household_payments__household_id');

  $$HouseholdPaymentsTableProcessedTableManager get householdPaymentsRefs {
    final manager = $$HouseholdPaymentsTableTableManager(
            $_db, $_db.householdPayments)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_householdPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HouseholdStatusHistoriesTable,
      List<HouseholdStatusHistory>> _householdStatusHistoriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.householdStatusHistories,
          aliasName:
              'households__id__household_status_histories__household_id');

  $$HouseholdStatusHistoriesTableProcessedTableManager
      get householdStatusHistoriesRefs {
    final manager = $$HouseholdStatusHistoriesTableTableManager(
            $_db, $_db.householdStatusHistories)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_householdStatusHistoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HouseholdConcessionsTable,
      List<HouseholdConcession>> _householdConcessionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.householdConcessions,
          aliasName: 'households__id__household_concessions__household_id');

  $$HouseholdConcessionsTableProcessedTableManager
      get householdConcessionsRefs {
    final manager = $$HouseholdConcessionsTableTableManager(
            $_db, $_db.householdConcessions)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_householdConcessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OpeningBalancePaymentAllocationsTable,
          List<OpeningBalancePaymentAllocation>>
      _openingBalancePaymentAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.openingBalancePaymentAllocations,
              aliasName:
                  'households__id__opening_balance_payment_allocations__household_id');

  $$OpeningBalancePaymentAllocationsTableProcessedTableManager
      get openingBalancePaymentAllocationsRefs {
    final manager = $$OpeningBalancePaymentAllocationsTableTableManager(
            $_db, $_db.openingBalancePaymentAllocations)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_openingBalancePaymentAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OpeningBalanceConcessionAllocationsTable,
          List<OpeningBalanceConcessionAllocation>>
      _openingBalanceConcessionAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.openingBalanceConcessionAllocations,
              aliasName:
                  'households__id__opening_balance_concession_allocations__household_id');

  $$OpeningBalanceConcessionAllocationsTableProcessedTableManager
      get openingBalanceConcessionAllocationsRefs {
    final manager = $$OpeningBalanceConcessionAllocationsTableTableManager(
            $_db, $_db.openingBalanceConcessionAllocations)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_openingBalanceConcessionAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseholdsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentage => $composableBuilder(
      column: $table.parentage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whatsapp => $composableBuilder(
      column: $table.whatsapp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monthlyCharge => $composableBuilder(
      column: $table.monthlyCharge, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joinedDate => $composableBuilder(
      column: $table.joinedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get openingBalanceType => $composableBuilder(
      column: $table.openingBalanceType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> householdChargeHistoriesRefs(
      Expression<bool> Function($$HouseholdChargeHistoriesTableFilterComposer f)
          f) {
    final $$HouseholdChargeHistoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdChargeHistories,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdChargeHistoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.householdChargeHistories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> householdMonthsRefs(
      Expression<bool> Function($$HouseholdMonthsTableFilterComposer f) f) {
    final $$HouseholdMonthsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.householdMonths,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMonthsTableFilterComposer(
              $db: $db,
              $table: $db.householdMonths,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> householdPaymentsRefs(
      Expression<bool> Function($$HouseholdPaymentsTableFilterComposer f) f) {
    final $$HouseholdPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.householdPayments,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.householdPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> householdStatusHistoriesRefs(
      Expression<bool> Function($$HouseholdStatusHistoriesTableFilterComposer f)
          f) {
    final $$HouseholdStatusHistoriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdStatusHistories,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdStatusHistoriesTableFilterComposer(
                  $db: $db,
                  $table: $db.householdStatusHistories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> householdConcessionsRefs(
      Expression<bool> Function($$HouseholdConcessionsTableFilterComposer f)
          f) {
    final $$HouseholdConcessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.householdConcessions,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdConcessionsTableFilterComposer(
              $db: $db,
              $table: $db.householdConcessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> openingBalancePaymentAllocationsRefs(
      Expression<bool> Function(
              $$OpeningBalancePaymentAllocationsTableFilterComposer f)
          f) {
    final $$OpeningBalancePaymentAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.openingBalancePaymentAllocations,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OpeningBalancePaymentAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.openingBalancePaymentAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> openingBalanceConcessionAllocationsRefs(
      Expression<bool> Function(
              $$OpeningBalanceConcessionAllocationsTableFilterComposer f)
          f) {
    final $$OpeningBalanceConcessionAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.openingBalanceConcessionAllocations,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OpeningBalanceConcessionAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.openingBalanceConcessionAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentage => $composableBuilder(
      column: $table.parentage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whatsapp => $composableBuilder(
      column: $table.whatsapp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monthlyCharge => $composableBuilder(
      column: $table.monthlyCharge,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joinedDate => $composableBuilder(
      column: $table.joinedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get openingBalanceType => $composableBuilder(
      column: $table.openingBalanceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentage =>
      $composableBuilder(column: $table.parentage, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get whatsapp =>
      $composableBuilder(column: $table.whatsapp, builder: (column) => column);

  GeneratedColumn<double> get monthlyCharge => $composableBuilder(
      column: $table.monthlyCharge, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedDate => $composableBuilder(
      column: $table.joinedDate, builder: (column) => column);

  GeneratedColumn<double> get openingBalance => $composableBuilder(
      column: $table.openingBalance, builder: (column) => column);

  GeneratedColumn<String> get openingBalanceType => $composableBuilder(
      column: $table.openingBalanceType, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> householdChargeHistoriesRefs<T extends Object>(
      Expression<T> Function(
              $$HouseholdChargeHistoriesTableAnnotationComposer a)
          f) {
    final $$HouseholdChargeHistoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdChargeHistories,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdChargeHistoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdChargeHistories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> householdMonthsRefs<T extends Object>(
      Expression<T> Function($$HouseholdMonthsTableAnnotationComposer a) f) {
    final $$HouseholdMonthsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.householdMonths,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMonthsTableAnnotationComposer(
              $db: $db,
              $table: $db.householdMonths,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> householdPaymentsRefs<T extends Object>(
      Expression<T> Function($$HouseholdPaymentsTableAnnotationComposer a) f) {
    final $$HouseholdPaymentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdPayments,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdPaymentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdPayments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> householdStatusHistoriesRefs<T extends Object>(
      Expression<T> Function(
              $$HouseholdStatusHistoriesTableAnnotationComposer a)
          f) {
    final $$HouseholdStatusHistoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdStatusHistories,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdStatusHistoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdStatusHistories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> householdConcessionsRefs<T extends Object>(
      Expression<T> Function($$HouseholdConcessionsTableAnnotationComposer a)
          f) {
    final $$HouseholdConcessionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdConcessions,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdConcessionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdConcessions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> openingBalancePaymentAllocationsRefs<T extends Object>(
      Expression<T> Function(
              $$OpeningBalancePaymentAllocationsTableAnnotationComposer a)
          f) {
    final $$OpeningBalancePaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.openingBalancePaymentAllocations,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OpeningBalancePaymentAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.openingBalancePaymentAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> openingBalanceConcessionAllocationsRefs<T extends Object>(
      Expression<T> Function(
              $$OpeningBalanceConcessionAllocationsTableAnnotationComposer a)
          f) {
    final $$OpeningBalanceConcessionAllocationsTableAnnotationComposer
        composer = $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.openingBalanceConcessionAllocations,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OpeningBalanceConcessionAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.openingBalanceConcessionAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    Household,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (Household, $$HouseholdsTableReferences),
    Household,
    PrefetchHooks Function(
        {bool householdChargeHistoriesRefs,
        bool householdMonthsRefs,
        bool householdPaymentsRefs,
        bool householdStatusHistoriesRefs,
        bool householdConcessionsRefs,
        bool openingBalancePaymentAllocationsRefs,
        bool openingBalanceConcessionAllocationsRefs})> {
  $$HouseholdsTableTableManager(_$AppDatabase db, $HouseholdsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentage = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> whatsapp = const Value.absent(),
            Value<double> monthlyCharge = const Value.absent(),
            Value<DateTime> joinedDate = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<String> openingBalanceType = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              HouseholdsCompanion(
            id: id,
            name: name,
            parentage: parentage,
            address: address,
            whatsapp: whatsapp,
            monthlyCharge: monthlyCharge,
            joinedDate: joinedDate,
            openingBalance: openingBalance,
            openingBalanceType: openingBalanceType,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> parentage = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> whatsapp = const Value.absent(),
            Value<double> monthlyCharge = const Value.absent(),
            Value<DateTime> joinedDate = const Value.absent(),
            Value<double> openingBalance = const Value.absent(),
            Value<String> openingBalanceType = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              HouseholdsCompanion.insert(
            id: id,
            name: name,
            parentage: parentage,
            address: address,
            whatsapp: whatsapp,
            monthlyCharge: monthlyCharge,
            joinedDate: joinedDate,
            openingBalance: openingBalance,
            openingBalanceType: openingBalanceType,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseholdsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdChargeHistoriesRefs = false,
              householdMonthsRefs = false,
              householdPaymentsRefs = false,
              householdStatusHistoriesRefs = false,
              householdConcessionsRefs = false,
              openingBalancePaymentAllocationsRefs = false,
              openingBalanceConcessionAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (householdChargeHistoriesRefs) db.householdChargeHistories,
                if (householdMonthsRefs) db.householdMonths,
                if (householdPaymentsRefs) db.householdPayments,
                if (householdStatusHistoriesRefs) db.householdStatusHistories,
                if (householdConcessionsRefs) db.householdConcessions,
                if (openingBalancePaymentAllocationsRefs)
                  db.openingBalancePaymentAllocations,
                if (openingBalanceConcessionAllocationsRefs)
                  db.openingBalanceConcessionAllocations
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (householdChargeHistoriesRefs)
                    await $_getPrefetchedData<Household, $HouseholdsTable,
                            HouseholdChargeHistory>(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._householdChargeHistoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .householdChargeHistoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (householdMonthsRefs)
                    await $_getPrefetchedData<Household, $HouseholdsTable,
                            HouseholdMonth>(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._householdMonthsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .householdMonthsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (householdPaymentsRefs)
                    await $_getPrefetchedData<Household, $HouseholdsTable,
                            HouseholdPayment>(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._householdPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .householdPaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (householdStatusHistoriesRefs)
                    await $_getPrefetchedData<Household, $HouseholdsTable,
                            HouseholdStatusHistory>(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._householdStatusHistoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .householdStatusHistoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (householdConcessionsRefs)
                    await $_getPrefetchedData<Household, $HouseholdsTable,
                            HouseholdConcession>(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._householdConcessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .householdConcessionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (openingBalancePaymentAllocationsRefs)
                    await $_getPrefetchedData<Household, $HouseholdsTable,
                            OpeningBalancePaymentAllocation>(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._openingBalancePaymentAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .openingBalancePaymentAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (openingBalanceConcessionAllocationsRefs)
                    await $_getPrefetchedData<Household, $HouseholdsTable,
                            OpeningBalanceConcessionAllocation>(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._openingBalanceConcessionAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .openingBalanceConcessionAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseholdsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    Household,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (Household, $$HouseholdsTableReferences),
    Household,
    PrefetchHooks Function(
        {bool householdChargeHistoriesRefs,
        bool householdMonthsRefs,
        bool householdPaymentsRefs,
        bool householdStatusHistoriesRefs,
        bool householdConcessionsRefs,
        bool openingBalancePaymentAllocationsRefs,
        bool openingBalanceConcessionAllocationsRefs})>;
typedef $$HouseholdChargeHistoriesTableCreateCompanionBuilder
    = HouseholdChargeHistoriesCompanion Function({
  Value<int> id,
  required int householdId,
  required DateTime effectiveFrom,
  Value<DateTime?> effectiveTo,
  required double monthlyCharge,
});
typedef $$HouseholdChargeHistoriesTableUpdateCompanionBuilder
    = HouseholdChargeHistoriesCompanion Function({
  Value<int> id,
  Value<int> householdId,
  Value<DateTime> effectiveFrom,
  Value<DateTime?> effectiveTo,
  Value<double> monthlyCharge,
});

final class $$HouseholdChargeHistoriesTableReferences extends BaseReferences<
    _$AppDatabase, $HouseholdChargeHistoriesTable, HouseholdChargeHistory> {
  $$HouseholdChargeHistoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) => db.households
      .createAlias('household_charge_histories__household_id__households__id');

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<int>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HouseholdChargeHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdChargeHistoriesTable> {
  $$HouseholdChargeHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get effectiveTo => $composableBuilder(
      column: $table.effectiveTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monthlyCharge => $composableBuilder(
      column: $table.monthlyCharge, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdChargeHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdChargeHistoriesTable> {
  $$HouseholdChargeHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get effectiveTo => $composableBuilder(
      column: $table.effectiveTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monthlyCharge => $composableBuilder(
      column: $table.monthlyCharge,
      builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdChargeHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdChargeHistoriesTable> {
  $$HouseholdChargeHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveTo => $composableBuilder(
      column: $table.effectiveTo, builder: (column) => column);

  GeneratedColumn<double> get monthlyCharge => $composableBuilder(
      column: $table.monthlyCharge, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdChargeHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdChargeHistoriesTable,
    HouseholdChargeHistory,
    $$HouseholdChargeHistoriesTableFilterComposer,
    $$HouseholdChargeHistoriesTableOrderingComposer,
    $$HouseholdChargeHistoriesTableAnnotationComposer,
    $$HouseholdChargeHistoriesTableCreateCompanionBuilder,
    $$HouseholdChargeHistoriesTableUpdateCompanionBuilder,
    (HouseholdChargeHistory, $$HouseholdChargeHistoriesTableReferences),
    HouseholdChargeHistory,
    PrefetchHooks Function({bool householdId})> {
  $$HouseholdChargeHistoriesTableTableManager(
      _$AppDatabase db, $HouseholdChargeHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdChargeHistoriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdChargeHistoriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdChargeHistoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> householdId = const Value.absent(),
            Value<DateTime> effectiveFrom = const Value.absent(),
            Value<DateTime?> effectiveTo = const Value.absent(),
            Value<double> monthlyCharge = const Value.absent(),
          }) =>
              HouseholdChargeHistoriesCompanion(
            id: id,
            householdId: householdId,
            effectiveFrom: effectiveFrom,
            effectiveTo: effectiveTo,
            monthlyCharge: monthlyCharge,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int householdId,
            required DateTime effectiveFrom,
            Value<DateTime?> effectiveTo = const Value.absent(),
            required double monthlyCharge,
          }) =>
              HouseholdChargeHistoriesCompanion.insert(
            id: id,
            householdId: householdId,
            effectiveFrom: effectiveFrom,
            effectiveTo: effectiveTo,
            monthlyCharge: monthlyCharge,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseholdChargeHistoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({householdId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable: $$HouseholdChargeHistoriesTableReferences
                        ._householdIdTable(db),
                    referencedColumn: $$HouseholdChargeHistoriesTableReferences
                        ._householdIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HouseholdChargeHistoriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $HouseholdChargeHistoriesTable,
        HouseholdChargeHistory,
        $$HouseholdChargeHistoriesTableFilterComposer,
        $$HouseholdChargeHistoriesTableOrderingComposer,
        $$HouseholdChargeHistoriesTableAnnotationComposer,
        $$HouseholdChargeHistoriesTableCreateCompanionBuilder,
        $$HouseholdChargeHistoriesTableUpdateCompanionBuilder,
        (HouseholdChargeHistory, $$HouseholdChargeHistoriesTableReferences),
        HouseholdChargeHistory,
        PrefetchHooks Function({bool householdId})>;
typedef $$HouseholdMonthsTableCreateCompanionBuilder = HouseholdMonthsCompanion
    Function({
  Value<int> id,
  required int householdId,
  required int year,
  required int month,
  Value<double> charge,
  Value<double> concession,
});
typedef $$HouseholdMonthsTableUpdateCompanionBuilder = HouseholdMonthsCompanion
    Function({
  Value<int> id,
  Value<int> householdId,
  Value<int> year,
  Value<int> month,
  Value<double> charge,
  Value<double> concession,
});

final class $$HouseholdMonthsTableReferences extends BaseReferences<
    _$AppDatabase, $HouseholdMonthsTable, HouseholdMonth> {
  $$HouseholdMonthsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) => db.households
      .createAlias('household_months__household_id__households__id');

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<int>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PaymentAllocationsTable,
      List<PaymentAllocation>> _paymentAllocationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.paymentAllocations,
          aliasName:
              'household_months__id__payment_allocations__household_month_id');

  $$PaymentAllocationsTableProcessedTableManager get paymentAllocationsRefs {
    final manager = $$PaymentAllocationsTableTableManager(
            $_db, $_db.paymentAllocations)
        .filter(
            (f) => f.householdMonthId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_paymentAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$HouseholdConcessionAllocationsTable,
      List<HouseholdConcessionAllocation>> _householdConcessionAllocationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.householdConcessionAllocations,
          aliasName:
              'household_months__id__household_concession_allocations__household_month_id');

  $$HouseholdConcessionAllocationsTableProcessedTableManager
      get householdConcessionAllocationsRefs {
    final manager = $$HouseholdConcessionAllocationsTableTableManager(
            $_db, $_db.householdConcessionAllocations)
        .filter(
            (f) => f.householdMonthId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_householdConcessionAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseholdMonthsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdMonthsTable> {
  $$HouseholdMonthsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get charge => $composableBuilder(
      column: $table.charge, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get concession => $composableBuilder(
      column: $table.concession, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> paymentAllocationsRefs(
      Expression<bool> Function($$PaymentAllocationsTableFilterComposer f) f) {
    final $$PaymentAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.paymentAllocations,
        getReferencedColumn: (t) => t.householdMonthId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.paymentAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> householdConcessionAllocationsRefs(
      Expression<bool> Function(
              $$HouseholdConcessionAllocationsTableFilterComposer f)
          f) {
    final $$HouseholdConcessionAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdConcessionAllocations,
            getReferencedColumn: (t) => t.householdMonthId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdConcessionAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.householdConcessionAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdMonthsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdMonthsTable> {
  $$HouseholdMonthsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get charge => $composableBuilder(
      column: $table.charge, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get concession => $composableBuilder(
      column: $table.concession, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdMonthsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdMonthsTable> {
  $$HouseholdMonthsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<double> get charge =>
      $composableBuilder(column: $table.charge, builder: (column) => column);

  GeneratedColumn<double> get concession => $composableBuilder(
      column: $table.concession, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> paymentAllocationsRefs<T extends Object>(
      Expression<T> Function($$PaymentAllocationsTableAnnotationComposer a) f) {
    final $$PaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.paymentAllocations,
            getReferencedColumn: (t) => t.householdMonthId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PaymentAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.paymentAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> householdConcessionAllocationsRefs<T extends Object>(
      Expression<T> Function(
              $$HouseholdConcessionAllocationsTableAnnotationComposer a)
          f) {
    final $$HouseholdConcessionAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdConcessionAllocations,
            getReferencedColumn: (t) => t.householdMonthId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdConcessionAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdConcessionAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdMonthsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdMonthsTable,
    HouseholdMonth,
    $$HouseholdMonthsTableFilterComposer,
    $$HouseholdMonthsTableOrderingComposer,
    $$HouseholdMonthsTableAnnotationComposer,
    $$HouseholdMonthsTableCreateCompanionBuilder,
    $$HouseholdMonthsTableUpdateCompanionBuilder,
    (HouseholdMonth, $$HouseholdMonthsTableReferences),
    HouseholdMonth,
    PrefetchHooks Function(
        {bool householdId,
        bool paymentAllocationsRefs,
        bool householdConcessionAllocationsRefs})> {
  $$HouseholdMonthsTableTableManager(
      _$AppDatabase db, $HouseholdMonthsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdMonthsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdMonthsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdMonthsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> householdId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<double> charge = const Value.absent(),
            Value<double> concession = const Value.absent(),
          }) =>
              HouseholdMonthsCompanion(
            id: id,
            householdId: householdId,
            year: year,
            month: month,
            charge: charge,
            concession: concession,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int householdId,
            required int year,
            required int month,
            Value<double> charge = const Value.absent(),
            Value<double> concession = const Value.absent(),
          }) =>
              HouseholdMonthsCompanion.insert(
            id: id,
            householdId: householdId,
            year: year,
            month: month,
            charge: charge,
            concession: concession,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseholdMonthsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdId = false,
              paymentAllocationsRefs = false,
              householdConcessionAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (paymentAllocationsRefs) db.paymentAllocations,
                if (householdConcessionAllocationsRefs)
                  db.householdConcessionAllocations
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable:
                        $$HouseholdMonthsTableReferences._householdIdTable(db),
                    referencedColumn: $$HouseholdMonthsTableReferences
                        ._householdIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentAllocationsRefs)
                    await $_getPrefetchedData<HouseholdMonth,
                            $HouseholdMonthsTable, PaymentAllocation>(
                        currentTable: table,
                        referencedTable: $$HouseholdMonthsTableReferences
                            ._paymentAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdMonthsTableReferences(db, table, p0)
                                .paymentAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdMonthId == item.id),
                        typedResults: items),
                  if (householdConcessionAllocationsRefs)
                    await $_getPrefetchedData<
                            HouseholdMonth,
                            $HouseholdMonthsTable,
                            HouseholdConcessionAllocation>(
                        currentTable: table,
                        referencedTable: $$HouseholdMonthsTableReferences
                            ._householdConcessionAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdMonthsTableReferences(db, table, p0)
                                .householdConcessionAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdMonthId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseholdMonthsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdMonthsTable,
    HouseholdMonth,
    $$HouseholdMonthsTableFilterComposer,
    $$HouseholdMonthsTableOrderingComposer,
    $$HouseholdMonthsTableAnnotationComposer,
    $$HouseholdMonthsTableCreateCompanionBuilder,
    $$HouseholdMonthsTableUpdateCompanionBuilder,
    (HouseholdMonth, $$HouseholdMonthsTableReferences),
    HouseholdMonth,
    PrefetchHooks Function(
        {bool householdId,
        bool paymentAllocationsRefs,
        bool householdConcessionAllocationsRefs})>;
typedef $$HouseholdPaymentsTableCreateCompanionBuilder
    = HouseholdPaymentsCompanion Function({
  Value<int> id,
  required int householdId,
  Value<DateTime> paymentDate,
  required double amount,
  required String paymentMode,
  Value<String?> receiptNumber,
  Value<String> username,
});
typedef $$HouseholdPaymentsTableUpdateCompanionBuilder
    = HouseholdPaymentsCompanion Function({
  Value<int> id,
  Value<int> householdId,
  Value<DateTime> paymentDate,
  Value<double> amount,
  Value<String> paymentMode,
  Value<String?> receiptNumber,
  Value<String> username,
});

final class $$HouseholdPaymentsTableReferences extends BaseReferences<
    _$AppDatabase, $HouseholdPaymentsTable, HouseholdPayment> {
  $$HouseholdPaymentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) => db.households
      .createAlias('household_payments__household_id__households__id');

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<int>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PaymentAllocationsTable, List<PaymentAllocation>>
      _paymentAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.paymentAllocations,
              aliasName:
                  'household_payments__id__payment_allocations__payment_id');

  $$PaymentAllocationsTableProcessedTableManager get paymentAllocationsRefs {
    final manager =
        $$PaymentAllocationsTableTableManager($_db, $_db.paymentAllocations)
            .filter((f) => f.paymentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_paymentAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OpeningBalancePaymentAllocationsTable,
          List<OpeningBalancePaymentAllocation>>
      _openingBalancePaymentAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.openingBalancePaymentAllocations,
              aliasName:
                  'household_payments__id__opening_balance_payment_allocations__payment_id');

  $$OpeningBalancePaymentAllocationsTableProcessedTableManager
      get openingBalancePaymentAllocationsRefs {
    final manager = $$OpeningBalancePaymentAllocationsTableTableManager(
            $_db, $_db.openingBalancePaymentAllocations)
        .filter((f) => f.paymentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_openingBalancePaymentAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseholdPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdPaymentsTable> {
  $$HouseholdPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
      column: $table.paymentDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> paymentAllocationsRefs(
      Expression<bool> Function($$PaymentAllocationsTableFilterComposer f) f) {
    final $$PaymentAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.paymentAllocations,
        getReferencedColumn: (t) => t.paymentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.paymentAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> openingBalancePaymentAllocationsRefs(
      Expression<bool> Function(
              $$OpeningBalancePaymentAllocationsTableFilterComposer f)
          f) {
    final $$OpeningBalancePaymentAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.openingBalancePaymentAllocations,
            getReferencedColumn: (t) => t.paymentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OpeningBalancePaymentAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.openingBalancePaymentAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdPaymentsTable> {
  $$HouseholdPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
      column: $table.paymentDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdPaymentsTable> {
  $$HouseholdPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
      column: $table.paymentDate, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> paymentAllocationsRefs<T extends Object>(
      Expression<T> Function($$PaymentAllocationsTableAnnotationComposer a) f) {
    final $$PaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.paymentAllocations,
            getReferencedColumn: (t) => t.paymentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PaymentAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.paymentAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> openingBalancePaymentAllocationsRefs<T extends Object>(
      Expression<T> Function(
              $$OpeningBalancePaymentAllocationsTableAnnotationComposer a)
          f) {
    final $$OpeningBalancePaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.openingBalancePaymentAllocations,
            getReferencedColumn: (t) => t.paymentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OpeningBalancePaymentAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.openingBalancePaymentAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdPaymentsTable,
    HouseholdPayment,
    $$HouseholdPaymentsTableFilterComposer,
    $$HouseholdPaymentsTableOrderingComposer,
    $$HouseholdPaymentsTableAnnotationComposer,
    $$HouseholdPaymentsTableCreateCompanionBuilder,
    $$HouseholdPaymentsTableUpdateCompanionBuilder,
    (HouseholdPayment, $$HouseholdPaymentsTableReferences),
    HouseholdPayment,
    PrefetchHooks Function(
        {bool householdId,
        bool paymentAllocationsRefs,
        bool openingBalancePaymentAllocationsRefs})> {
  $$HouseholdPaymentsTableTableManager(
      _$AppDatabase db, $HouseholdPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdPaymentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> householdId = const Value.absent(),
            Value<DateTime> paymentDate = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String?> receiptNumber = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              HouseholdPaymentsCompanion(
            id: id,
            householdId: householdId,
            paymentDate: paymentDate,
            amount: amount,
            paymentMode: paymentMode,
            receiptNumber: receiptNumber,
            username: username,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int householdId,
            Value<DateTime> paymentDate = const Value.absent(),
            required double amount,
            required String paymentMode,
            Value<String?> receiptNumber = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              HouseholdPaymentsCompanion.insert(
            id: id,
            householdId: householdId,
            paymentDate: paymentDate,
            amount: amount,
            paymentMode: paymentMode,
            receiptNumber: receiptNumber,
            username: username,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseholdPaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdId = false,
              paymentAllocationsRefs = false,
              openingBalancePaymentAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (paymentAllocationsRefs) db.paymentAllocations,
                if (openingBalancePaymentAllocationsRefs)
                  db.openingBalancePaymentAllocations
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable: $$HouseholdPaymentsTableReferences
                        ._householdIdTable(db),
                    referencedColumn: $$HouseholdPaymentsTableReferences
                        ._householdIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentAllocationsRefs)
                    await $_getPrefetchedData<HouseholdPayment,
                            $HouseholdPaymentsTable, PaymentAllocation>(
                        currentTable: table,
                        referencedTable: $$HouseholdPaymentsTableReferences
                            ._paymentAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdPaymentsTableReferences(db, table, p0)
                                .paymentAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.paymentId == item.id),
                        typedResults: items),
                  if (openingBalancePaymentAllocationsRefs)
                    await $_getPrefetchedData<
                            HouseholdPayment,
                            $HouseholdPaymentsTable,
                            OpeningBalancePaymentAllocation>(
                        currentTable: table,
                        referencedTable: $$HouseholdPaymentsTableReferences
                            ._openingBalancePaymentAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdPaymentsTableReferences(db, table, p0)
                                .openingBalancePaymentAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.paymentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseholdPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdPaymentsTable,
    HouseholdPayment,
    $$HouseholdPaymentsTableFilterComposer,
    $$HouseholdPaymentsTableOrderingComposer,
    $$HouseholdPaymentsTableAnnotationComposer,
    $$HouseholdPaymentsTableCreateCompanionBuilder,
    $$HouseholdPaymentsTableUpdateCompanionBuilder,
    (HouseholdPayment, $$HouseholdPaymentsTableReferences),
    HouseholdPayment,
    PrefetchHooks Function(
        {bool householdId,
        bool paymentAllocationsRefs,
        bool openingBalancePaymentAllocationsRefs})>;
typedef $$PaymentAllocationsTableCreateCompanionBuilder
    = PaymentAllocationsCompanion Function({
  Value<int> id,
  required int paymentId,
  required int householdMonthId,
  required double amount,
});
typedef $$PaymentAllocationsTableUpdateCompanionBuilder
    = PaymentAllocationsCompanion Function({
  Value<int> id,
  Value<int> paymentId,
  Value<int> householdMonthId,
  Value<double> amount,
});

final class $$PaymentAllocationsTableReferences extends BaseReferences<
    _$AppDatabase, $PaymentAllocationsTable, PaymentAllocation> {
  $$PaymentAllocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdPaymentsTable _paymentIdTable(_$AppDatabase db) => db
      .householdPayments
      .createAlias('payment_allocations__payment_id__household_payments__id');

  $$HouseholdPaymentsTableProcessedTableManager get paymentId {
    final $_column = $_itemColumn<int>('payment_id')!;

    final manager =
        $$HouseholdPaymentsTableTableManager($_db, $_db.householdPayments)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HouseholdMonthsTable _householdMonthIdTable(_$AppDatabase db) =>
      db.householdMonths.createAlias(
          'payment_allocations__household_month_id__household_months__id');

  $$HouseholdMonthsTableProcessedTableManager get householdMonthId {
    final $_column = $_itemColumn<int>('household_month_id')!;

    final manager =
        $$HouseholdMonthsTableTableManager($_db, $_db.householdMonths)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdMonthIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PaymentAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$HouseholdPaymentsTableFilterComposer get paymentId {
    final $$HouseholdPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentId,
        referencedTable: $db.householdPayments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.householdPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseholdMonthsTableFilterComposer get householdMonthId {
    final $$HouseholdMonthsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdMonthId,
        referencedTable: $db.householdMonths,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMonthsTableFilterComposer(
              $db: $db,
              $table: $db.householdMonths,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$HouseholdPaymentsTableOrderingComposer get paymentId {
    final $$HouseholdPaymentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentId,
        referencedTable: $db.householdPayments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdPaymentsTableOrderingComposer(
              $db: $db,
              $table: $db.householdPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseholdMonthsTableOrderingComposer get householdMonthId {
    final $$HouseholdMonthsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdMonthId,
        referencedTable: $db.householdMonths,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMonthsTableOrderingComposer(
              $db: $db,
              $table: $db.householdMonths,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$HouseholdPaymentsTableAnnotationComposer get paymentId {
    final $$HouseholdPaymentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.paymentId,
            referencedTable: $db.householdPayments,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdPaymentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdPayments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$HouseholdMonthsTableAnnotationComposer get householdMonthId {
    final $$HouseholdMonthsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdMonthId,
        referencedTable: $db.householdMonths,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMonthsTableAnnotationComposer(
              $db: $db,
              $table: $db.householdMonths,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentAllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentAllocationsTable,
    PaymentAllocation,
    $$PaymentAllocationsTableFilterComposer,
    $$PaymentAllocationsTableOrderingComposer,
    $$PaymentAllocationsTableAnnotationComposer,
    $$PaymentAllocationsTableCreateCompanionBuilder,
    $$PaymentAllocationsTableUpdateCompanionBuilder,
    (PaymentAllocation, $$PaymentAllocationsTableReferences),
    PaymentAllocation,
    PrefetchHooks Function({bool paymentId, bool householdMonthId})> {
  $$PaymentAllocationsTableTableManager(
      _$AppDatabase db, $PaymentAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentAllocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> paymentId = const Value.absent(),
            Value<int> householdMonthId = const Value.absent(),
            Value<double> amount = const Value.absent(),
          }) =>
              PaymentAllocationsCompanion(
            id: id,
            paymentId: paymentId,
            householdMonthId: householdMonthId,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int paymentId,
            required int householdMonthId,
            required double amount,
          }) =>
              PaymentAllocationsCompanion.insert(
            id: id,
            paymentId: paymentId,
            householdMonthId: householdMonthId,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PaymentAllocationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {paymentId = false, householdMonthId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (paymentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.paymentId,
                    referencedTable:
                        $$PaymentAllocationsTableReferences._paymentIdTable(db),
                    referencedColumn: $$PaymentAllocationsTableReferences
                        ._paymentIdTable(db)
                        .id,
                  ) as T;
                }
                if (householdMonthId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdMonthId,
                    referencedTable: $$PaymentAllocationsTableReferences
                        ._householdMonthIdTable(db),
                    referencedColumn: $$PaymentAllocationsTableReferences
                        ._householdMonthIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PaymentAllocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentAllocationsTable,
    PaymentAllocation,
    $$PaymentAllocationsTableFilterComposer,
    $$PaymentAllocationsTableOrderingComposer,
    $$PaymentAllocationsTableAnnotationComposer,
    $$PaymentAllocationsTableCreateCompanionBuilder,
    $$PaymentAllocationsTableUpdateCompanionBuilder,
    (PaymentAllocation, $$PaymentAllocationsTableReferences),
    PaymentAllocation,
    PrefetchHooks Function({bool paymentId, bool householdMonthId})>;
typedef $$HouseholdStatusHistoriesTableCreateCompanionBuilder
    = HouseholdStatusHistoriesCompanion Function({
  Value<int> id,
  required int householdId,
  required String status,
  required DateTime eventDate,
  Value<String?> notes,
});
typedef $$HouseholdStatusHistoriesTableUpdateCompanionBuilder
    = HouseholdStatusHistoriesCompanion Function({
  Value<int> id,
  Value<int> householdId,
  Value<String> status,
  Value<DateTime> eventDate,
  Value<String?> notes,
});

final class $$HouseholdStatusHistoriesTableReferences extends BaseReferences<
    _$AppDatabase, $HouseholdStatusHistoriesTable, HouseholdStatusHistory> {
  $$HouseholdStatusHistoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) => db.households
      .createAlias('household_status_histories__household_id__households__id');

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<int>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HouseholdStatusHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdStatusHistoriesTable> {
  $$HouseholdStatusHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get eventDate => $composableBuilder(
      column: $table.eventDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdStatusHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdStatusHistoriesTable> {
  $$HouseholdStatusHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get eventDate => $composableBuilder(
      column: $table.eventDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdStatusHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdStatusHistoriesTable> {
  $$HouseholdStatusHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdStatusHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdStatusHistoriesTable,
    HouseholdStatusHistory,
    $$HouseholdStatusHistoriesTableFilterComposer,
    $$HouseholdStatusHistoriesTableOrderingComposer,
    $$HouseholdStatusHistoriesTableAnnotationComposer,
    $$HouseholdStatusHistoriesTableCreateCompanionBuilder,
    $$HouseholdStatusHistoriesTableUpdateCompanionBuilder,
    (HouseholdStatusHistory, $$HouseholdStatusHistoriesTableReferences),
    HouseholdStatusHistory,
    PrefetchHooks Function({bool householdId})> {
  $$HouseholdStatusHistoriesTableTableManager(
      _$AppDatabase db, $HouseholdStatusHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdStatusHistoriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdStatusHistoriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdStatusHistoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> householdId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> eventDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              HouseholdStatusHistoriesCompanion(
            id: id,
            householdId: householdId,
            status: status,
            eventDate: eventDate,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int householdId,
            required String status,
            required DateTime eventDate,
            Value<String?> notes = const Value.absent(),
          }) =>
              HouseholdStatusHistoriesCompanion.insert(
            id: id,
            householdId: householdId,
            status: status,
            eventDate: eventDate,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseholdStatusHistoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({householdId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable: $$HouseholdStatusHistoriesTableReferences
                        ._householdIdTable(db),
                    referencedColumn: $$HouseholdStatusHistoriesTableReferences
                        ._householdIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HouseholdStatusHistoriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $HouseholdStatusHistoriesTable,
        HouseholdStatusHistory,
        $$HouseholdStatusHistoriesTableFilterComposer,
        $$HouseholdStatusHistoriesTableOrderingComposer,
        $$HouseholdStatusHistoriesTableAnnotationComposer,
        $$HouseholdStatusHistoriesTableCreateCompanionBuilder,
        $$HouseholdStatusHistoriesTableUpdateCompanionBuilder,
        (HouseholdStatusHistory, $$HouseholdStatusHistoriesTableReferences),
        HouseholdStatusHistory,
        PrefetchHooks Function({bool householdId})>;
typedef $$HouseholdConcessionsTableCreateCompanionBuilder
    = HouseholdConcessionsCompanion Function({
  Value<int> id,
  required int householdId,
  Value<DateTime> concessionDate,
  required double amount,
  Value<String?> receiptNumber,
  Value<String?> remarks,
  Value<String> username,
});
typedef $$HouseholdConcessionsTableUpdateCompanionBuilder
    = HouseholdConcessionsCompanion Function({
  Value<int> id,
  Value<int> householdId,
  Value<DateTime> concessionDate,
  Value<double> amount,
  Value<String?> receiptNumber,
  Value<String?> remarks,
  Value<String> username,
});

final class $$HouseholdConcessionsTableReferences extends BaseReferences<
    _$AppDatabase, $HouseholdConcessionsTable, HouseholdConcession> {
  $$HouseholdConcessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) => db.households
      .createAlias('household_concessions__household_id__households__id');

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<int>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$HouseholdConcessionAllocationsTable,
      List<HouseholdConcessionAllocation>> _householdConcessionAllocationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.householdConcessionAllocations,
          aliasName:
              'household_concessions__id__household_concession_allocations__concession_id');

  $$HouseholdConcessionAllocationsTableProcessedTableManager
      get householdConcessionAllocationsRefs {
    final manager = $$HouseholdConcessionAllocationsTableTableManager(
            $_db, $_db.householdConcessionAllocations)
        .filter((f) => f.concessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_householdConcessionAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OpeningBalanceConcessionAllocationsTable,
          List<OpeningBalanceConcessionAllocation>>
      _openingBalanceConcessionAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.openingBalanceConcessionAllocations,
              aliasName:
                  'household_concessions__id__opening_balance_concession_allocations__concession_id');

  $$OpeningBalanceConcessionAllocationsTableProcessedTableManager
      get openingBalanceConcessionAllocationsRefs {
    final manager = $$OpeningBalanceConcessionAllocationsTableTableManager(
            $_db, $_db.openingBalanceConcessionAllocations)
        .filter((f) => f.concessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_openingBalanceConcessionAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseholdConcessionsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdConcessionsTable> {
  $$HouseholdConcessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get concessionDate => $composableBuilder(
      column: $table.concessionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> householdConcessionAllocationsRefs(
      Expression<bool> Function(
              $$HouseholdConcessionAllocationsTableFilterComposer f)
          f) {
    final $$HouseholdConcessionAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdConcessionAllocations,
            getReferencedColumn: (t) => t.concessionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdConcessionAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.householdConcessionAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> openingBalanceConcessionAllocationsRefs(
      Expression<bool> Function(
              $$OpeningBalanceConcessionAllocationsTableFilterComposer f)
          f) {
    final $$OpeningBalanceConcessionAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.openingBalanceConcessionAllocations,
            getReferencedColumn: (t) => t.concessionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OpeningBalanceConcessionAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.openingBalanceConcessionAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdConcessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdConcessionsTable> {
  $$HouseholdConcessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get concessionDate => $composableBuilder(
      column: $table.concessionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdConcessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdConcessionsTable> {
  $$HouseholdConcessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get concessionDate => $composableBuilder(
      column: $table.concessionDate, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> householdConcessionAllocationsRefs<T extends Object>(
      Expression<T> Function(
              $$HouseholdConcessionAllocationsTableAnnotationComposer a)
          f) {
    final $$HouseholdConcessionAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.householdConcessionAllocations,
            getReferencedColumn: (t) => t.concessionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdConcessionAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdConcessionAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> openingBalanceConcessionAllocationsRefs<T extends Object>(
      Expression<T> Function(
              $$OpeningBalanceConcessionAllocationsTableAnnotationComposer a)
          f) {
    final $$OpeningBalanceConcessionAllocationsTableAnnotationComposer
        composer = $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.openingBalanceConcessionAllocations,
            getReferencedColumn: (t) => t.concessionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OpeningBalanceConcessionAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.openingBalanceConcessionAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdConcessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdConcessionsTable,
    HouseholdConcession,
    $$HouseholdConcessionsTableFilterComposer,
    $$HouseholdConcessionsTableOrderingComposer,
    $$HouseholdConcessionsTableAnnotationComposer,
    $$HouseholdConcessionsTableCreateCompanionBuilder,
    $$HouseholdConcessionsTableUpdateCompanionBuilder,
    (HouseholdConcession, $$HouseholdConcessionsTableReferences),
    HouseholdConcession,
    PrefetchHooks Function(
        {bool householdId,
        bool householdConcessionAllocationsRefs,
        bool openingBalanceConcessionAllocationsRefs})> {
  $$HouseholdConcessionsTableTableManager(
      _$AppDatabase db, $HouseholdConcessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdConcessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdConcessionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdConcessionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> householdId = const Value.absent(),
            Value<DateTime> concessionDate = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> receiptNumber = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              HouseholdConcessionsCompanion(
            id: id,
            householdId: householdId,
            concessionDate: concessionDate,
            amount: amount,
            receiptNumber: receiptNumber,
            remarks: remarks,
            username: username,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int householdId,
            Value<DateTime> concessionDate = const Value.absent(),
            required double amount,
            Value<String?> receiptNumber = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              HouseholdConcessionsCompanion.insert(
            id: id,
            householdId: householdId,
            concessionDate: concessionDate,
            amount: amount,
            receiptNumber: receiptNumber,
            remarks: remarks,
            username: username,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseholdConcessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdId = false,
              householdConcessionAllocationsRefs = false,
              openingBalanceConcessionAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (householdConcessionAllocationsRefs)
                  db.householdConcessionAllocations,
                if (openingBalanceConcessionAllocationsRefs)
                  db.openingBalanceConcessionAllocations
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable: $$HouseholdConcessionsTableReferences
                        ._householdIdTable(db),
                    referencedColumn: $$HouseholdConcessionsTableReferences
                        ._householdIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (householdConcessionAllocationsRefs)
                    await $_getPrefetchedData<
                            HouseholdConcession,
                            $HouseholdConcessionsTable,
                            HouseholdConcessionAllocation>(
                        currentTable: table,
                        referencedTable: $$HouseholdConcessionsTableReferences
                            ._householdConcessionAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdConcessionsTableReferences(db, table, p0)
                                .householdConcessionAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.concessionId == item.id),
                        typedResults: items),
                  if (openingBalanceConcessionAllocationsRefs)
                    await $_getPrefetchedData<
                            HouseholdConcession,
                            $HouseholdConcessionsTable,
                            OpeningBalanceConcessionAllocation>(
                        currentTable: table,
                        referencedTable: $$HouseholdConcessionsTableReferences
                            ._openingBalanceConcessionAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdConcessionsTableReferences(db, table, p0)
                                .openingBalanceConcessionAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.concessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseholdConcessionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $HouseholdConcessionsTable,
        HouseholdConcession,
        $$HouseholdConcessionsTableFilterComposer,
        $$HouseholdConcessionsTableOrderingComposer,
        $$HouseholdConcessionsTableAnnotationComposer,
        $$HouseholdConcessionsTableCreateCompanionBuilder,
        $$HouseholdConcessionsTableUpdateCompanionBuilder,
        (HouseholdConcession, $$HouseholdConcessionsTableReferences),
        HouseholdConcession,
        PrefetchHooks Function(
            {bool householdId,
            bool householdConcessionAllocationsRefs,
            bool openingBalanceConcessionAllocationsRefs})>;
typedef $$HouseholdConcessionAllocationsTableCreateCompanionBuilder
    = HouseholdConcessionAllocationsCompanion Function({
  Value<int> id,
  required int concessionId,
  required int householdMonthId,
  required double amount,
});
typedef $$HouseholdConcessionAllocationsTableUpdateCompanionBuilder
    = HouseholdConcessionAllocationsCompanion Function({
  Value<int> id,
  Value<int> concessionId,
  Value<int> householdMonthId,
  Value<double> amount,
});

final class $$HouseholdConcessionAllocationsTableReferences
    extends BaseReferences<_$AppDatabase, $HouseholdConcessionAllocationsTable,
        HouseholdConcessionAllocation> {
  $$HouseholdConcessionAllocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdConcessionsTable _concessionIdTable(_$AppDatabase db) =>
      db.householdConcessions.createAlias(
          'household_concession_allocations__concession_id__household_concessions__id');

  $$HouseholdConcessionsTableProcessedTableManager get concessionId {
    final $_column = $_itemColumn<int>('concession_id')!;

    final manager =
        $$HouseholdConcessionsTableTableManager($_db, $_db.householdConcessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_concessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HouseholdMonthsTable _householdMonthIdTable(_$AppDatabase db) =>
      db.householdMonths.createAlias(
          'household_concession_allocations__household_month_id__household_months__id');

  $$HouseholdMonthsTableProcessedTableManager get householdMonthId {
    final $_column = $_itemColumn<int>('household_month_id')!;

    final manager =
        $$HouseholdMonthsTableTableManager($_db, $_db.householdMonths)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdMonthIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HouseholdConcessionAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdConcessionAllocationsTable> {
  $$HouseholdConcessionAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$HouseholdConcessionsTableFilterComposer get concessionId {
    final $$HouseholdConcessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.concessionId,
        referencedTable: $db.householdConcessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdConcessionsTableFilterComposer(
              $db: $db,
              $table: $db.householdConcessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseholdMonthsTableFilterComposer get householdMonthId {
    final $$HouseholdMonthsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdMonthId,
        referencedTable: $db.householdMonths,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMonthsTableFilterComposer(
              $db: $db,
              $table: $db.householdMonths,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdConcessionAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdConcessionAllocationsTable> {
  $$HouseholdConcessionAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$HouseholdConcessionsTableOrderingComposer get concessionId {
    final $$HouseholdConcessionsTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.concessionId,
            referencedTable: $db.householdConcessions,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdConcessionsTableOrderingComposer(
                  $db: $db,
                  $table: $db.householdConcessions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$HouseholdMonthsTableOrderingComposer get householdMonthId {
    final $$HouseholdMonthsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdMonthId,
        referencedTable: $db.householdMonths,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMonthsTableOrderingComposer(
              $db: $db,
              $table: $db.householdMonths,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdConcessionAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdConcessionAllocationsTable> {
  $$HouseholdConcessionAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$HouseholdConcessionsTableAnnotationComposer get concessionId {
    final $$HouseholdConcessionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.concessionId,
            referencedTable: $db.householdConcessions,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdConcessionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdConcessions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$HouseholdMonthsTableAnnotationComposer get householdMonthId {
    final $$HouseholdMonthsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdMonthId,
        referencedTable: $db.householdMonths,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMonthsTableAnnotationComposer(
              $db: $db,
              $table: $db.householdMonths,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdConcessionAllocationsTableTableManager
    extends RootTableManager<
        _$AppDatabase,
        $HouseholdConcessionAllocationsTable,
        HouseholdConcessionAllocation,
        $$HouseholdConcessionAllocationsTableFilterComposer,
        $$HouseholdConcessionAllocationsTableOrderingComposer,
        $$HouseholdConcessionAllocationsTableAnnotationComposer,
        $$HouseholdConcessionAllocationsTableCreateCompanionBuilder,
        $$HouseholdConcessionAllocationsTableUpdateCompanionBuilder,
        (
          HouseholdConcessionAllocation,
          $$HouseholdConcessionAllocationsTableReferences
        ),
        HouseholdConcessionAllocation,
        PrefetchHooks Function({bool concessionId, bool householdMonthId})> {
  $$HouseholdConcessionAllocationsTableTableManager(
      _$AppDatabase db, $HouseholdConcessionAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdConcessionAllocationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdConcessionAllocationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdConcessionAllocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> concessionId = const Value.absent(),
            Value<int> householdMonthId = const Value.absent(),
            Value<double> amount = const Value.absent(),
          }) =>
              HouseholdConcessionAllocationsCompanion(
            id: id,
            concessionId: concessionId,
            householdMonthId: householdMonthId,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int concessionId,
            required int householdMonthId,
            required double amount,
          }) =>
              HouseholdConcessionAllocationsCompanion.insert(
            id: id,
            concessionId: concessionId,
            householdMonthId: householdMonthId,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseholdConcessionAllocationsTableReferences(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {concessionId = false, householdMonthId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (concessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.concessionId,
                    referencedTable:
                        $$HouseholdConcessionAllocationsTableReferences
                            ._concessionIdTable(db),
                    referencedColumn:
                        $$HouseholdConcessionAllocationsTableReferences
                            ._concessionIdTable(db)
                            .id,
                  ) as T;
                }
                if (householdMonthId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdMonthId,
                    referencedTable:
                        $$HouseholdConcessionAllocationsTableReferences
                            ._householdMonthIdTable(db),
                    referencedColumn:
                        $$HouseholdConcessionAllocationsTableReferences
                            ._householdMonthIdTable(db)
                            .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HouseholdConcessionAllocationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $HouseholdConcessionAllocationsTable,
        HouseholdConcessionAllocation,
        $$HouseholdConcessionAllocationsTableFilterComposer,
        $$HouseholdConcessionAllocationsTableOrderingComposer,
        $$HouseholdConcessionAllocationsTableAnnotationComposer,
        $$HouseholdConcessionAllocationsTableCreateCompanionBuilder,
        $$HouseholdConcessionAllocationsTableUpdateCompanionBuilder,
        (
          HouseholdConcessionAllocation,
          $$HouseholdConcessionAllocationsTableReferences
        ),
        HouseholdConcessionAllocation,
        PrefetchHooks Function({bool concessionId, bool householdMonthId})>;
typedef $$OpeningBalancePaymentAllocationsTableCreateCompanionBuilder
    = OpeningBalancePaymentAllocationsCompanion Function({
  Value<int> id,
  required int paymentId,
  required int householdId,
  required double amount,
});
typedef $$OpeningBalancePaymentAllocationsTableUpdateCompanionBuilder
    = OpeningBalancePaymentAllocationsCompanion Function({
  Value<int> id,
  Value<int> paymentId,
  Value<int> householdId,
  Value<double> amount,
});

final class $$OpeningBalancePaymentAllocationsTableReferences
    extends BaseReferences<
        _$AppDatabase,
        $OpeningBalancePaymentAllocationsTable,
        OpeningBalancePaymentAllocation> {
  $$OpeningBalancePaymentAllocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdPaymentsTable _paymentIdTable(_$AppDatabase db) =>
      db.householdPayments.createAlias(
          'opening_balance_payment_allocations__payment_id__household_payments__id');

  $$HouseholdPaymentsTableProcessedTableManager get paymentId {
    final $_column = $_itemColumn<int>('payment_id')!;

    final manager =
        $$HouseholdPaymentsTableTableManager($_db, $_db.householdPayments)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias(
          'opening_balance_payment_allocations__household_id__households__id');

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<int>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OpeningBalancePaymentAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $OpeningBalancePaymentAllocationsTable> {
  $$OpeningBalancePaymentAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$HouseholdPaymentsTableFilterComposer get paymentId {
    final $$HouseholdPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentId,
        referencedTable: $db.householdPayments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.householdPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OpeningBalancePaymentAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OpeningBalancePaymentAllocationsTable> {
  $$OpeningBalancePaymentAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$HouseholdPaymentsTableOrderingComposer get paymentId {
    final $$HouseholdPaymentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentId,
        referencedTable: $db.householdPayments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdPaymentsTableOrderingComposer(
              $db: $db,
              $table: $db.householdPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OpeningBalancePaymentAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OpeningBalancePaymentAllocationsTable> {
  $$OpeningBalancePaymentAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$HouseholdPaymentsTableAnnotationComposer get paymentId {
    final $$HouseholdPaymentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.paymentId,
            referencedTable: $db.householdPayments,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdPaymentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdPayments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OpeningBalancePaymentAllocationsTableTableManager
    extends RootTableManager<
        _$AppDatabase,
        $OpeningBalancePaymentAllocationsTable,
        OpeningBalancePaymentAllocation,
        $$OpeningBalancePaymentAllocationsTableFilterComposer,
        $$OpeningBalancePaymentAllocationsTableOrderingComposer,
        $$OpeningBalancePaymentAllocationsTableAnnotationComposer,
        $$OpeningBalancePaymentAllocationsTableCreateCompanionBuilder,
        $$OpeningBalancePaymentAllocationsTableUpdateCompanionBuilder,
        (
          OpeningBalancePaymentAllocation,
          $$OpeningBalancePaymentAllocationsTableReferences
        ),
        OpeningBalancePaymentAllocation,
        PrefetchHooks Function({bool paymentId, bool householdId})> {
  $$OpeningBalancePaymentAllocationsTableTableManager(
      _$AppDatabase db, $OpeningBalancePaymentAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OpeningBalancePaymentAllocationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$OpeningBalancePaymentAllocationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OpeningBalancePaymentAllocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> paymentId = const Value.absent(),
            Value<int> householdId = const Value.absent(),
            Value<double> amount = const Value.absent(),
          }) =>
              OpeningBalancePaymentAllocationsCompanion(
            id: id,
            paymentId: paymentId,
            householdId: householdId,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int paymentId,
            required int householdId,
            required double amount,
          }) =>
              OpeningBalancePaymentAllocationsCompanion.insert(
            id: id,
            paymentId: paymentId,
            householdId: householdId,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OpeningBalancePaymentAllocationsTableReferences(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({paymentId = false, householdId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (paymentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.paymentId,
                    referencedTable:
                        $$OpeningBalancePaymentAllocationsTableReferences
                            ._paymentIdTable(db),
                    referencedColumn:
                        $$OpeningBalancePaymentAllocationsTableReferences
                            ._paymentIdTable(db)
                            .id,
                  ) as T;
                }
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable:
                        $$OpeningBalancePaymentAllocationsTableReferences
                            ._householdIdTable(db),
                    referencedColumn:
                        $$OpeningBalancePaymentAllocationsTableReferences
                            ._householdIdTable(db)
                            .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OpeningBalancePaymentAllocationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $OpeningBalancePaymentAllocationsTable,
        OpeningBalancePaymentAllocation,
        $$OpeningBalancePaymentAllocationsTableFilterComposer,
        $$OpeningBalancePaymentAllocationsTableOrderingComposer,
        $$OpeningBalancePaymentAllocationsTableAnnotationComposer,
        $$OpeningBalancePaymentAllocationsTableCreateCompanionBuilder,
        $$OpeningBalancePaymentAllocationsTableUpdateCompanionBuilder,
        (
          OpeningBalancePaymentAllocation,
          $$OpeningBalancePaymentAllocationsTableReferences
        ),
        OpeningBalancePaymentAllocation,
        PrefetchHooks Function({bool paymentId, bool householdId})>;
typedef $$OpeningBalanceConcessionAllocationsTableCreateCompanionBuilder
    = OpeningBalanceConcessionAllocationsCompanion Function({
  Value<int> id,
  required int concessionId,
  required int householdId,
  required double amount,
});
typedef $$OpeningBalanceConcessionAllocationsTableUpdateCompanionBuilder
    = OpeningBalanceConcessionAllocationsCompanion Function({
  Value<int> id,
  Value<int> concessionId,
  Value<int> householdId,
  Value<double> amount,
});

final class $$OpeningBalanceConcessionAllocationsTableReferences
    extends BaseReferences<
        _$AppDatabase,
        $OpeningBalanceConcessionAllocationsTable,
        OpeningBalanceConcessionAllocation> {
  $$OpeningBalanceConcessionAllocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdConcessionsTable _concessionIdTable(_$AppDatabase db) =>
      db.householdConcessions.createAlias(
          'opening_balance_concession_allocations__concession_id__household_concessions__id');

  $$HouseholdConcessionsTableProcessedTableManager get concessionId {
    final $_column = $_itemColumn<int>('concession_id')!;

    final manager =
        $$HouseholdConcessionsTableTableManager($_db, $_db.householdConcessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_concessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias(
          'opening_balance_concession_allocations__household_id__households__id');

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<int>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OpeningBalanceConcessionAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $OpeningBalanceConcessionAllocationsTable> {
  $$OpeningBalanceConcessionAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$HouseholdConcessionsTableFilterComposer get concessionId {
    final $$HouseholdConcessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.concessionId,
        referencedTable: $db.householdConcessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdConcessionsTableFilterComposer(
              $db: $db,
              $table: $db.householdConcessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OpeningBalanceConcessionAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OpeningBalanceConcessionAllocationsTable> {
  $$OpeningBalanceConcessionAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$HouseholdConcessionsTableOrderingComposer get concessionId {
    final $$HouseholdConcessionsTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.concessionId,
            referencedTable: $db.householdConcessions,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdConcessionsTableOrderingComposer(
                  $db: $db,
                  $table: $db.householdConcessions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OpeningBalanceConcessionAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OpeningBalanceConcessionAllocationsTable> {
  $$OpeningBalanceConcessionAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$HouseholdConcessionsTableAnnotationComposer get concessionId {
    final $$HouseholdConcessionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.concessionId,
            referencedTable: $db.householdConcessions,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$HouseholdConcessionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.householdConcessions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OpeningBalanceConcessionAllocationsTableTableManager
    extends RootTableManager<
        _$AppDatabase,
        $OpeningBalanceConcessionAllocationsTable,
        OpeningBalanceConcessionAllocation,
        $$OpeningBalanceConcessionAllocationsTableFilterComposer,
        $$OpeningBalanceConcessionAllocationsTableOrderingComposer,
        $$OpeningBalanceConcessionAllocationsTableAnnotationComposer,
        $$OpeningBalanceConcessionAllocationsTableCreateCompanionBuilder,
        $$OpeningBalanceConcessionAllocationsTableUpdateCompanionBuilder,
        (
          OpeningBalanceConcessionAllocation,
          $$OpeningBalanceConcessionAllocationsTableReferences
        ),
        OpeningBalanceConcessionAllocation,
        PrefetchHooks Function({bool concessionId, bool householdId})> {
  $$OpeningBalanceConcessionAllocationsTableTableManager(
      _$AppDatabase db, $OpeningBalanceConcessionAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OpeningBalanceConcessionAllocationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$OpeningBalanceConcessionAllocationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OpeningBalanceConcessionAllocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> concessionId = const Value.absent(),
            Value<int> householdId = const Value.absent(),
            Value<double> amount = const Value.absent(),
          }) =>
              OpeningBalanceConcessionAllocationsCompanion(
            id: id,
            concessionId: concessionId,
            householdId: householdId,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int concessionId,
            required int householdId,
            required double amount,
          }) =>
              OpeningBalanceConcessionAllocationsCompanion.insert(
            id: id,
            concessionId: concessionId,
            householdId: householdId,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OpeningBalanceConcessionAllocationsTableReferences(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({concessionId = false, householdId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (concessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.concessionId,
                    referencedTable:
                        $$OpeningBalanceConcessionAllocationsTableReferences
                            ._concessionIdTable(db),
                    referencedColumn:
                        $$OpeningBalanceConcessionAllocationsTableReferences
                            ._concessionIdTable(db)
                            .id,
                  ) as T;
                }
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable:
                        $$OpeningBalanceConcessionAllocationsTableReferences
                            ._householdIdTable(db),
                    referencedColumn:
                        $$OpeningBalanceConcessionAllocationsTableReferences
                            ._householdIdTable(db)
                            .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OpeningBalanceConcessionAllocationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $OpeningBalanceConcessionAllocationsTable,
        OpeningBalanceConcessionAllocation,
        $$OpeningBalanceConcessionAllocationsTableFilterComposer,
        $$OpeningBalanceConcessionAllocationsTableOrderingComposer,
        $$OpeningBalanceConcessionAllocationsTableAnnotationComposer,
        $$OpeningBalanceConcessionAllocationsTableCreateCompanionBuilder,
        $$OpeningBalanceConcessionAllocationsTableUpdateCompanionBuilder,
        (
          OpeningBalanceConcessionAllocation,
          $$OpeningBalanceConcessionAllocationsTableReferences
        ),
        OpeningBalanceConcessionAllocation,
        PrefetchHooks Function({bool concessionId, bool householdId})>;
typedef $$FinancialTransactionsTableCreateCompanionBuilder
    = FinancialTransactionsCompanion Function({
  Value<int> id,
  Value<DateTime> transactionDate,
  required String category,
  required String paymentMode,
  required double amount,
  Value<String?> receiptNumber,
  Value<String?> donorName,
  Value<String?> remarks,
  Value<String> username,
});
typedef $$FinancialTransactionsTableUpdateCompanionBuilder
    = FinancialTransactionsCompanion Function({
  Value<int> id,
  Value<DateTime> transactionDate,
  Value<String> category,
  Value<String> paymentMode,
  Value<double> amount,
  Value<String?> receiptNumber,
  Value<String?> donorName,
  Value<String?> remarks,
  Value<String> username,
});

class $$FinancialTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialTransactionsTable> {
  $$FinancialTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get donorName => $composableBuilder(
      column: $table.donorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));
}

class $$FinancialTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialTransactionsTable> {
  $$FinancialTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get donorName => $composableBuilder(
      column: $table.donorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));
}

class $$FinancialTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialTransactionsTable> {
  $$FinancialTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => column);

  GeneratedColumn<String> get donorName =>
      $composableBuilder(column: $table.donorName, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);
}

class $$FinancialTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinancialTransactionsTable,
    FinancialTransaction,
    $$FinancialTransactionsTableFilterComposer,
    $$FinancialTransactionsTableOrderingComposer,
    $$FinancialTransactionsTableAnnotationComposer,
    $$FinancialTransactionsTableCreateCompanionBuilder,
    $$FinancialTransactionsTableUpdateCompanionBuilder,
    (
      FinancialTransaction,
      BaseReferences<_$AppDatabase, $FinancialTransactionsTable,
          FinancialTransaction>
    ),
    FinancialTransaction,
    PrefetchHooks Function()> {
  $$FinancialTransactionsTableTableManager(
      _$AppDatabase db, $FinancialTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialTransactionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialTransactionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> receiptNumber = const Value.absent(),
            Value<String?> donorName = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              FinancialTransactionsCompanion(
            id: id,
            transactionDate: transactionDate,
            category: category,
            paymentMode: paymentMode,
            amount: amount,
            receiptNumber: receiptNumber,
            donorName: donorName,
            remarks: remarks,
            username: username,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            required String category,
            required String paymentMode,
            required double amount,
            Value<String?> receiptNumber = const Value.absent(),
            Value<String?> donorName = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              FinancialTransactionsCompanion.insert(
            id: id,
            transactionDate: transactionDate,
            category: category,
            paymentMode: paymentMode,
            amount: amount,
            receiptNumber: receiptNumber,
            donorName: donorName,
            remarks: remarks,
            username: username,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinancialTransactionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $FinancialTransactionsTable,
        FinancialTransaction,
        $$FinancialTransactionsTableFilterComposer,
        $$FinancialTransactionsTableOrderingComposer,
        $$FinancialTransactionsTableAnnotationComposer,
        $$FinancialTransactionsTableCreateCompanionBuilder,
        $$FinancialTransactionsTableUpdateCompanionBuilder,
        (
          FinancialTransaction,
          BaseReferences<_$AppDatabase, $FinancialTransactionsTable,
              FinancialTransaction>
        ),
        FinancialTransaction,
        PrefetchHooks Function()>;
typedef $$ManualBalancesTableCreateCompanionBuilder = ManualBalancesCompanion
    Function({
  Value<int> id,
  Value<double> cashInHand,
  Value<double> bankBalance,
  Value<DateTime> updatedAt,
});
typedef $$ManualBalancesTableUpdateCompanionBuilder = ManualBalancesCompanion
    Function({
  Value<int> id,
  Value<double> cashInHand,
  Value<double> bankBalance,
  Value<DateTime> updatedAt,
});

class $$ManualBalancesTableFilterComposer
    extends Composer<_$AppDatabase, $ManualBalancesTable> {
  $$ManualBalancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cashInHand => $composableBuilder(
      column: $table.cashInHand, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bankBalance => $composableBuilder(
      column: $table.bankBalance, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ManualBalancesTableOrderingComposer
    extends Composer<_$AppDatabase, $ManualBalancesTable> {
  $$ManualBalancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cashInHand => $composableBuilder(
      column: $table.cashInHand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bankBalance => $composableBuilder(
      column: $table.bankBalance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ManualBalancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManualBalancesTable> {
  $$ManualBalancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get cashInHand => $composableBuilder(
      column: $table.cashInHand, builder: (column) => column);

  GeneratedColumn<double> get bankBalance => $composableBuilder(
      column: $table.bankBalance, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ManualBalancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ManualBalancesTable,
    ManualBalance,
    $$ManualBalancesTableFilterComposer,
    $$ManualBalancesTableOrderingComposer,
    $$ManualBalancesTableAnnotationComposer,
    $$ManualBalancesTableCreateCompanionBuilder,
    $$ManualBalancesTableUpdateCompanionBuilder,
    (
      ManualBalance,
      BaseReferences<_$AppDatabase, $ManualBalancesTable, ManualBalance>
    ),
    ManualBalance,
    PrefetchHooks Function()> {
  $$ManualBalancesTableTableManager(
      _$AppDatabase db, $ManualBalancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManualBalancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManualBalancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ManualBalancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> cashInHand = const Value.absent(),
            Value<double> bankBalance = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ManualBalancesCompanion(
            id: id,
            cashInHand: cashInHand,
            bankBalance: bankBalance,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> cashInHand = const Value.absent(),
            Value<double> bankBalance = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ManualBalancesCompanion.insert(
            id: id,
            cashInHand: cashInHand,
            bankBalance: bankBalance,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ManualBalancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ManualBalancesTable,
    ManualBalance,
    $$ManualBalancesTableFilterComposer,
    $$ManualBalancesTableOrderingComposer,
    $$ManualBalancesTableAnnotationComposer,
    $$ManualBalancesTableCreateCompanionBuilder,
    $$ManualBalancesTableUpdateCompanionBuilder,
    (
      ManualBalance,
      BaseReferences<_$AppDatabase, $ManualBalancesTable, ManualBalance>
    ),
    ManualBalance,
    PrefetchHooks Function()>;
typedef $$ZakaatBeneficiariesTableCreateCompanionBuilder
    = ZakaatBeneficiariesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> address,
  Value<String?> aadhaarNumber,
  Value<String?> phoneNumber,
  Value<String?> whatsapp,
  Value<String?> notes,
  Value<bool> isActive,
});
typedef $$ZakaatBeneficiariesTableUpdateCompanionBuilder
    = ZakaatBeneficiariesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> address,
  Value<String?> aadhaarNumber,
  Value<String?> phoneNumber,
  Value<String?> whatsapp,
  Value<String?> notes,
  Value<bool> isActive,
});

final class $$ZakaatBeneficiariesTableReferences extends BaseReferences<
    _$AppDatabase, $ZakaatBeneficiariesTable, ZakaatBeneficiary> {
  $$ZakaatBeneficiariesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ZakaatDisbursementsTable,
      List<ZakaatDisbursement>> _zakaatDisbursementsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.zakaatDisbursements,
          aliasName:
              'zakaat_beneficiaries__id__zakaat_disbursements__beneficiary_id');

  $$ZakaatDisbursementsTableProcessedTableManager get zakaatDisbursementsRefs {
    final manager = $$ZakaatDisbursementsTableTableManager(
            $_db, $_db.zakaatDisbursements)
        .filter((f) => f.beneficiaryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_zakaatDisbursementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ZakaatBeneficiariesTableFilterComposer
    extends Composer<_$AppDatabase, $ZakaatBeneficiariesTable> {
  $$ZakaatBeneficiariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aadhaarNumber => $composableBuilder(
      column: $table.aadhaarNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whatsapp => $composableBuilder(
      column: $table.whatsapp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> zakaatDisbursementsRefs(
      Expression<bool> Function($$ZakaatDisbursementsTableFilterComposer f) f) {
    final $$ZakaatDisbursementsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.zakaatDisbursements,
        getReferencedColumn: (t) => t.beneficiaryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ZakaatDisbursementsTableFilterComposer(
              $db: $db,
              $table: $db.zakaatDisbursements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ZakaatBeneficiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $ZakaatBeneficiariesTable> {
  $$ZakaatBeneficiariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aadhaarNumber => $composableBuilder(
      column: $table.aadhaarNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whatsapp => $composableBuilder(
      column: $table.whatsapp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$ZakaatBeneficiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZakaatBeneficiariesTable> {
  $$ZakaatBeneficiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get aadhaarNumber => $composableBuilder(
      column: $table.aadhaarNumber, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get whatsapp =>
      $composableBuilder(column: $table.whatsapp, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> zakaatDisbursementsRefs<T extends Object>(
      Expression<T> Function($$ZakaatDisbursementsTableAnnotationComposer a)
          f) {
    final $$ZakaatDisbursementsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.zakaatDisbursements,
            getReferencedColumn: (t) => t.beneficiaryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ZakaatDisbursementsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.zakaatDisbursements,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ZakaatBeneficiariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ZakaatBeneficiariesTable,
    ZakaatBeneficiary,
    $$ZakaatBeneficiariesTableFilterComposer,
    $$ZakaatBeneficiariesTableOrderingComposer,
    $$ZakaatBeneficiariesTableAnnotationComposer,
    $$ZakaatBeneficiariesTableCreateCompanionBuilder,
    $$ZakaatBeneficiariesTableUpdateCompanionBuilder,
    (ZakaatBeneficiary, $$ZakaatBeneficiariesTableReferences),
    ZakaatBeneficiary,
    PrefetchHooks Function({bool zakaatDisbursementsRefs})> {
  $$ZakaatBeneficiariesTableTableManager(
      _$AppDatabase db, $ZakaatBeneficiariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZakaatBeneficiariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZakaatBeneficiariesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZakaatBeneficiariesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> aadhaarNumber = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> whatsapp = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              ZakaatBeneficiariesCompanion(
            id: id,
            name: name,
            address: address,
            aadhaarNumber: aadhaarNumber,
            phoneNumber: phoneNumber,
            whatsapp: whatsapp,
            notes: notes,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> address = const Value.absent(),
            Value<String?> aadhaarNumber = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> whatsapp = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              ZakaatBeneficiariesCompanion.insert(
            id: id,
            name: name,
            address: address,
            aadhaarNumber: aadhaarNumber,
            phoneNumber: phoneNumber,
            whatsapp: whatsapp,
            notes: notes,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ZakaatBeneficiariesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({zakaatDisbursementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (zakaatDisbursementsRefs) db.zakaatDisbursements
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (zakaatDisbursementsRefs)
                    await $_getPrefetchedData<ZakaatBeneficiary,
                            $ZakaatBeneficiariesTable, ZakaatDisbursement>(
                        currentTable: table,
                        referencedTable: $$ZakaatBeneficiariesTableReferences
                            ._zakaatDisbursementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ZakaatBeneficiariesTableReferences(db, table, p0)
                                .zakaatDisbursementsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.beneficiaryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ZakaatBeneficiariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ZakaatBeneficiariesTable,
    ZakaatBeneficiary,
    $$ZakaatBeneficiariesTableFilterComposer,
    $$ZakaatBeneficiariesTableOrderingComposer,
    $$ZakaatBeneficiariesTableAnnotationComposer,
    $$ZakaatBeneficiariesTableCreateCompanionBuilder,
    $$ZakaatBeneficiariesTableUpdateCompanionBuilder,
    (ZakaatBeneficiary, $$ZakaatBeneficiariesTableReferences),
    ZakaatBeneficiary,
    PrefetchHooks Function({bool zakaatDisbursementsRefs})>;
typedef $$ZakaatDisbursementsTableCreateCompanionBuilder
    = ZakaatDisbursementsCompanion Function({
  Value<int> id,
  Value<int?> beneficiaryId,
  Value<DateTime> disbursementDate,
  Value<String> disbursementType,
  required String recipientName,
  Value<String?> recipientAddress,
  Value<String?> aadhaarNumber,
  Value<String?> phoneNumber,
  required double amount,
  Value<String?> amountInWords,
  Value<String?> reason,
  Value<String?> issuingAuthorityReport,
  Value<String?> chequeNumber,
  required String paymentMode,
  Value<String?> voucherNumber,
  Value<String?> remarks,
  Value<String?> verifiedBy1,
  Value<String?> verifiedBy2,
  Value<String?> verifiedBy3,
  Value<String?> verification,
  Value<Uint8List?> recipientSignature,
  Value<Uint8List?> accountantSignature,
  Value<String> username,
});
typedef $$ZakaatDisbursementsTableUpdateCompanionBuilder
    = ZakaatDisbursementsCompanion Function({
  Value<int> id,
  Value<int?> beneficiaryId,
  Value<DateTime> disbursementDate,
  Value<String> disbursementType,
  Value<String> recipientName,
  Value<String?> recipientAddress,
  Value<String?> aadhaarNumber,
  Value<String?> phoneNumber,
  Value<double> amount,
  Value<String?> amountInWords,
  Value<String?> reason,
  Value<String?> issuingAuthorityReport,
  Value<String?> chequeNumber,
  Value<String> paymentMode,
  Value<String?> voucherNumber,
  Value<String?> remarks,
  Value<String?> verifiedBy1,
  Value<String?> verifiedBy2,
  Value<String?> verifiedBy3,
  Value<String?> verification,
  Value<Uint8List?> recipientSignature,
  Value<Uint8List?> accountantSignature,
  Value<String> username,
});

final class $$ZakaatDisbursementsTableReferences extends BaseReferences<
    _$AppDatabase, $ZakaatDisbursementsTable, ZakaatDisbursement> {
  $$ZakaatDisbursementsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ZakaatBeneficiariesTable _beneficiaryIdTable(_$AppDatabase db) =>
      db.zakaatBeneficiaries.createAlias(
          'zakaat_disbursements__beneficiary_id__zakaat_beneficiaries__id');

  $$ZakaatBeneficiariesTableProcessedTableManager? get beneficiaryId {
    final $_column = $_itemColumn<int>('beneficiary_id');
    if ($_column == null) return null;
    final manager =
        $$ZakaatBeneficiariesTableTableManager($_db, $_db.zakaatBeneficiaries)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_beneficiaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ZakaatDisbursementsTableFilterComposer
    extends Composer<_$AppDatabase, $ZakaatDisbursementsTable> {
  $$ZakaatDisbursementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get disbursementDate => $composableBuilder(
      column: $table.disbursementDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get disbursementType => $composableBuilder(
      column: $table.disbursementType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipientName => $composableBuilder(
      column: $table.recipientName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipientAddress => $composableBuilder(
      column: $table.recipientAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aadhaarNumber => $composableBuilder(
      column: $table.aadhaarNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amountInWords => $composableBuilder(
      column: $table.amountInWords, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get issuingAuthorityReport => $composableBuilder(
      column: $table.issuingAuthorityReport,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chequeNumber => $composableBuilder(
      column: $table.chequeNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voucherNumber => $composableBuilder(
      column: $table.voucherNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verifiedBy1 => $composableBuilder(
      column: $table.verifiedBy1, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verifiedBy2 => $composableBuilder(
      column: $table.verifiedBy2, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verifiedBy3 => $composableBuilder(
      column: $table.verifiedBy3, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verification => $composableBuilder(
      column: $table.verification, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get recipientSignature => $composableBuilder(
      column: $table.recipientSignature,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get accountantSignature => $composableBuilder(
      column: $table.accountantSignature,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  $$ZakaatBeneficiariesTableFilterComposer get beneficiaryId {
    final $$ZakaatBeneficiariesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.beneficiaryId,
        referencedTable: $db.zakaatBeneficiaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ZakaatBeneficiariesTableFilterComposer(
              $db: $db,
              $table: $db.zakaatBeneficiaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ZakaatDisbursementsTableOrderingComposer
    extends Composer<_$AppDatabase, $ZakaatDisbursementsTable> {
  $$ZakaatDisbursementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get disbursementDate => $composableBuilder(
      column: $table.disbursementDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get disbursementType => $composableBuilder(
      column: $table.disbursementType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipientName => $composableBuilder(
      column: $table.recipientName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipientAddress => $composableBuilder(
      column: $table.recipientAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aadhaarNumber => $composableBuilder(
      column: $table.aadhaarNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amountInWords => $composableBuilder(
      column: $table.amountInWords,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get issuingAuthorityReport => $composableBuilder(
      column: $table.issuingAuthorityReport,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chequeNumber => $composableBuilder(
      column: $table.chequeNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voucherNumber => $composableBuilder(
      column: $table.voucherNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verifiedBy1 => $composableBuilder(
      column: $table.verifiedBy1, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verifiedBy2 => $composableBuilder(
      column: $table.verifiedBy2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verifiedBy3 => $composableBuilder(
      column: $table.verifiedBy3, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verification => $composableBuilder(
      column: $table.verification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get recipientSignature => $composableBuilder(
      column: $table.recipientSignature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get accountantSignature => $composableBuilder(
      column: $table.accountantSignature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  $$ZakaatBeneficiariesTableOrderingComposer get beneficiaryId {
    final $$ZakaatBeneficiariesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.beneficiaryId,
            referencedTable: $db.zakaatBeneficiaries,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ZakaatBeneficiariesTableOrderingComposer(
                  $db: $db,
                  $table: $db.zakaatBeneficiaries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ZakaatDisbursementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZakaatDisbursementsTable> {
  $$ZakaatDisbursementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get disbursementDate => $composableBuilder(
      column: $table.disbursementDate, builder: (column) => column);

  GeneratedColumn<String> get disbursementType => $composableBuilder(
      column: $table.disbursementType, builder: (column) => column);

  GeneratedColumn<String> get recipientName => $composableBuilder(
      column: $table.recipientName, builder: (column) => column);

  GeneratedColumn<String> get recipientAddress => $composableBuilder(
      column: $table.recipientAddress, builder: (column) => column);

  GeneratedColumn<String> get aadhaarNumber => $composableBuilder(
      column: $table.aadhaarNumber, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get amountInWords => $composableBuilder(
      column: $table.amountInWords, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get issuingAuthorityReport => $composableBuilder(
      column: $table.issuingAuthorityReport, builder: (column) => column);

  GeneratedColumn<String> get chequeNumber => $composableBuilder(
      column: $table.chequeNumber, builder: (column) => column);

  GeneratedColumn<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => column);

  GeneratedColumn<String> get voucherNumber => $composableBuilder(
      column: $table.voucherNumber, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get verifiedBy1 => $composableBuilder(
      column: $table.verifiedBy1, builder: (column) => column);

  GeneratedColumn<String> get verifiedBy2 => $composableBuilder(
      column: $table.verifiedBy2, builder: (column) => column);

  GeneratedColumn<String> get verifiedBy3 => $composableBuilder(
      column: $table.verifiedBy3, builder: (column) => column);

  GeneratedColumn<String> get verification => $composableBuilder(
      column: $table.verification, builder: (column) => column);

  GeneratedColumn<Uint8List> get recipientSignature => $composableBuilder(
      column: $table.recipientSignature, builder: (column) => column);

  GeneratedColumn<Uint8List> get accountantSignature => $composableBuilder(
      column: $table.accountantSignature, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  $$ZakaatBeneficiariesTableAnnotationComposer get beneficiaryId {
    final $$ZakaatBeneficiariesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.beneficiaryId,
            referencedTable: $db.zakaatBeneficiaries,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ZakaatBeneficiariesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.zakaatBeneficiaries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ZakaatDisbursementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ZakaatDisbursementsTable,
    ZakaatDisbursement,
    $$ZakaatDisbursementsTableFilterComposer,
    $$ZakaatDisbursementsTableOrderingComposer,
    $$ZakaatDisbursementsTableAnnotationComposer,
    $$ZakaatDisbursementsTableCreateCompanionBuilder,
    $$ZakaatDisbursementsTableUpdateCompanionBuilder,
    (ZakaatDisbursement, $$ZakaatDisbursementsTableReferences),
    ZakaatDisbursement,
    PrefetchHooks Function({bool beneficiaryId})> {
  $$ZakaatDisbursementsTableTableManager(
      _$AppDatabase db, $ZakaatDisbursementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZakaatDisbursementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZakaatDisbursementsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZakaatDisbursementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> beneficiaryId = const Value.absent(),
            Value<DateTime> disbursementDate = const Value.absent(),
            Value<String> disbursementType = const Value.absent(),
            Value<String> recipientName = const Value.absent(),
            Value<String?> recipientAddress = const Value.absent(),
            Value<String?> aadhaarNumber = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> amountInWords = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> issuingAuthorityReport = const Value.absent(),
            Value<String?> chequeNumber = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String?> voucherNumber = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<String?> verifiedBy1 = const Value.absent(),
            Value<String?> verifiedBy2 = const Value.absent(),
            Value<String?> verifiedBy3 = const Value.absent(),
            Value<String?> verification = const Value.absent(),
            Value<Uint8List?> recipientSignature = const Value.absent(),
            Value<Uint8List?> accountantSignature = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              ZakaatDisbursementsCompanion(
            id: id,
            beneficiaryId: beneficiaryId,
            disbursementDate: disbursementDate,
            disbursementType: disbursementType,
            recipientName: recipientName,
            recipientAddress: recipientAddress,
            aadhaarNumber: aadhaarNumber,
            phoneNumber: phoneNumber,
            amount: amount,
            amountInWords: amountInWords,
            reason: reason,
            issuingAuthorityReport: issuingAuthorityReport,
            chequeNumber: chequeNumber,
            paymentMode: paymentMode,
            voucherNumber: voucherNumber,
            remarks: remarks,
            verifiedBy1: verifiedBy1,
            verifiedBy2: verifiedBy2,
            verifiedBy3: verifiedBy3,
            verification: verification,
            recipientSignature: recipientSignature,
            accountantSignature: accountantSignature,
            username: username,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> beneficiaryId = const Value.absent(),
            Value<DateTime> disbursementDate = const Value.absent(),
            Value<String> disbursementType = const Value.absent(),
            required String recipientName,
            Value<String?> recipientAddress = const Value.absent(),
            Value<String?> aadhaarNumber = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            required double amount,
            Value<String?> amountInWords = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> issuingAuthorityReport = const Value.absent(),
            Value<String?> chequeNumber = const Value.absent(),
            required String paymentMode,
            Value<String?> voucherNumber = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<String?> verifiedBy1 = const Value.absent(),
            Value<String?> verifiedBy2 = const Value.absent(),
            Value<String?> verifiedBy3 = const Value.absent(),
            Value<String?> verification = const Value.absent(),
            Value<Uint8List?> recipientSignature = const Value.absent(),
            Value<Uint8List?> accountantSignature = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              ZakaatDisbursementsCompanion.insert(
            id: id,
            beneficiaryId: beneficiaryId,
            disbursementDate: disbursementDate,
            disbursementType: disbursementType,
            recipientName: recipientName,
            recipientAddress: recipientAddress,
            aadhaarNumber: aadhaarNumber,
            phoneNumber: phoneNumber,
            amount: amount,
            amountInWords: amountInWords,
            reason: reason,
            issuingAuthorityReport: issuingAuthorityReport,
            chequeNumber: chequeNumber,
            paymentMode: paymentMode,
            voucherNumber: voucherNumber,
            remarks: remarks,
            verifiedBy1: verifiedBy1,
            verifiedBy2: verifiedBy2,
            verifiedBy3: verifiedBy3,
            verification: verification,
            recipientSignature: recipientSignature,
            accountantSignature: accountantSignature,
            username: username,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ZakaatDisbursementsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({beneficiaryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (beneficiaryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.beneficiaryId,
                    referencedTable: $$ZakaatDisbursementsTableReferences
                        ._beneficiaryIdTable(db),
                    referencedColumn: $$ZakaatDisbursementsTableReferences
                        ._beneficiaryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ZakaatDisbursementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ZakaatDisbursementsTable,
    ZakaatDisbursement,
    $$ZakaatDisbursementsTableFilterComposer,
    $$ZakaatDisbursementsTableOrderingComposer,
    $$ZakaatDisbursementsTableAnnotationComposer,
    $$ZakaatDisbursementsTableCreateCompanionBuilder,
    $$ZakaatDisbursementsTableUpdateCompanionBuilder,
    (ZakaatDisbursement, $$ZakaatDisbursementsTableReferences),
    ZakaatDisbursement,
    PrefetchHooks Function({bool beneficiaryId})>;
typedef $$FundAdjustmentsTableCreateCompanionBuilder = FundAdjustmentsCompanion
    Function({
  Value<int> id,
  Value<DateTime> transactionDate,
  required String adjustmentType,
  required double amount,
  required String paymentMode,
  Value<String?> chequeNumber,
  Value<String?> documentNumber,
  Value<String?> partyName,
  Value<String?> address,
  Value<String?> aadhaarNumber,
  Value<String?> phoneNumber,
  Value<String?> remarks,
  Value<String?> verifiedBy1,
  Value<String?> verifiedBy2,
  Value<String?> verifiedBy3,
  Value<String?> verification,
  Value<Uint8List?> recipientSignature,
  Value<Uint8List?> accountantSignature,
  Value<String> username,
});
typedef $$FundAdjustmentsTableUpdateCompanionBuilder = FundAdjustmentsCompanion
    Function({
  Value<int> id,
  Value<DateTime> transactionDate,
  Value<String> adjustmentType,
  Value<double> amount,
  Value<String> paymentMode,
  Value<String?> chequeNumber,
  Value<String?> documentNumber,
  Value<String?> partyName,
  Value<String?> address,
  Value<String?> aadhaarNumber,
  Value<String?> phoneNumber,
  Value<String?> remarks,
  Value<String?> verifiedBy1,
  Value<String?> verifiedBy2,
  Value<String?> verifiedBy3,
  Value<String?> verification,
  Value<Uint8List?> recipientSignature,
  Value<Uint8List?> accountantSignature,
  Value<String> username,
});

class $$FundAdjustmentsTableFilterComposer
    extends Composer<_$AppDatabase, $FundAdjustmentsTable> {
  $$FundAdjustmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adjustmentType => $composableBuilder(
      column: $table.adjustmentType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chequeNumber => $composableBuilder(
      column: $table.chequeNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentNumber => $composableBuilder(
      column: $table.documentNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partyName => $composableBuilder(
      column: $table.partyName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aadhaarNumber => $composableBuilder(
      column: $table.aadhaarNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verifiedBy1 => $composableBuilder(
      column: $table.verifiedBy1, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verifiedBy2 => $composableBuilder(
      column: $table.verifiedBy2, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verifiedBy3 => $composableBuilder(
      column: $table.verifiedBy3, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verification => $composableBuilder(
      column: $table.verification, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get recipientSignature => $composableBuilder(
      column: $table.recipientSignature,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get accountantSignature => $composableBuilder(
      column: $table.accountantSignature,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));
}

class $$FundAdjustmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $FundAdjustmentsTable> {
  $$FundAdjustmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adjustmentType => $composableBuilder(
      column: $table.adjustmentType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chequeNumber => $composableBuilder(
      column: $table.chequeNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentNumber => $composableBuilder(
      column: $table.documentNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partyName => $composableBuilder(
      column: $table.partyName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aadhaarNumber => $composableBuilder(
      column: $table.aadhaarNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remarks => $composableBuilder(
      column: $table.remarks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verifiedBy1 => $composableBuilder(
      column: $table.verifiedBy1, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verifiedBy2 => $composableBuilder(
      column: $table.verifiedBy2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verifiedBy3 => $composableBuilder(
      column: $table.verifiedBy3, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verification => $composableBuilder(
      column: $table.verification,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get recipientSignature => $composableBuilder(
      column: $table.recipientSignature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get accountantSignature => $composableBuilder(
      column: $table.accountantSignature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));
}

class $$FundAdjustmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FundAdjustmentsTable> {
  $$FundAdjustmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<String> get adjustmentType => $composableBuilder(
      column: $table.adjustmentType, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => column);

  GeneratedColumn<String> get chequeNumber => $composableBuilder(
      column: $table.chequeNumber, builder: (column) => column);

  GeneratedColumn<String> get documentNumber => $composableBuilder(
      column: $table.documentNumber, builder: (column) => column);

  GeneratedColumn<String> get partyName =>
      $composableBuilder(column: $table.partyName, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get aadhaarNumber => $composableBuilder(
      column: $table.aadhaarNumber, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<String> get verifiedBy1 => $composableBuilder(
      column: $table.verifiedBy1, builder: (column) => column);

  GeneratedColumn<String> get verifiedBy2 => $composableBuilder(
      column: $table.verifiedBy2, builder: (column) => column);

  GeneratedColumn<String> get verifiedBy3 => $composableBuilder(
      column: $table.verifiedBy3, builder: (column) => column);

  GeneratedColumn<String> get verification => $composableBuilder(
      column: $table.verification, builder: (column) => column);

  GeneratedColumn<Uint8List> get recipientSignature => $composableBuilder(
      column: $table.recipientSignature, builder: (column) => column);

  GeneratedColumn<Uint8List> get accountantSignature => $composableBuilder(
      column: $table.accountantSignature, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);
}

class $$FundAdjustmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FundAdjustmentsTable,
    FundAdjustment,
    $$FundAdjustmentsTableFilterComposer,
    $$FundAdjustmentsTableOrderingComposer,
    $$FundAdjustmentsTableAnnotationComposer,
    $$FundAdjustmentsTableCreateCompanionBuilder,
    $$FundAdjustmentsTableUpdateCompanionBuilder,
    (
      FundAdjustment,
      BaseReferences<_$AppDatabase, $FundAdjustmentsTable, FundAdjustment>
    ),
    FundAdjustment,
    PrefetchHooks Function()> {
  $$FundAdjustmentsTableTableManager(
      _$AppDatabase db, $FundAdjustmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FundAdjustmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FundAdjustmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FundAdjustmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<String> adjustmentType = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String?> chequeNumber = const Value.absent(),
            Value<String?> documentNumber = const Value.absent(),
            Value<String?> partyName = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> aadhaarNumber = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<String?> verifiedBy1 = const Value.absent(),
            Value<String?> verifiedBy2 = const Value.absent(),
            Value<String?> verifiedBy3 = const Value.absent(),
            Value<String?> verification = const Value.absent(),
            Value<Uint8List?> recipientSignature = const Value.absent(),
            Value<Uint8List?> accountantSignature = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              FundAdjustmentsCompanion(
            id: id,
            transactionDate: transactionDate,
            adjustmentType: adjustmentType,
            amount: amount,
            paymentMode: paymentMode,
            chequeNumber: chequeNumber,
            documentNumber: documentNumber,
            partyName: partyName,
            address: address,
            aadhaarNumber: aadhaarNumber,
            phoneNumber: phoneNumber,
            remarks: remarks,
            verifiedBy1: verifiedBy1,
            verifiedBy2: verifiedBy2,
            verifiedBy3: verifiedBy3,
            verification: verification,
            recipientSignature: recipientSignature,
            accountantSignature: accountantSignature,
            username: username,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            required String adjustmentType,
            required double amount,
            required String paymentMode,
            Value<String?> chequeNumber = const Value.absent(),
            Value<String?> documentNumber = const Value.absent(),
            Value<String?> partyName = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> aadhaarNumber = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> remarks = const Value.absent(),
            Value<String?> verifiedBy1 = const Value.absent(),
            Value<String?> verifiedBy2 = const Value.absent(),
            Value<String?> verifiedBy3 = const Value.absent(),
            Value<String?> verification = const Value.absent(),
            Value<Uint8List?> recipientSignature = const Value.absent(),
            Value<Uint8List?> accountantSignature = const Value.absent(),
            Value<String> username = const Value.absent(),
          }) =>
              FundAdjustmentsCompanion.insert(
            id: id,
            transactionDate: transactionDate,
            adjustmentType: adjustmentType,
            amount: amount,
            paymentMode: paymentMode,
            chequeNumber: chequeNumber,
            documentNumber: documentNumber,
            partyName: partyName,
            address: address,
            aadhaarNumber: aadhaarNumber,
            phoneNumber: phoneNumber,
            remarks: remarks,
            verifiedBy1: verifiedBy1,
            verifiedBy2: verifiedBy2,
            verifiedBy3: verifiedBy3,
            verification: verification,
            recipientSignature: recipientSignature,
            accountantSignature: accountantSignature,
            username: username,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FundAdjustmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FundAdjustmentsTable,
    FundAdjustment,
    $$FundAdjustmentsTableFilterComposer,
    $$FundAdjustmentsTableOrderingComposer,
    $$FundAdjustmentsTableAnnotationComposer,
    $$FundAdjustmentsTableCreateCompanionBuilder,
    $$FundAdjustmentsTableUpdateCompanionBuilder,
    (
      FundAdjustment,
      BaseReferences<_$AppDatabase, $FundAdjustmentsTable, FundAdjustment>
    ),
    FundAdjustment,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HouseholdsTableTableManager get households =>
      $$HouseholdsTableTableManager(_db, _db.households);
  $$HouseholdChargeHistoriesTableTableManager get householdChargeHistories =>
      $$HouseholdChargeHistoriesTableTableManager(
          _db, _db.householdChargeHistories);
  $$HouseholdMonthsTableTableManager get householdMonths =>
      $$HouseholdMonthsTableTableManager(_db, _db.householdMonths);
  $$HouseholdPaymentsTableTableManager get householdPayments =>
      $$HouseholdPaymentsTableTableManager(_db, _db.householdPayments);
  $$PaymentAllocationsTableTableManager get paymentAllocations =>
      $$PaymentAllocationsTableTableManager(_db, _db.paymentAllocations);
  $$HouseholdStatusHistoriesTableTableManager get householdStatusHistories =>
      $$HouseholdStatusHistoriesTableTableManager(
          _db, _db.householdStatusHistories);
  $$HouseholdConcessionsTableTableManager get householdConcessions =>
      $$HouseholdConcessionsTableTableManager(_db, _db.householdConcessions);
  $$HouseholdConcessionAllocationsTableTableManager
      get householdConcessionAllocations =>
          $$HouseholdConcessionAllocationsTableTableManager(
              _db, _db.householdConcessionAllocations);
  $$OpeningBalancePaymentAllocationsTableTableManager
      get openingBalancePaymentAllocations =>
          $$OpeningBalancePaymentAllocationsTableTableManager(
              _db, _db.openingBalancePaymentAllocations);
  $$OpeningBalanceConcessionAllocationsTableTableManager
      get openingBalanceConcessionAllocations =>
          $$OpeningBalanceConcessionAllocationsTableTableManager(
              _db, _db.openingBalanceConcessionAllocations);
  $$FinancialTransactionsTableTableManager get financialTransactions =>
      $$FinancialTransactionsTableTableManager(_db, _db.financialTransactions);
  $$ManualBalancesTableTableManager get manualBalances =>
      $$ManualBalancesTableTableManager(_db, _db.manualBalances);
  $$ZakaatBeneficiariesTableTableManager get zakaatBeneficiaries =>
      $$ZakaatBeneficiariesTableTableManager(_db, _db.zakaatBeneficiaries);
  $$ZakaatDisbursementsTableTableManager get zakaatDisbursements =>
      $$ZakaatDisbursementsTableTableManager(_db, _db.zakaatDisbursements);
  $$FundAdjustmentsTableTableManager get fundAdjustments =>
      $$FundAdjustmentsTableTableManager(_db, _db.fundAdjustments);
}
