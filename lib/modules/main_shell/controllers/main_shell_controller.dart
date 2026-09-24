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

  /// Tabs opened before the current one, newest last. The phone's back button
  /// walks back through them one step at a time instead of closing the app.
  final _tabHistory = <int>[];

  /// Keeps the history from growing without bound when the dealer toggles
  /// between two tabs for a long time.
  static const _maxHistory = 20;

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

  /// Shows the tab opened before this one. Returns false when no earlier tab
  /// is left, which is when the back button should leave the app.
  bool goBackTab() {
    if (_tabHistory.isEmpty) {
      return false;
    }

    final previous = _tabHistory.removeLast();

    visitedTabs.add(previous);
    selectedIndex.value = previous;

    return true;
  }

  void changeTab(int index) {
    if (index != selectedIndex.value) {
      _tabHistory.add(selectedIndex.value);

      if (_tabHistory.length > _maxHistory) {
        _tabHistory.removeAt(0);
      }
    }

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
