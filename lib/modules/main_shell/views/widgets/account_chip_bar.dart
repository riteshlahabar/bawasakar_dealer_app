import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/localization/t.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../profile/controllers/profile_controller.dart';

/// Amazon-style row of outlined chips for every account menu item.
class AccountChipBar extends StatelessWidget {
  const AccountChipBar({super.key, this.currentRoute});

  /// Route of the menu screen being shown; its chip is highlighted.
  final String? currentRoute;

  static const _logoutKey = 'menu.logout';

  /// Labels are translation keys; the chip resolves them at build time so a
  /// language change redraws the bar without touching this list.
  static const _items = <({String label, String? route})>[
    (label: 'menu.account', route: AppRoutes.account),
    (label: 'menu.outstanding', route: AppRoutes.outstanding),
    (label: 'menu.payments', route: AppRoutes.payments),
    (label: 'menu.invoices', route: AppRoutes.invoices),
    (label: 'menu.returns', route: AppRoutes.returns),
    (label: 'menu.reports', route: AppRoutes.reports),
    (label: 'menu.notifications', route: AppRoutes.notifications),
    (label: 'menu.support', route: AppRoutes.support),
    (label: 'menu.change_password', route: AppRoutes.changePassword),
    (label: 'menu.language', route: AppRoutes.language),
    (label: _logoutKey, route: null),
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

  Widget _chip(({String label, String? route}) item) {
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

  void _open(({String label, String? route}) item) {
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
