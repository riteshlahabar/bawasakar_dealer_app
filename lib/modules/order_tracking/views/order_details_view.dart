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
import '../../../app/localization/t.dart';

/// What was ordered: items, quantities and the full price breakdown.
/// Delivery progress and the tracking timeline live on the Track Order screen.
class OrderDetailsView extends GetView<OrderTrackingController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('tracking.details_title'))),
      body: Obx(() {
        final tracking = controller.tracking.value;
        final detail = controller.detail.value;

        if (controller.isLoading.value && detail == null) {
          return LoadingView(message: t('tracking.loading'));
        }

        if (tracking == null || detail == null) {
          return EmptyState(
            title: t('tracking.unavailable'),
            message: controller.error.value.isEmpty
                ? t('tracking.not_found')
                : controller.error.value,
            icon: Icons.receipt_long_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              TrackingHeaderCard(tracking: tracking, detail: detail),
              const SizedBox(height: 12),
              OrderItemsCard(detail: detail),
              const SizedBox(height: 12),
              PriceSummaryCard(detail: detail),
              const SizedBox(height: 16),
              _actions(hasInvoice: detail.invoiceNo.isNotEmpty),
            ],
          ),
        );
      }),
    );
  }

  Widget _actions({required bool hasInvoice}) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Get.toNamed<void>(AppRoutes.orderTracking, arguments: controller.orderId),
            icon: const Icon(Icons.local_shipping_outlined, size: 18),
            label: Text(t('tracking.track_order')),
          ),
        ),
        if (hasInvoice) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed<void>(AppRoutes.invoices),
              icon: const Icon(Icons.description_outlined, size: 18),
              label: Text(t('invoice.view')),
            ),
          ),
        ],
      ],
    );
  }
}
