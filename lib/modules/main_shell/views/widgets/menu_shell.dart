import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../controllers/main_shell_controller.dart';
import 'account_chip_bar.dart';
import 'main_nav_bar.dart';

/// Keeps the account chips and the bottom navigation bar under a menu screen
/// (Invoices, Payments, Account…), with its chip highlighted.
class MenuShell extends StatelessWidget {
  const MenuShell({super.key, required this.route, required this.child});

  final String route;
  final Widget child;

  /// Index of the Menu (☰) tab.
  static const menuTab = 4;

  @override
  Widget build(BuildContext context) {
    // Typing needs the room: hide chips and nav while the keyboard is open.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(child: child),
          if (!keyboardOpen) AccountChipBar(currentRoute: route),
        ],
      ),
      bottomNavigationBar: keyboardOpen ? null : const MainNavBar(selectedIndex: menuTab, onSelected: _openTab),
    );
  }

  static void _openTab(int index) {
    Get.until((page) => page.settings.name == AppRoutes.main);
    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().changeTab(index);
    }
  }
}
