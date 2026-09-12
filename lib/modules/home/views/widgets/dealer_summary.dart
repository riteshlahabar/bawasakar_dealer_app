import 'package:flutter/material.dart';

import 'summary_card.dart';

/// Row of credit limit / outstanding / pending order summary tiles.
class DealerSummary extends StatelessWidget {
  const DealerSummary({
    super.key,
    required this.creditLimit,
    required this.outstanding,
    required this.pendingOrders,
  });

  final String creditLimit;
  final String outstanding;
  final String pendingOrders;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: SummaryCard(
              title: 'Credit Limit',
              value: creditLimit,
              icon: Icons.account_balance_wallet_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SummaryCard(
              title: 'Outstanding',
              value: outstanding,
              icon: Icons.payments_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SummaryCard(
              title: 'Pending',
              value: pendingOrders,
              icon: Icons.pending_actions_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
