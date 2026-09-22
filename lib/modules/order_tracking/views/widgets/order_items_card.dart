import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/models/order_detail_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';
import 'tracking_section_card.dart';
import '../../../../app/localization/t.dart';

/// Ordered products with thumbnail, variant, quantity and line total.
class OrderItemsCard extends StatelessWidget {
  const OrderItemsCard({super.key, required this.detail});

  final OrderDetailModel detail;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    final items = detail.items;

    return TrackingSectionCard(
      title: '${t('tracking.items')} (${items.length})',
      icon: Icons.shopping_bag_rounded,
      child: items.isEmpty
          ? Text(t('common.no_items'), style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5))
          : Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const Divider(height: 22, color: AppColors.border),
                  _row(items[i]),
                ],
              ],
            ),
    );
  }

  Widget _row(OrderItemDetailModel item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 56,
            height: 56,
            child: ProductImage(imageUrl: item.imageUrl, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              if (item.variantName.isNotEmpty)
                Text(item.variantName, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(item.quantityLabel, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${_money.format(item.lineTotal)}',
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
            ),
            Text(
              'Price ₹${_money.format(item.unitPrice)}',
              style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
