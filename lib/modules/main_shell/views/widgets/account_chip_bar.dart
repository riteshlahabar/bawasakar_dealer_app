import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/localization/t.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../profile/controllers/profile_controller.dart';
import '../../controllers/main_shell_controller.dart';

/// Amazon-style row of outlined chips for every account menu item.
class AccountChipBar extends StatelessWidget {
  const AccountChipBar({super.key, this.currentRoute});

  /// Route of the menu screen being shown; its chip is highlighted. The
  /// Order History tab has no route of its own, so it passes
  /// [orderHistorySentinel] here instead.
  final String? currentRoute;

  static const _logoutKey = 'menu.logout';

  /// Not a real route — only used to match [currentRoute] so the Order
  /// History chip highlights itself while that tab is showing.
  static const orderHistorySentinel = 'order-history-tab';

  /// Index of the Menu (☰) tab in [MainShellController.titles].
  static const _orderHistoryTabIndex = 4;

  /// Labels are translation keys; the chip resolves them at build time so a
  /// language change redraws the bar without touching this list.
  static const _items = <({String label, String? route, int? tabIndex})>[
    (label: 'menu.order_history', route: orderHistorySentinel, tabIndex: _orderHistoryTabIndex),
    (label: 'menu.account', route: AppRoutes.account, tabIndex: null),
    (label: 'menu.outstanding', route: AppRoutes.outstanding, tabIndex: null),
    (label: 'menu.payments', route: AppRoutes.payments, tabIndex: null),
    (label: 'menu.invoices', route: AppRoutes.invoices, tabIndex: null),
    (label: 'menu.returns', route: AppRoutes.returns, tabIndex: null),
    (label: 'menu.reports', route: AppRoutes.reports, tabIndex: null),
    (label: 'menu.notifications', route: AppRoutes.notifications, tabIndex: null),
    (label: 'menu.support', route: AppRoutes.support, tabIndex: null),
    (label: 'menu.change_password', route: AppRoutes.changePassword, tabIndex: null),
    (label: 'menu.language', route: AppRoutes.language, tabIndex: null),
    (label: _logoutKey, route: null, tabIndex: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 14, offset: const Offset(0, -3))],
      ),
      child: SizedBox(
        height: 46,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, index) => _chip(_items[index]),
        ),
      ),
    );
  }

  Widget _chip(({String label, String? route, int? tabIndex}) item) {
    final danger = item.label == _logoutKey;
    final selected = item.route != null && item.route == currentRoute;
    final borderColor = selected
        ? AppColors.primary
        : (danger ? AppColors.danger.withValues(alpha: .5) : const Color(0xFFBDBDBD));

    return Material(
      color: selected ? AppColors.primary : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _open(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Text(
              t(item.label),
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: selected ? Colors.white : (danger ? AppColors.danger : AppColors.textPrimary)),
            ),
          ),
        ),
      ),
    );
  }

  void _open(({String label, String? route, int? tabIndex}) item) {
    final tabIndex = item.tabIndex;
    if (tabIndex != null) {
      if (item.route == currentRoute) return;
      Get.until((page) => page.settings.name == AppRoutes.main);
      if (Get.isRegistered<MainShellController>()) {
        Get.find<MainShellController>().changeTab(tabIndex);
      }
      return;
    }

    final route = item.route;
    if (route != null) {
      if (route == currentRoute) return;
      // One menu screen at a time above the main shell, so back returns to it.
      Get.offNamedUntil<void>(route, (page) => page.settings.name == AppRoutes.main);
      return;
    }

    Get.dialog<void>(
      AlertDialog(
        title: Text(t('common.logout_title')),
        content: Text(t('common.logout_message')),
        actions: [
          TextButton(onPressed: () => Get.back<void>(), child: Text(t('common.cancel'))),
          TextButton(
            onPressed: () {
              Get.back<void>();
              Get.find<ProfileController>().logout();
            },
            child: Text(t('menu.logout'), style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}
