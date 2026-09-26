import 'package:flutter/material.dart';
import 'package:marionette_demo/core/theme.dart';
import 'package:marionette_demo/features/transactions/transaction.dart';

/// The dashboard's recent-activity section, with the filter chips the support
/// ticket in DEMO.md is about.
///
/// Three keys matter to the agent here: `transactions_filter_all`,
/// `transactions_filter_income` and `transactions_filter_expenses`, built
/// from the enum so they cannot drift from the labels. Each row is keyed by
/// transaction id, so "which rows are on screen" is a cheap question —
/// `get_interactive_elements`, no screenshot needed.
class TransactionList extends StatefulWidget {
  const TransactionList({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  TransactionFilter _filter = TransactionFilter.all;

  List<Transaction> get _visible =>
      widget.transactions.where((t) => _matches(t, _filter)).toList();

  bool _matches(Transaction transaction, TransactionFilter filter) {
    switch (filter) {
      case TransactionFilter.all:
        return true;
      case TransactionFilter.income:
        return transaction.amount.isNegative;
      case TransactionFilter.expenses:
        return !transaction.amount.isNegative;
    }
  }

  /// The header figure, computed straight from [Transaction.isIncome] rather
  /// than through [_matches]. Two independent readings of the same idea: if
  /// they ever disagree on screen, one of them is wrong.
  int get _monthIncome => widget.transactions
      .where((t) => t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    debugPrint(
      '[transactions] filter=${_filter.label} showing=${visible.length} rows',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              'Recent activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DemoTheme.ink,
              ),
            ),
            const Spacer(),
            Text(
              'In this month: ${_money(_monthIncome)}',
              key: const Key('transactions_month_income'),
              style: const TextStyle(fontSize: 13, color: DemoTheme.muted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (final filter in TransactionFilter.values) ...[
              ChoiceChip(
                key: Key('transactions_filter_${filter.name}'),
                label: Text(filter.label),
                selected: _filter == filter,
                onSelected: (_) => setState(() => _filter = filter),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 4),
        if (visible.isEmpty)
          const Padding(
            key: Key('transactions_empty'),
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Text(
              'Nothing here for this filter.',
              style: TextStyle(color: DemoTheme.muted),
            ),
          )
        else
          for (final transaction in visible)
            _TransactionRow(transaction: transaction),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final income = transaction.isIncome;
    return Padding(
      key: Key('transaction_row_${transaction.id}'),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: DemoTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              income ? Icons.south_west : Icons.north_east,
              size: 20,
              color: income ? DemoTheme.positive : DemoTheme.negative,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: DemoTheme.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.category} · ${transaction.day}',
                  style: const TextStyle(fontSize: 13, color: DemoTheme.muted),
                ),
              ],
            ),
          ),
          Text(
            _money(transaction.amount),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: income ? DemoTheme.positive : DemoTheme.ink,
            ),
          ),
        ],
      ),
    );
  }
}

String _money(int amount) {
  final sign = amount > 0 ? '+' : '−';
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }
  return '$sign$buffer FCFA';
}
