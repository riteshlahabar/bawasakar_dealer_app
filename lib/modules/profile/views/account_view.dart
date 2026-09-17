import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import 'profile_view.dart';
import '../../../app/localization/t.dart';

/// The profile screen as its own page, opened from the Account chip.
class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('menu.account')),
        actions: [
          IconButton(
            tooltip: t('profile.edit'),
            onPressed: () => Get.toNamed<void>(AppRoutes.editProfile),
            icon: const Icon(Icons.edit_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: const ProfileView(),
    );
  }
}
