import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Dealer's available credit, with a warning when the cart is over it.
class CreditBanner extends StatelessWidget {
  const CreditBanner({
    super.key,
    required this.available,
    required this.exceeds,
    required this.orderTotal,
  });

  /// Null when the dealer has no credit limit.
  final double? available;
  final bool exceeds;
  final double orderTotal;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    final credit = available;
    if (credit == null) return const SizedBox.shrink();

    final color = exceeds ? AppColors.danger : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: .3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(exceeds ? Icons.warning_amber_rounded : Icons.account_balance_wallet_outlined, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${t('cart.available_credit')} ₹${_money.format(credit)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
                if (exceeds)
                  Text(
                    'This order is ₹${_money.format(orderTotal - credit)} over your available credit and may need approval.',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.danger, height: 1.35),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
