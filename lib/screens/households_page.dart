import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;

import '../database/app_database.dart';
import 'household_fee_card_page.dart';

const List<String> _parentageTypes = [
  'S/O',
  'D/O',
  'W/O',
  'SL/O',
  'Other',
];

String _titleCase(String value) {
  return value
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map((word) {
        if (word.length == 1) return word.toUpperCase();
        return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      })
      .join(' ');
}

String _formatParentage(String type, String name) {
  final formattedName = _titleCase(name);
  if (formattedName.isEmpty) return '';
  return '$type: $formattedName';
}

class HouseholdsPage extends StatefulWidget {
  final AppDatabase database;

  const HouseholdsPage({
    super.key,
    required this.database,
  });

  @override
  State<HouseholdsPage> createState() => _HouseholdsPageState();
}

class _HouseholdsPageState extends State<HouseholdsPage> {
  late Future<List<Household>> _households;
  final TextEditingController _searchController =
      TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadHouseholds();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadHouseholds() {
    _households =
        widget.database.select(widget.database.households).get();
  }

  Future<double> _getSignedBalance(Household household) async {
    double balance = household.openingBalanceType == 'ADVANCE'
        ? -household.openingBalance
        : household.openingBalance;

    double openingAllocated = 0;
    if (household.openingBalanceType == 'DUE' && household.openingBalance > 0) {
      final openingPayments = await (widget.database
            .select(widget.database.openingBalancePaymentAllocations)
          ..where((a) => a.householdId.equals(household.id)))
          .get();
      final openingConcessions = await (widget.database
            .select(widget.database.openingBalanceConcessionAllocations)
          ..where((a) => a.householdId.equals(household.id)))
          .get();
      for (final a in openingPayments) {
        openingAllocated += a.amount;
        balance -= a.amount;
      }
      for (final a in openingConcessions) {
        balance -= a.amount;
      }
    }

    double monthlyAllocated = 0;
    final months = await (widget.database
          .select(widget.database.householdMonths)
        ..where((m) => m.householdId.equals(household.id)))
        .get();
    for (final month in months) {
      balance += month.charge;
      final payments = await (widget.database
            .select(widget.database.paymentAllocations)
          ..where((p) => p.householdMonthId.equals(month.id)))
          .get();
      for (final p in payments) {
        monthlyAllocated += p.amount;
        balance -= p.amount;
      }
      final concessions = await (widget.database
            .select(widget.database.householdConcessionAllocations)
          ..where((c) => c.householdMonthId.equals(month.id)))
          .get();
      double allocatedConcession = 0;
      for (final c in concessions) {
        allocatedConcession += c.amount;
        balance -= c.amount;
      }
      if (allocatedConcession == 0) balance -= month.concession;
    }

    final actualPayments = await (widget.database
          .select(widget.database.householdPayments)
        ..where((p) => p.householdId.equals(household.id)))
        .get();
    final actualPaid = actualPayments.fold<double>(0, (sum, p) => sum + p.amount);
    final unallocated = actualPaid - openingAllocated - monthlyAllocated;
    if (unallocated > 0) balance -= unallocated;

    return balance;
  }

