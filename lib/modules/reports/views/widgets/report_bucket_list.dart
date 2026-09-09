import 'package:flutter/material.dart';

import '../../../../app/data/models/report_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_card.dart';

/// Renders a labelled group of report buckets as proportional bars.
///
/// Its own widget so the reports screen does not repeat the same layout for
/// the status and month breakdowns.
class ReportBucketList extends StatelessWidget {
  const ReportBucketList({super.key, required this.title, required this.buckets});

  final String title;
  final List<ReportBucketModel> buckets;

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) return const SizedBox.shrink();

    // Bars are scaled against the largest bucket, so the shape of the data
    // stays readable whatever the absolute values are.
    final peak = buckets
        .map((bucket) => bucket.value)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
        const SizedBox(height: 10),
        AppCard(
          child: Column(
            children: buckets.map((bucket) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bucket.label.replaceAll('_', ' '),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12.5),
                          ),
                        ),
                        Text(
                          '${bucket.count} • ₹${bucket.value.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 11.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: peak <= 0 ? 0 : bucket.value / peak,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
