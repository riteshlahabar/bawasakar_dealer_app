import 'package:flutter/material.dart';

import 'summary_card.dart';
import '../../../../app/localization/t.dart';

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
              title: t('home.credit_limit'),
              value: creditLimit,
              icon: Icons.account_balance_wallet_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SummaryCard(
              title: t('home.outstanding'),
              value: outstanding,
              icon: Icons.payments_outlined,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SummaryCard(
              title: t('home.pending'),
              value: pendingOrders,
              icon: Icons.pending_actions_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
