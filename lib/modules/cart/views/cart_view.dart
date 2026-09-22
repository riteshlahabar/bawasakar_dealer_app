import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/data/services/cart_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../main_shell/controllers/main_shell_controller.dart';
import '../controllers/cart_controller.dart';
import 'widgets/cart_bottom_bar.dart';
import 'widgets/cart_deliver_to_strip.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_price_details.dart';
import 'widgets/credit_banner.dart';
import 'widgets/empty_cart_view.dart';
import 'widgets/saved_for_later_section.dart';
import '../../../app/localization/t.dart';

/// Cart pushed as its own screen (e.g. from the product detail page's cart
/// icon) — needs its own Scaffold/AppBar since [CartView] itself has none
/// (it relies on [MainShellView]'s Scaffold when shown as the Cart tab).
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('cart.title'))),
      body: const CartView(),
    );
  }
}

class CartView extends GetView<CartController> {
  const CartView({super.key});

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = controller.cart;
      final items = cart.items;

      if (items.isEmpty && cart.savedForLater.isEmpty) {
        return EmptyCartView(
          products: controller.recentProducts.toList(),
          onShopNow: _shopNow,
          onAdd: controller.addToCart,
          onRefresh: controller.load,
        );
      }

      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                children: [
                  CartDeliverToStrip(service: controller.addresses),
                  const SizedBox(height: 12),
                  if (items.isNotEmpty) ...[
                    _summary(cart),
                    const SizedBox(height: 12),
                    CreditBanner(
                      available: controller.availableCredit,
                      exceeds: controller.exceedsCredit,
                      orderTotal: cart.subtotal,
                    ),
                    for (final item in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CartItemCard(
                          item: item,
                          onIncrease: () => controller.increase(item.product),
                          onDecrease: () => controller.decrease(item.product),
                          onRemove: () => controller.remove(item.product),
                          onSaveForLater: () => controller.saveForLater(item.product),
                        ),
                      ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(t('cart.empty_title'), style: const TextStyle(color: AppColors.textSecondary)),
                    ),
                  if (cart.savedForLater.isNotEmpty)
                    SavedForLaterSection(
                      products: cart.savedForLater.toList(),
                      onMoveToCart: controller.moveToCart,
                      onDelete: controller.removeSaved,
                    ),
                  if (items.isNotEmpty) CartPriceDetails(cart: cart),
                ],
              ),
            ),
          ),
          if (items.isNotEmpty)
            CartBottomBar(
              total: cart.subtotal,
              countLabel: (cart.totalItems == 1 ? t('cart.case_count_one', {'n': '${cart.totalItems}'}) : t('cart.case_count_many', {'n': '${cart.totalItems}'})),
              onProceed: controller.checkout,
            ),
        ],
      );
    });
  }

  Widget _summary(CartService cart) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              text: t('cart.subtotal_items', {'count': (cart.totalItems == 1 ? t('cart.case_count_one', {'n': '${cart.totalItems}'}) : t('cart.case_count_many', {'n': '${cart.totalItems}'}))}),
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
              children: [
                TextSpan(
                  text: '₹${_money.format(cart.subtotal)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: controller.checkout, child: Text(t('cart.proceed_to_buy'))),
        ],
      ),
    );
  }

  void _shopNow() {
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().changeTab(1);
    }
    if (Get.currentRoute != AppRoutes.main) {
      Get.back<void>();
    }
  }
}
