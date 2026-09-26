import 'package:flutter/material.dart';

import '../database/app_database.dart';
import 'financial_entry_page.dart';

class GeneralDonationPage extends StatelessWidget {
  final AppDatabase database;
  const GeneralDonationPage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return FinancialEntryPage(
      database: database,
      title: 'General Donation',
      category: 'GD',
      receiptPrefix: 'GD',
      typeLabel: 'General Donation',
    );
  }
}
