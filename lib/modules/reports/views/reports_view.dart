import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/reports_controller.dart';
import 'widgets/report_bucket_list.dart';
import '../../../app/localization/t.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('menu.reports'))),
      body: Obx(() {
        if (controller.isLoading.value && controller.report.value == null) {
          return LoadingView(message: t('common.loading'));
        }

        final report = controller.report.value;

        if (report == null) {
          return EmptyState(
            title: t('reports.unavailable'),
            message: controller.error.value.isEmpty
                ? t('reports.load_failed')
                : controller.error.value,
            icon: Icons.insert_chart_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ReportsController.windows
                      .map((window) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(t('common.months', {'n': '$window'})),
                              selected: controller.months.value == window,
                              onSelected: (_) => controller.changeWindow(window),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t('reports.orders_placed'),
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            report.orderCount.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          t('reports.purchase_value'),
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '₹${report.orderValue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ReportBucketList(title: t('reports.by_status'), buckets: report.byStatus),
              const SizedBox(height: 16),
              ReportBucketList(title: t('reports.by_month'), buckets: report.byMonth),
              const SizedBox(height: 16),
              Text(
                t('reports.top_products'),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
              ),
              const SizedBox(height: 10),
              if (controller.products.isEmpty)
                Text(
                  t('reports.no_purchases'),
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                )
              else
                ...controller.products.map(
                  (row) => AppCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                row.product,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12.5),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                t('common.qty', {'n': row.quantity.toStringAsFixed(2)}),
                                style: const TextStyle(
                                    color: AppColors.textSecondary, fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${row.value.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 13),
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
