import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/cart_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../cart/views/cart_view.dart';
import '../../catalog/views/catalog_view.dart';
import '../../../app/routes/app_routes.dart';
import '../../home/views/home_view.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../orders/views/orders_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_shell_controller.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [HomeView(), CatalogView(), CartView(), OrdersView(), ProfileView()];
    final cart = Get.find<CartService>();

    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(controller.currentTitle),
            actions: [
              IconButton(
                onPressed: () => Get.toNamed<void>(AppRoutes.notifications),
                icon: Obx(() {
                  final unread = Get.find<NotificationsController>().unreadCount.value;
                  return Badge(
                    isLabelVisible: unread > 0,
                    label: Text(unread.toString()),
                    backgroundColor: AppColors.orange,
                    child: const Icon(Icons.notifications_none_rounded),
                  );
                }),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: IndexedStack(index: controller.selectedIndex.value, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: controller.changeTab,
            destinations: [
              const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
              const NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: 'Category'),
              NavigationDestination(
                icon: Obx(() => Badge(
                      isLabelVisible: cart.totalItems > 0,
                      label: Text(cart.totalItems.toString()),
                      backgroundColor: AppColors.orange,
                      child: const Icon(Icons.shopping_cart_outlined),
                    )),
                selectedIcon: const Icon(Icons.shopping_cart_rounded),
                label: 'Cart',
              ),
              const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
              const NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ));
  }
}
