import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Sticky bottom bar: total on the left, Proceed to Buy on the right.
class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    required this.total,
    required this.countLabel,
    required this.onProceed,
  });

  final double total;
  final String countLabel;
  final VoidCallback onProceed;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 12, offset: const Offset(0, -3))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₹${_money.format(total)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  Text('${t('cart.total')} · $countLabel', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            SizedBox(
              width: 170,
              child: ElevatedButton(onPressed: onProceed, child: Text(t('cart.proceed_to_buy'))),
            ),
          ],
        ),
      ),
    );
  }
}
