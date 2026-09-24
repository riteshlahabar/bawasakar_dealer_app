import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../cart/views/cart_view.dart';
import '../../catalog/views/catalog_view.dart';
import '../../../app/routes/app_routes.dart';
import '../../home/views/home_view.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../orders/views/orders_view.dart';
import '../controllers/main_shell_controller.dart';
import 'widgets/main_nav_bar.dart';
import 'widgets/order_history_tab.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [HomeView(), CatalogView(), CartView(), OrdersView(), OrderHistoryTab()];

    final shell = Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              controller.currentTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
          // Unopened tabs stay empty placeholders, so their screens and API
          // calls only start when the dealer first opens them.
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              for (var i = 0; i < pages.length; i++)
                controller.visitedTabs.contains(i) ? pages[i] : const SizedBox.shrink(),
            ],
          ),
          bottomNavigationBar: MainNavBar(
            selectedIndex: controller.selectedIndex.value,
            onSelected: controller.changeTab,
          ),
        ));

    // Back steps through the tabs in the order they were opened; the app only
    // closes once there is no earlier tab left. Screens pushed above the shell
    // (product detail, order details, the menu screens) pop on their own first.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        if (!controller.goBackTab()) {
          SystemNavigator.pop();
        }
      },
      child: shell,
    );
  }
}
