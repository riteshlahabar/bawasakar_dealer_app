import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/models/order_model.dart';
import '../../../../app/theme/app_colors.dart';
import 'order_status_chip.dart';
import 'stacked_thumbnails.dart';
import '../../../../app/localization/t.dart';

/// One order: coloured status headline, stacked product images, total, and
/// the actions that apply to its status.
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTrack,
    required this.onDetails,
    this.onBuyAgain,
    this.onReturn,
    this.onInvoice,
  });

  final OrderModel order;
  final VoidCallback onTrack;
  final VoidCallback onDetails;
  final VoidCallback? onBuyAgain;
  final VoidCallback? onReturn;
  final VoidCallback? onInvoice;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    final style = OrderStatusChip.styleFor(order.status.toLowerCase());
    final itemsLabel = order.itemCount == 0 ? t('orders.order_items') : (order.itemCount == 1 ? t('common.item_count_one', {'n': '${order.itemCount}'}) : t('common.item_count_many', {'n': '${order.itemCount}'}));

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTrack,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(style.icon, color: style.color, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _headline(style.label),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: style.color),
                    ),
                  ),
                  Text('₹${_money.format(order.total)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${order.orderNo} · ${order.displayDate}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  StackedThumbnails(urls: order.imageUrls),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (order.productNames.isNotEmpty)
                          Text(
                            order.productNames.join(', '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                          ),
                        const SizedBox(height: 2),
                        Text(itemsLabel, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _action(t('orders.track_short'), Icons.local_shipping_outlined, onTrack, filled: true),
                  _action(t('orders.details'), Icons.receipt_long_outlined, onDetails),
                  if (onBuyAgain != null) _action(t('common.buy_again'), Icons.replay_rounded, onBuyAgain!),
                  if (onReturn != null) _action(t('orders.return'), Icons.assignment_return_outlined, onReturn!),
                  if (onInvoice != null) _action(t('orders.invoice'), Icons.description_outlined, onInvoice!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _headline(String label) {
    return switch (order.status.toLowerCase()) {
      'delivered' => order.deliveredLabel.isEmpty ? t('orders.delivered') : t('orders.delivered_on', {'date': order.deliveredLabel}),
      'out_for_delivery' => t('orders.out_for_delivery_short'),
      'dispatched' || 'shipped' => t('orders.arriving_soon'),
      'packing' || 'packed' => t('orders.being_packed'),
      'approved' => t('orders.confirmed'),
      _ => label,
    };
  }

  Widget _action(String label, IconData icon, VoidCallback onTap, {bool filled = false}) {
    const padding = EdgeInsets.symmetric(horizontal: 12);
    const size = Size(0, 34);
    const textStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

    return SizedBox(
      height: 34,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(minimumSize: size, padding: padding, textStyle: textStyle),
              icon: Icon(icon, size: 16),
              label: Text(label),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(minimumSize: size, padding: padding, textStyle: textStyle),
              icon: Icon(icon, size: 16),
              label: Text(label),
            ),
    );
  }
}
