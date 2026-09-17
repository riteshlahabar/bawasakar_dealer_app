import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../controllers/change_password_controller.dart';
import 'widgets/password_field.dart';
import '../../../app/localization/t.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('menu.change_password'))),
      body: Obx(() {
        if (controller.isChecking.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.hasPassword.value
                              ? t('password.intro_existing')
                              : t('password.intro_otp'),
                          style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (controller.hasPassword.value) ...[
                    PasswordField(controller: controller.current, label: t('auth.current_password')),
                    const SizedBox(height: 12),
                  ],
                  PasswordField(controller: controller.password, label: t('auth.new_password')),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4, 6, 4, 0),
                    child: Text(
                      t('password.at_least', {'n': '${ChangePasswordController.minLength}'}),
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PasswordField(controller: controller.confirmation, label: t('auth.confirm_new_password')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.submit,
                    child: Text(controller.isLoading.value ? t('common.saving') : t('password.update')),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
