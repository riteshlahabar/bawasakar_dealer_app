import 'package:flutter/material.dart';

import '../../../../app/data/models/tracking_model.dart';
import '../../../../app/theme/app_colors.dart';

/// Vertical checkpoint list for the order timeline.
///
/// Kept as its own widget so the tracking screen stays a layout file and this
/// piece can be reused wherever a timeline is needed.
class TrackingStepper extends StatelessWidget {
  const TrackingStepper({super.key, required this.stages});

  final List<TrackingStageModel> stages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(stages.length, (index) {
        final stage = stages[index];
        final isLast = index == stages.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: stage.done ? AppColors.primary : AppColors.border,
                    ),
                    child: stage.done
                        ? const Icon(Icons.check, size: 13, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: stage.done ? AppColors.primary : AppColors.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: stage.done ? FontWeight.w800 : FontWeight.w600,
                          color: stage.done ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                      if (stage.at != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            stage.at!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
