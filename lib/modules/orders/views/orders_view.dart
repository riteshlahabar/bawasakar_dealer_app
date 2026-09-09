import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.orders.isEmpty) return const LoadingView();
      if (controller.orders.isEmpty) {
        return const EmptyState(title: 'No Dealer Orders Yet', message: 'Your B2B orders will appear here after you submit an order.', icon: Icons.receipt_long_outlined);
      }
      return RefreshIndicator(
        onRefresh: controller.loadOrders,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final order = controller.orders[index];
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              // Tapping an order opens its delivery timeline.
              onTap: () => Get.toNamed<void>(
                AppRoutes.orderTracking,
                arguments: order.id,
              ),
              child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.orderNo, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
                        const SizedBox(height: 3),
                        Text(order.createdAt, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${order.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text(order.status.capitalizeFirst ?? order.status, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    ],
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
            );
          },
        ),
      );
    });
  }
}
