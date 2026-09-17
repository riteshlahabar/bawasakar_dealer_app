import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/services/cart_service.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Home · Category · Cart · Orders · Menu, shared by the main shell and
/// every menu screen.
class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key, required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartService>();

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelected,
      destinations: [
        NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home_rounded), label: t('nav.home')),
        NavigationDestination(icon: const Icon(Icons.grid_view_outlined), selectedIcon: const Icon(Icons.grid_view_rounded), label: t('nav.category')),
        NavigationDestination(
          icon: Obx(() => Badge(
                isLabelVisible: cart.totalItems > 0,
                label: Text(cart.totalItems.toString()),
                backgroundColor: AppColors.orange,
                child: const Icon(Icons.shopping_cart_outlined),
              )),
          selectedIcon: const Icon(Icons.shopping_cart_rounded),
          label: t('nav.cart'),
        ),
        NavigationDestination(icon: const Icon(Icons.receipt_long_outlined), selectedIcon: const Icon(Icons.receipt_long_rounded), label: t('nav.orders')),
        NavigationDestination(icon: const Icon(Icons.menu_rounded), selectedIcon: const Icon(Icons.menu_open_rounded), label: t('nav.menu')),
      ],
    );
  }
}
