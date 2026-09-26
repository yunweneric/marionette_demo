/// One line of money movement. A positive [amount] came in, a negative one
/// went out — the sign is the only thing that says which, which is exactly
/// the kind of convention a filter gets wrong.
class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.day,
  });

  final String id;
  final String title;
  final String category;
  final int amount;
  final String day;

  bool get isIncome => amount > 0;
}

enum TransactionFilter {
  all('All'),
  income('Income'),
  expenses('Expenses');

  const TransactionFilter(this.label);

  final String label;
}

/// Fixed data, never shuffled and never fetched: the same six rows every
/// launch, so the presenter knows what the screen should say and the agent's
/// report can be checked against it live.
///
/// Three income rows and three expense rows, so a filter that inverts them
/// returns a plausible-looking list rather than an obviously empty one. A bug
/// that shows nothing is spotted in a second; a bug that shows the wrong
/// three rows is the one that reaches production.
const demoTransactions = <Transaction>[
  Transaction(
    id: 't1',
    title: 'Salary — September',
    category: 'Income',
    amount: 250000,
    day: 'Today',
  ),
  Transaction(
    id: 't2',
    title: 'Rent',
    category: 'Housing',
    amount: -120000,
    day: 'Today',
  ),
  Transaction(
    id: 't3',
    title: 'Client invoice #204',
    category: 'Income',
    amount: 85000,
    day: 'Yesterday',
  ),
  Transaction(
    id: 't4',
    title: 'Groceries — Mahima',
    category: 'Food',
    amount: -18400,
    day: 'Yesterday',
  ),
  Transaction(
    id: 't5',
    title: 'Internet — Camtel',
    category: 'Utilities',
    amount: -25000,
    day: 'Mon',
  ),
  Transaction(
    id: 't6',
    title: 'Refund — Jumia',
    category: 'Income',
    amount: 12600,
    day: 'Mon',
  ),
];