  Future<void> _addHousehold() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AddHouseholdDialog(
        database: widget.database,
      ),
    );

    if (result == true) {
      setState(_loadHouseholds);
    }
  }

  Future<void> _editHousehold(Household household) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditHouseholdDialog(
        database: widget.database,
        household: household,
      ),
    );

    if (result == true) {
      setState(_loadHouseholds);
    }
  }

  Future<void> _openFeeCard(Household household) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HouseholdFeeCardPage(
          database: widget.database,
          household: household,
        ),
      ),
    );

    if (!mounted) return;
    setState(_loadHouseholds);
  }

  Future<void> _showSearchDialog() async {
    _searchController.text = _searchText;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Search Member'),
          content: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Name, parentage or Member ID',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => _searchText = value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      // Keep both primary actions permanently visible on phones.
      // The Add Household action is deliberately in the bottom bar rather
      // than relying only on a floating action button, so it cannot be
      // hidden/covered by the device navigation area.
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _showSearchDialog,
                  icon: const Icon(Icons.search, size: 20),
                  label: const Text('Search'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _addHousehold,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add Member'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Household>>(
              future: _households,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Error loading households:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final allHouseholds = snapshot.data ?? [];

                if (allHouseholds.isEmpty) {
                  return const Center(
                    child: Text(
                      'No members added yet.\n\n'
                      'Tap + to add the first member.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final query = _searchText.trim().toLowerCase();
                final households = allHouseholds.where((household) {
                  if (query.isEmpty) return true;
                  return household.name.toLowerCase().contains(query) ||
                      (household.parentage ?? '')
                          .toLowerCase()
                          .contains(query) ||
                      household.id.toString().contains(query);
                }).toList();

                if (households.isEmpty) {
                  return const Center(
                    child: Text('No matching member found.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: households.length,
                  itemBuilder: (context, index) {
                    final household = households[index];
                    final cardColor = index.isEven
                        ? Theme.of(context).colorScheme.surface
                        : Colors.grey.shade100;

                    return Card(
                      color: cardColor,
                      child: FutureBuilder<double>(
                        future: _getSignedBalance(household),
                        builder: (context, balanceSnapshot) {
                          final signedBalance = balanceSnapshot.data ?? 0;
                           final isAdvance = signedBalance < 0;
                           final amount = signedBalance.abs();
                          return ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -1),
                            leading: CircleAvatar(
                              child: Text('${household.id}'),
                            ),
                            title: Text(
                              household.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if ((household.parentage ?? '').trim().isNotEmpty)
                                  Text(
                                    household.parentage!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Monthly: ₹${household.monthlyCharge.toStringAsFixed(2)}',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${isAdvance ? 'Advance' : 'Outstanding'}: ₹${amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: isAdvance ? Colors.blue.shade800 : Colors.red,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit household',
                              onPressed: () => _editHousehold(household),
                            ),
                            onTap: () => _openFeeCard(household),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// ADD HOUSEHOLD
// ============================================================

class AddHouseholdDialog extends StatefulWidget {
  final AppDatabase database;

  const AddHouseholdDialog({
    super.key,
    required this.database,
  });

  @override
  State<AddHouseholdDialog> createState() => _AddHouseholdDialogState();
}

class _AddHouseholdDialogState extends State<AddHouseholdDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _parentageController = TextEditingController();
  final _addressController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _monthlyChargeController = TextEditingController();
  final _openingBalanceController = TextEditingController();

  DateTime _startDate = DateTime.now();

  String _parentageType = 'S/O';
  String _openingBalanceType = 'DUE';

  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _parentageController.dispose();
    _addressController.dispose();
    _whatsappController.dispose();
    _monthlyChargeController.dispose();
    _openingBalanceController.dispose();

    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      helpText: 'Select member start date',
    );

    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  Future<void> _saveHousehold() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final monthlyCharge =
        double.tryParse(
          _monthlyChargeController.text.trim(),
        ) ??
        0.0;

    final openingBalance =
        double.tryParse(
          _openingBalanceController.text.trim(),
        ) ??
        0.0;

    try {
      final householdId = await widget.database
          .into(widget.database.households)
          .insert(
            HouseholdsCompanion.insert(
              name: _nameController.text.trim(),

              parentage: Value(
                _parentageController.text.trim().isEmpty
                    ? null
                    : _parentageController.text.trim(),
              ),

              address: Value(
                _addressController.text.trim().isEmpty
                    ? null
                    : _addressController.text.trim(),
              ),

              whatsapp: Value(
                _whatsappController.text.trim().isEmpty
                    ? null
                    : _whatsappController.text.trim(),
              ),

              monthlyCharge: Value(
                monthlyCharge,
              ),

              joinedDate: Value(
                _startDate,
              ),

              openingBalance: Value(
                openingBalance,
              ),

              openingBalanceType: Value(
                _openingBalanceType,
              ),
            ),
          );

      await widget.database
          .into(widget.database.householdStatusHistories)
          .insert(
            HouseholdStatusHistoriesCompanion.insert(
              householdId: householdId,
              status: 'STARTED',
              eventDate: _startDate,
            ),
          );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not save household:\n$e',
            ),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Member'),

      content: SizedBox(
        width: 450,

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter the member name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: _parentageType,
                  decoration: const InputDecoration(
                    labelText: 'Parentage Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _parentageTypes
                      .map(
                        (type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _parentageType = value);
                    }
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _parentageController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Parentage Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _whatsappController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'WhatsApp Number',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _monthlyChargeController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Monthly Charge',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter the monthly charge';
                    }

                    final number =
                        double.tryParse(value.trim());

                    if (number == null || number < 0) {
                      return 'Enter a valid amount';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                InkWell(
                  onTap: _selectStartDate,

                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                    ),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(_startDate),
                        ),
                        const Icon(
                          Icons.calendar_month,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller:
                      _openingBalanceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration:
                      const InputDecoration(
                    labelText: 'Opening Balance',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return null;
                    }

                    final number =
                        double.tryParse(value.trim());

                    if (number == null || number < 0) {
                      return 'Enter a valid amount';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Opening Balance Type',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall,
                  ),
                ),

                RadioListTile<String>(
                  title: const Text('Due'),
                  value: 'DUE',
                  groupValue:
                      _openingBalanceType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _openingBalanceType =
                            value;
                      });
                    }
                  },
                  contentPadding:
                      EdgeInsets.zero,
                ),

                RadioListTile<String>(
                  title: const Text('Advance'),
                  value: 'ADVANCE',
                  groupValue:
                      _openingBalanceType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _openingBalanceType =
                            value;
                      });
                    }
                  },
                  contentPadding:
                      EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: _saving
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed:
              _saving ? null : _saveHousehold,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}


// ============================================================
// EDIT HOUSEHOLD
// ============================================================

class EditHouseholdDialog extends StatefulWidget {
  final AppDatabase database;
  final Household household;

  const EditHouseholdDialog({
    super.key,
    required this.database,
    required this.household,
  });

  @override
  State<EditHouseholdDialog> createState() =>
      _EditHouseholdDialogState();
}

class _EditHouseholdDialogState
    extends State<EditHouseholdDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _parentageController;
  late final TextEditingController _addressController;
  late final TextEditingController _whatsappController;
  late final TextEditingController _monthlyChargeController;
  late final TextEditingController _openingBalanceController;

  late DateTime _startDate;
  late String _parentageType;
  late String _openingBalanceType;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(
      text: widget.household.name,
    );

    final storedParentage = widget.household.parentage ?? '';
    _parentageType = 'S/O';
    var parentageName = storedParentage;

    for (final type in _parentageTypes) {
      final prefix = '$type:';
      if (storedParentage.toUpperCase().startsWith(prefix)) {
        _parentageType = type;
        parentageName = storedParentage.substring(prefix.length).trim();
        break;
      }
    }

    _parentageController =
        TextEditingController(
      text: parentageName,
    );

    _addressController =
        TextEditingController(
      text: widget.household.address ?? '',
    );

    _whatsappController =
        TextEditingController(
      text: widget.household.whatsapp ?? '',
    );

    _monthlyChargeController =
        TextEditingController(
      text: widget.household.monthlyCharge
          .toStringAsFixed(2),
    );

    _openingBalanceController =
        TextEditingController(
      text: widget.household.openingBalance
          .toStringAsFixed(2),
    );

    _startDate =
        widget.household.joinedDate;

    _openingBalanceType =
        widget.household.openingBalanceType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _parentageController.dispose();
    _addressController.dispose();
    _whatsappController.dispose();
    _monthlyChargeController.dispose();
    _openingBalanceController.dispose();

    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final selectedDate =
        await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      helpText: 'Select member start date',
    );

    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final monthlyCharge =
        double.tryParse(
          _monthlyChargeController.text.trim(),
        ) ??
        0.0;

    final openingBalance =
        double.tryParse(
          _openingBalanceController.text.trim(),
        ) ??
        0.0;

    try {
      await (widget.database.update(
        widget.database.households,
      )..where(
          (h) => h.id.equals(widget.household.id),
        ))
          .write(
        HouseholdsCompanion(
          name: Value(
            _titleCase(_nameController.text),
          ),
          parentage: Value(
            _formatParentage(
              _parentageType,
              _parentageController.text,
            ).isEmpty
                ? null
                : _formatParentage(
                    _parentageType,
                    _parentageController.text,
                  ),
          ),
          address: Value(
            _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
          ),
          whatsapp: Value(
            _whatsappController.text.trim().isEmpty
                ? null
                : _whatsappController.text.trim(),
          ),
          monthlyCharge: Value(
            monthlyCharge,
          ),
          joinedDate: Value(
            _startDate,
          ),
          openingBalance: Value(
            openingBalance,
          ),
          openingBalanceType: Value(
            _openingBalanceType,
          ),
        ),
      );

      // Keep the original STARTED event consistent
      // while we are still in development.
      final startedEvent =
          await (widget.database.select(
        widget.database.householdStatusHistories,
      )..where(
          (s) =>
              s.householdId.equals(widget.household.id) &
              s.status.equals('STARTED'),
        )
              ..orderBy([
                (s) => OrderingTerm(
                      expression: s.eventDate,
                    ),
              ])
              ..limit(1))
          .getSingleOrNull();

      if (startedEvent != null) {
        await (widget.database.update(
          widget.database.householdStatusHistories,
        )..where(
            (s) => s.id.equals(startedEvent.id),
          ))
            .write(
          HouseholdStatusHistoriesCompanion(
            eventDate: Value(_startDate),
          ),
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              'Could not update household:\n$e',
            ),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Member'),

      content: SizedBox(
        width: 450,

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter the member name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: _parentageType,
                  decoration: const InputDecoration(
                    labelText: 'Parentage Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _parentageTypes
                      .map(
                        (type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _parentageType = value);
                    }
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _parentageController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Parentage Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller:
                      _addressController,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller:
                      _whatsappController,
                  keyboardType:
                      TextInputType.phone,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'WhatsApp Number',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller:
                      _monthlyChargeController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Monthly Charge',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final number =
                        double.tryParse(
                      value?.trim() ?? '',
                    );

                    if (number == null ||
                        number < 0) {
                      return 'Enter a valid amount';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                InkWell(
                  onTap: _selectStartDate,

                  child: InputDecorator(
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Start Date',
                      border:
                          OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          _formatDate(
                            _startDate,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_month,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller:
                      _openingBalanceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Opening Balance',
                    prefixText: '₹ ',
                    border:
                        OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final number =
                        double.tryParse(
                      value?.trim() ?? '',
                    );

                    if (number == null ||
                        number < 0) {
                      return 'Enter a valid amount';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                Align(
                  alignment:
                      Alignment.centerLeft,
                  child: Text(
                    'Opening Balance Type',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall,
                  ),
                ),

                RadioListTile<String>(
                  title: const Text('Due'),
                  value: 'DUE',
                  groupValue:
                      _openingBalanceType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _openingBalanceType =
                            value;
                      });
                    }
                  },
                  contentPadding:
                      EdgeInsets.zero,
                ),

                RadioListTile<String>(
                  title:
                      const Text('Advance'),
                  value: 'ADVANCE',
                  groupValue:
                      _openingBalanceType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _openingBalanceType =
                            value;
                      });
                    }
                  },
                  contentPadding:
                      EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: _saving
              ? null
              : () {
                  Navigator.pop(
                    context,
                  );
                },
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed:
              _saving ? null : _saveChanges,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Save Changes'),
        ),
      ],
    );
  }
}