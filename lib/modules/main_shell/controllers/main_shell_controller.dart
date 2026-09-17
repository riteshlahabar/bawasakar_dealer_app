import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../../app/localization/t.dart';

class MainShellController
    extends GetxController {
  MainShellController(this._storage);

  final AuthStorage _storage;

  final selectedIndex = 0.obs;

  /// Tabs opened so far. A tab's screen — and its API calls — is created the
  /// first time it is opened, instead of all five on app start.
  final visitedTabs = <int>{0};

  /// Translation keys, resolved in [currentTitle].
  final titles = const [
    'shell.dealer_store',
    'shell.categories',
    'cart.title',
    'orders.current',
    'menu.order_history',
  ];

  String get currentTitle {
    final index = selectedIndex.value;

    // Home greets the signed-in dealer by name.
    if (index == 0) {
      final name = _storage.userName?.trim() ?? '';

      if (name.isNotEmpty) {
        return t('shell.welcome', {'name': name});
      }
    }

    return t(titles[index]);
  }

  void changeTab(int index) {
    final firstVisit = visitedTabs.add(index);

    selectedIndex.value = index;

    // First visit: the screen's own onReady loads its data.
    if (firstVisit) {
      return;
    }

    // Current orders and order history change often, so refresh them on
    // return. Home and catalog keep what they show (pull down to refresh).
    switch (index) {
      case 3:
        if (Get.isRegistered<OrdersController>()) {
          Get.find<OrdersController>().loadOrders();
        }
        break;

      case 4:
        if (Get.isRegistered<OrdersController>(tag: OrdersController.historyTag)) {
          Get.find<OrdersController>(tag: OrdersController.historyTag).loadOrders();
        }
        break;
    }
  }
}
