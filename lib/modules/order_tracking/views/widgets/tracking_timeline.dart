import 'package:flutter/material.dart';

import '../../../../app/data/models/order_detail_model.dart';
import '../../../../app/data/models/tracking_model.dart';
import '../../../../app/theme/app_colors.dart';
import 'tracking_info_grid.dart';
import '../../../../app/localization/t.dart';

/// Tracking history, newest first: what happened, when, and where.
class TrackingTimeline extends StatelessWidget {
  const TrackingTimeline({super.key, required this.tracking, this.detail});

  final OrderTrackingModel tracking;
  final OrderDetailModel? detail;

  @override
  Widget build(BuildContext context) {
    final events = tracking.stages.where((stage) => stage.done).toList().reversed.toList();

    if (events.isEmpty) {
      return Text(t('tracking.no_updates_short'), style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5));
    }

    return Column(
      children: [
        for (var i = 0; i < events.length; i++)
          _event(events[i], latest: i == 0, isLast: i == events.length - 1),
      ],
    );
  }

  Widget _event(TrackingStageModel stage, {required bool latest, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: latest ? AppColors.primary : AppColors.primary.withValues(alpha: .35),
                ),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: AppColors.border)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage.label,
                    style: TextStyle(fontSize: 13, fontWeight: latest ? FontWeight.w800 : FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  _meta(Icons.schedule_rounded, stage.dateTimeLabel),
                  const SizedBox(height: 2),
                  _meta(Icons.place_outlined, _location(stage.key)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  String _location(String key) {
    final courierName = tracking.courier?.name ?? '';
    final address = detail?.address ?? '';

    return switch (key) {
      'placed' => t('tracking.order_received'),
      'approved' => t('tracking.review_desk'),
      'packed' => TrackingInfoGrid.warehouse,
      'dispatched' => courierName.isNotEmpty ? courierName : TrackingInfoGrid.deliveryDesk,
      'out_for_delivery' => t('tracking.with_partner'),
      'delivered' => address.isNotEmpty ? address : t('address.delivery_address'),
      _ => '',
    };
  }
}
