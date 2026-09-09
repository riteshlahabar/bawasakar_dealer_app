import 'package:get/get.dart';

import '../../catalog/controllers/catalog_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainShellController
    extends GetxController {
  final selectedIndex = 0.obs;

  final titles = const [
    'Dealer Store',
    'Categories',
    'B2B Cart',
    'Orders',
    'Profile',
  ];

  String get currentTitle =>
      titles[selectedIndex.value];

  void changeTab(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        if (Get.isRegistered<
            HomeController>()) {
          Get.find<HomeController>()
              .loadHome();
        }
        break;

      case 1:
        if (Get.isRegistered<
            CatalogController>()) {
          Get.find<CatalogController>()
              .loadCatalog();
        }
        break;

      case 3:
        if (Get.isRegistered<
            OrdersController>()) {
          Get.find<OrdersController>()
              .loadOrders();
        }
        break;

      case 4:
        if (Get.isRegistered<
            ProfileController>()) {
          Get.find<ProfileController>()
              .loadProfile();
        }
        break;
    }
  }
}