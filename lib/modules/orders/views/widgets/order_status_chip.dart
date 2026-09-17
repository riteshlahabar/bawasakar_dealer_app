import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Coloured status badge for an order.
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final style = styleFor(status.toLowerCase());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 12, color: style.color),
          const SizedBox(width: 4),
          Text(
            style.label,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: style.color),
          ),
        ],
      ),
    );
  }

  /// Label, colour and icon for a (lower-case) order status.
  static ({String label, Color color, IconData icon}) styleFor(String value) {
    return switch (value) {
      'salesman_review' || 'admin_review' || 'pending' => (label: t('orders.under_review'), color: AppColors.orange, icon: Icons.hourglass_top_rounded),
      'approved' => (label: t('orders.approved'), color: AppColors.primary, icon: Icons.verified_rounded),
      'packing' || 'packed' => (label: t('orders.packing'), color: const Color(0xFFB7791F), icon: Icons.inventory_2_rounded),
      'dispatched' || 'shipped' => (label: t('orders.dispatched'), color: const Color(0xFF2972FF), icon: Icons.local_shipping_rounded),
      'out_for_delivery' => (label: t('orders.out_for_delivery'), color: const Color(0xFF7C3AED), icon: Icons.delivery_dining_rounded),
      'delivered' => (label: t('orders.delivered'), color: AppColors.success, icon: Icons.task_alt_rounded),
      'cancelled' || 'rejected' => (label: t('orders.cancelled'), color: AppColors.danger, icon: Icons.cancel_rounded),
      _ => (label: value.replaceAll('_', ' ').capitalizeFirst ?? value, color: AppColors.textSecondary, icon: Icons.info_outline_rounded),
    };
  }
}
