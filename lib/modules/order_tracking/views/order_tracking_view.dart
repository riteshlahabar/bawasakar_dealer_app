import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/order_tracking_controller.dart';
import 'widgets/order_items_card.dart';
import 'widgets/price_summary_card.dart';
import 'widgets/tracking_header_card.dart';
import 'widgets/tracking_info_grid.dart';
import 'widgets/tracking_progress_bar.dart';
import 'widgets/tracking_section_card.dart';
import 'widgets/tracking_timeline.dart';
import '../../../app/localization/t.dart';

class OrderTrackingView extends GetView<OrderTrackingController> {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('tracking.title'))),
      body: Obx(() {
        final tracking = controller.tracking.value;

        if (controller.isLoading.value && tracking == null) {
          return LoadingView(message: t('tracking.loading'));
        }

        if (tracking == null) {
          return EmptyState(
            title: t('tracking.unavailable'),
            message: controller.error.value.isEmpty
                ? t('tracking.not_found')
                : controller.error.value,
            icon: Icons.local_shipping_outlined,
          );
        }

        final detail = controller.detail.value;

        if (detail != null && controller.consumeItemsFocus()) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final target = controller.itemsKey.currentContext;
            if (target != null) {
              Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 400), alignment: .05);
            }
          });
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              TrackingHeaderCard(tracking: tracking, detail: detail),
              const SizedBox(height: 12),
              if (tracking.isCancelled) _cancelledBanner(),
              TrackingSectionCard(
                title: t('tracking.progress'),
                child: TrackingProgressBar(stages: tracking.stages, cancelled: tracking.isCancelled),
              ),
              const SizedBox(height: 12),
              TrackingInfoGrid(tracking: tracking, detail: detail),
              const SizedBox(height: 12),
              TrackingSectionCard(
                title: t('orders.tracking_history'),
                child: TrackingTimeline(tracking: tracking, detail: detail),
              ),
              if (detail != null) ...[
                const SizedBox(height: 12),
                KeyedSubtree(key: controller.itemsKey, child: OrderItemsCard(detail: detail)),
                const SizedBox(height: 12),
                PriceSummaryCard(detail: detail),
              ],
              const SizedBox(height: 16),
              _actions(hasInvoice: (detail?.invoiceNo ?? '').isNotEmpty),
            ],
          ),
        );
      }),
    );
  }

  Widget _cancelledBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.danger.withValues(alpha: .35)),
      ),
      child: Row(
        children: [
          Icon(Icons.cancel_rounded, color: AppColors.danger, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              t('tracking.cancelled_note'),
              style: TextStyle(fontSize: 12.5, color: AppColors.danger, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions({required bool hasInvoice}) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Get.toNamed<void>(AppRoutes.support),
            icon: const Icon(Icons.support_agent_rounded, size: 18),
            label: Text(t('support.need_help')),
          ),
        ),
        if (hasInvoice) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed<void>(AppRoutes.invoices),
              icon: const Icon(Icons.receipt_long_rounded, size: 18),
              label: Text(t('invoice.view')),
            ),
          ),
        ],
      ],
    );
  }
}
