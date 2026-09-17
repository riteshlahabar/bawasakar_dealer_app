import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/models/order_detail_model.dart';
import '../../../../app/data/models/tracking_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../orders/views/widgets/order_status_chip.dart';
import '../../../../app/localization/t.dart';

/// Green summary card: order number, status, placed date, payment and total.
class TrackingHeaderCard extends StatelessWidget {
  const TrackingHeaderCard({super.key, required this.tracking, this.detail});

  final OrderTrackingModel tracking;
  final OrderDetailModel? detail;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    final style = OrderStatusChip.styleFor(tracking.status.toLowerCase());
    final placed = detail?.displayDate ?? tracking.placedLabel;
    final total = detail?.grandTotal ?? tracking.total;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_shipping_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('tracking.order'), style: TextStyle(color: Colors.white.withValues(alpha: .75), fontSize: 11.5)),
                    Text(
                      tracking.orderNo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(style.icon, size: 13, color: style.color),
                    const SizedBox(width: 4),
                    Text(style.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: style.color)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _meta(t('tracking.placed_on'), placed.isEmpty ? '—' : placed),
              _meta(t('common.payment'), detail?.paymentStatusLabel ?? '—'),
              _meta(t('cart.total'), '₹${_money.format(total)}', end: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _meta(String label, String value, {bool end = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: .75), fontSize: 10.5)),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
