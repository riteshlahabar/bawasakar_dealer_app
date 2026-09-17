import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_info_note.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/auth_submit_button.dart';
import 'widgets/mobile_number_field.dart';
import 'widgets/registration_steps.dart';
import '../../../app/localization/t.dart';

/// Registration step 1: mobile number.
class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: t('auth.dealer_registration'),
      subtitle: t('auth.register_subtitle'),
      showBack: true,
      footer: AuthFooter(
        prompt: t('auth.already_registered'),
        action: t('common.login'),
        onTap: () => Get.back(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RegistrationSteps(current: 0),
          const SizedBox(height: 24),
          Text(t('auth.enter_mobile'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            t('auth.otp_verify_it'),
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
          ),
          const SizedBox(height: 18),
          MobileNumberField(controller: controller.forms.signupMobile, onSubmitted: controller.startRegistration),
          const SizedBox(height: 14),
          AuthInfoNote(
            icon: Icons.lock_outline_rounded,
            text: t('auth.number_privacy'),
          ),
          const SizedBox(height: 22),
          Obx(
            () => AuthSubmitButton(
              label: t('auth.send_otp'),
              isLoading: controller.isLoading.value,
              onPressed: controller.startRegistration,
            ),
          ),
        ],
      ),
    );
  }
}
