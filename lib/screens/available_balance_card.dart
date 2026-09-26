import 'package:flutter/material.dart';

class AvailableBalanceCard extends StatelessWidget {
  final String label;
  final Future<double> future;

  const AvailableBalanceCard({
    super.key,
    required this.label,
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<double>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.account_balance_wallet_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(label),
              trailing: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.account_balance_wallet_outlined,
                color: theme.colorScheme.error,
              ),
              title: Text(label),
              subtitle: const Text('Unable to calculate the current balance.'),
            ),
          );
        }

        final balance = snapshot.data ?? 0;
        return Card(
          elevation: 1,
          child: ListTile(
            leading: Icon(
              Icons.account_balance_wallet_outlined,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text('Available before this transaction'),
            trailing: Text(
              '₹${balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: balance > 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }
}
