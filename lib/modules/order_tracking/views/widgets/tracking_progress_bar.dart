import 'package:flutter/material.dart';

import '../../../../app/data/models/tracking_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Horizontal 5-step progress: Placed → Approved → Packed → Dispatched →
/// Delivered, with the date under each completed step.
class TrackingProgressBar extends StatelessWidget {
  const TrackingProgressBar({super.key, required this.stages, this.cancelled = false});

  final List<TrackingStageModel> stages;
  final bool cancelled;

  static const _icons = {
    'placed': Icons.receipt_long_rounded,
    'approved': Icons.verified_rounded,
    'packed': Icons.inventory_2_rounded,
    'dispatched': Icons.local_shipping_rounded,
    'out_for_delivery': Icons.delivery_dining_rounded,
    'delivered': Icons.home_rounded,
  };

  /// Each step gets the same colour its status badge uses elsewhere in the
  /// app, so the bar reads at a glance instead of one flat green line.
  static const _colors = {
    'placed': AppColors.primary,
    'approved': AppColors.primary,
    'packed': Color(0xFFB7791F),
    'dispatched': Color(0xFF2972FF),
    'out_for_delivery': Color(0xFF7C3AED),
    'delivered': AppColors.success,
  };

  Color _colorFor(String key) => cancelled ? AppColors.danger : (_colors[key] ?? AppColors.primary);

  @override
  Widget build(BuildContext context) {
    if (stages.isEmpty) {
      return Text(t('tracking.no_updates'), style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5));
    }

    final current = stages.lastIndexWhere((stage) => stage.done);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < stages.length; i++)
          Expanded(
            child: Column(
              children: [
                // Fixed height so the connecting line sits at the same Y for
                // every stage — the current stage's dot is bigger, and without
                // this each row sizes to its own dot, breaking the line.
                SizedBox(
                  height: 34,
                  child: Row(
                    children: [
                      Expanded(child: _line(i > 0 && stages[i].done ? _colorFor(stages[i].key) : (i == 0 ? Colors.transparent : AppColors.border))),
                      _dot(stages[i], i == current, _colorFor(stages[i].key)),
                      Expanded(
                        child: _line(i == stages.length - 1
                            ? Colors.transparent
                            : (stages[i + 1].done ? _colorFor(stages[i + 1].key) : AppColors.border)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stages[i].label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.2,
                    fontWeight: stages[i].done ? FontWeight.w700 : FontWeight.w500,
                    color: stages[i].done ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stages[i].done ? stages[i].dateLabel : t('common.pending'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _line(Color color) => Container(height: 3, color: color);

  Widget _dot(TrackingStageModel stage, bool isCurrent, Color color) {
    final size = isCurrent ? 34.0 : 28.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: stage.done ? color : Colors.white,
        border: Border.all(color: stage.done ? color : AppColors.border, width: 2),
        boxShadow: isCurrent ? [BoxShadow(color: color.withValues(alpha: .35), blurRadius: 10)] : null,
      ),
      child: Icon(
        _icons[stage.key] ?? Icons.circle,
        size: isCurrent ? 17 : 14,
        color: stage.done ? Colors.white : AppColors.textSecondary,
      ),
    );
  }
}
