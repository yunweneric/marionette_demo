import 'package:flutter/material.dart';
import 'package:marionette_demo/core/theme.dart';

/// Demo 02 — where a successful sign-in lands.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            key: const Key('dashboard_logout_button'),
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Hello, $displayName',
            key: const Key('dashboard_greeting'),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: DemoTheme.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Here is where your money stands today.',
            style: TextStyle(fontSize: 15, color: DemoTheme.muted),
          ),
          const SizedBox(height: 20),
          const _BalanceCard(),
          const SizedBox(height: 24),
          const Text(
            'Quick actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: DemoTheme.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _QuickAction(
                  key: Key('dashboard_action_send'),
                  icon: Icons.north_east,
                  label: 'Send',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QuickAction(
                  key: Key('dashboard_action_request'),
                  icon: Icons.south_west,
                  label: 'Request',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QuickAction(
                  key: Key('dashboard_action_top_up'),
                  icon: Icons.add,
                  label: 'Top up',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('dashboard_balance_card'),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: DemoTheme.seed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Available balance',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 6),
          Text(
            '482 300 FCFA',
            key: Key('dashboard_balance_amount'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(content: Text('$label is not part of this demo')),
          );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: DemoTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: DemoTheme.seed),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: DemoTheme.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
