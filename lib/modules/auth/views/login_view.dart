import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/email_login_form.dart';
import 'widgets/login_mode_switch.dart';
import 'widgets/mobile_login_form.dart';
import '../../../app/localization/t.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: t('auth.welcome_back'),
      subtitle: t('auth.sign_in_subtitle'),
      footer: AuthFooter(
        prompt: t('auth.new_dealer'),
        action: t('auth.register_firm'),
        onTap: () => Get.toNamed(AppRoutes.signup),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginModeSwitch(mode: controller.loginMode, onChanged: controller.changeLoginMode),
          const SizedBox(height: 20),
          Obx(
            () => controller.loginMode.value == 0
                ? MobileLoginForm(
                    fields: controller.forms,
                    isLoading: controller.isLoading,
                    onSubmit: controller.requestOtp,
                  )
                : EmailLoginForm(
                    fields: controller.forms,
                    isLoading: controller.isLoading,
                    onSubmit: controller.loginWithEmail,
                  ),
          ),
        ],
      ),
    );
  }
}
