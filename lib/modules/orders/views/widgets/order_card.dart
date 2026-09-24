import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/models/order_model.dart';
import '../../../../app/theme/app_colors.dart';
import 'order_status_chip.dart';
import 'stacked_thumbnails.dart';
import '../../../../app/localization/t.dart';

/// One order: coloured status headline, stacked product images (with pack
/// size and quantity, not just the name), and the actions that apply to it,
/// laid out as a full-width grid instead of a loosely wrapped row.
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTrack,
    required this.onDetails,
    this.onBuyAgain,
    this.onReturn,
    this.onInvoice,
    this.onCancel,
  });

  final OrderModel order;
  final VoidCallback onTrack;
  final VoidCallback onDetails;
  final VoidCallback? onBuyAgain;
  final VoidCallback? onReturn;
  final VoidCallback? onInvoice;
  final VoidCallback? onCancel;

  static final _money = NumberFormat.decimalPattern('en_IN');
  static const _actionsPerRow = 3;

  @override
  Widget build(BuildContext context) {
    final style = OrderStatusChip.styleFor(order.status.toLowerCase());
    final summaries = order.itemSummaries;
    final itemsLabel = order.itemCount == 0 ? t('orders.order_items') : (order.itemCount == 1 ? t('common.item_count_one', {'n': '${order.itemCount}'}) : t('common.item_count_many', {'n': '${order.itemCount}'}));

    final actions = [
      _action(t('orders.track_short'), Icons.local_shipping_outlined, onTrack, filled: true),
      _action(t('orders.details'), Icons.receipt_long_outlined, onDetails),
      if (onBuyAgain != null) _action(t('common.buy_again'), Icons.replay_rounded, onBuyAgain!),
      if (onReturn != null) _action(t('orders.return'), Icons.assignment_return_outlined, onReturn!),
      if (onInvoice != null) _action(t('orders.invoice'), Icons.description_outlined, onInvoice!),
      if (onCancel != null) _action(t('orders.cancel_order'), Icons.close_rounded, onCancel!, danger: true),
    ];

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
            border: Border.all(color: AppColors.primary.withValues(alpha: .35)),
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
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.receipt_long_rounded, size: 12, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${order.orderNo} · ${order.displayDate}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StackedThumbnails(urls: order.imageUrls),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: summaries.isEmpty
                          ? [Text(itemsLabel, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary))]
                          : [
                              for (final line in summaries.take(2))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    line,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              if (summaries.length > 2)
                                Text(
                                  '+${summaries.length - 2} more',
                                  style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700),
                                ),
                            ],
                    ),
                  ),
                ],
              ),
              // What the salesman answered about stock while reviewing the
              // order. Not a status — the order is still in review.
              if (order.availabilityLabel.isNotEmpty) ...[
                const SizedBox(height: 10),
                _availabilityNote(),
              ],
              const SizedBox(height: 12),
              Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 12),
              _actionsGrid(actions),
            ],
          ),
        ),
      ),
    );
  }

  /// Amber when stock is unavailable, brand green when a date has been promised.
  Widget _availabilityNote() {
    final waiting = order.availability == 'available_on';
    final color = waiting ? AppColors.primary : AppColors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Row(
        children: [
          Icon(
            waiting
                ? Icons.event_available_outlined
                : Icons.remove_shopping_cart_outlined,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              order.availabilityLabel,
              style: TextStyle(
                fontSize: 11.5,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
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

  /// Rows of equal-width buttons that always cover the card's full width,
  /// instead of a `Wrap` that leaves an uneven gap on the last line.
  Widget _actionsGrid(List<Widget> actions) {
    final rows = <Widget>[];

    for (var i = 0; i < actions.length; i += _actionsPerRow) {
      final rowItems = actions.sublist(i, (i + _actionsPerRow).clamp(0, actions.length));

      if (rows.isNotEmpty) rows.add(const SizedBox(height: 8));

      rows.add(
        Row(
          children: [
            for (var j = 0; j < rowItems.length; j++) ...[
              if (j > 0) const SizedBox(width: 8),
              Expanded(child: rowItems[j]),
            ],
          ],
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _action(String label, IconData icon, VoidCallback onTap, {bool filled = false, bool danger = false}) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 15),
        const SizedBox(width: 5),
        Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600))),
      ],
    );

    return SizedBox(
      height: 36,
      child: filled
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6)),
              child: content,
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                foregroundColor: danger ? AppColors.danger : null,
                side: danger ? const BorderSide(color: AppColors.danger) : null,
              ),
              child: content,
            ),
    );
  }
}
