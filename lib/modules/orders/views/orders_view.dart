import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/orders_controller.dart';
import '../utils/order_filter.dart';
import 'widgets/buy_again_list.dart';
import 'widgets/order_card.dart';
import 'widgets/order_period_button.dart';
import 'widgets/return_request_sheet.dart';
import '../../../app/localization/t.dart';

/// Current Orders (Orders tab) or Order History (☰ tab) when [history] is true.
class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key, this.history = false});

  final bool history;

  @override
  String? get tag => history ? OrdersController.historyTag : null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.search.value = value,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: history ? t('orders.search_history_hint') : t('orders.search_hint'),
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
              ),
              if (history) ...[
                const SizedBox(width: 8),
                OrderPeriodButton(period: controller.period),
              ],
            ],
          ),
        ),
        _filters(),
        Expanded(child: Obx(_body)),
      ],
    );
  }

  Widget _filters() {
    return SizedBox(
      height: 52,
      child: Obx(
        () => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          children: [
            for (final option in controller.tabs)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(option.title),
                  selected: controller.filter.value == option,
                  onSelected: (_) => controller.filter.value = option,
                  showCheckmark: false,
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: controller.filter.value == option ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (controller.isLoading.value && controller.orders.isEmpty) {
      return const LoadingView();
    }

    if (controller.filter.value == OrderFilter.buyAgain) {
      return RefreshIndicator(
        onRefresh: controller.loadOrders,
        child: BuyAgainList(products: controller.buyAgainProducts, onAdd: controller.addToCart),
      );
    }

    final orders = controller.filteredOrders;

    return RefreshIndicator(
      onRefresh: controller.loadOrders,
      child: orders.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [SizedBox(height: 360, child: _empty())],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final order = orders[index];

                return OrderCard(
                  order: order,
                  onTrack: () => Get.toNamed<void>(AppRoutes.orderTracking, arguments: order.id),
                  // Same screen, scrolled to the items section.
                  onDetails: () => Get.toNamed<void>(AppRoutes.orderTracking, arguments: {'order_id': order.id, 'focus': 'items'}),
                  onBuyAgain: history && order.items.isNotEmpty ? () => controller.buyAgain(order) : null,
                  onReturn: order.canReturn ? () => ReturnRequestSheet.show(order, (reason) => controller.requestReturn(order, reason)) : null,
                  onInvoice: order.hasInvoice
                      ? () => Get.toNamed<void>(
                            order.invoiceId > 0 ? AppRoutes.invoiceDetail : AppRoutes.invoices,
                            arguments: order.invoiceId > 0 ? order.invoiceId : null,
                          )
                      : null,
                );
              },
            ),
    );
  }

  Widget _empty() {
    if (controller.orders.isNotEmpty && controller.search.value.trim().isNotEmpty) {
      return EmptyState(
        title: t('orders.no_match_title'),
        message: t('orders.empty_message'),
        icon: Icons.search_off_rounded,
      );
    }

    return history
        ? EmptyState(
            title: t('orders.no_past_title'),
            message: t('orders.no_past_message'),
            icon: Icons.history_rounded,
          )
        : EmptyState(
            title: t('orders.no_current_title'),
            message: t('orders.no_current_message'),
            icon: Icons.receipt_long_outlined,
          );
  }
}
