import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/services/cart_service.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// MRP total, discount and cart total, with a "You will save" banner.
class CartPriceDetails extends StatelessWidget {
  const CartPriceDetails({super.key, required this.cart});

  final CartService cart;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t('cart.price_details'), style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          _row(t('cart.price_items', {'n': '${cart.totalItems}'}), '₹${_money.format(cart.mrpTotal)}'),
          if (cart.savings > 0) _row(t('invoice.discount'), '- ₹${_money.format(cart.savings)}', color: AppColors.success),
          const Divider(height: 22, color: AppColors.border),
          _row(t('cart.total_amount'), '₹${_money.format(cart.subtotal)}', bold: true),
          if (cart.savings > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                t('cart.will_save', {'amount': '₹${_money.format(cart.savings)}'}),
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.success),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            t('cart.gst_note'),
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: bold ? 14 : 12.5, fontWeight: bold ? FontWeight.w800 : FontWeight.w500, color: bold ? AppColors.textPrimary : AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: bold ? 16 : 13, fontWeight: bold ? FontWeight.w900 : FontWeight.w700, color: color ?? AppColors.textPrimary)),
        ],
      ),
    );
  }
}
