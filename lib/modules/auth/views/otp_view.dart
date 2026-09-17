import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/auth_submit_button.dart';
import 'widgets/otp_code_field.dart';
import 'widgets/registration_steps.dart';
import '../../../app/localization/t.dart';

/// OTP verification — registration step 2, and the second screen of mobile login.
class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: t('auth.verify_mobile'),
      subtitle: t('auth.otp_code_hint'),
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => controller.isRegistering.value
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 22),
                    child: RegistrationSteps(current: 1),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => Text(
              t('auth.otp_sent_to_mobile', {'mobile': controller.mobile.value}),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 18),
          OtpCodeField(controller: controller.forms.otpController, onCompleted: controller.verifyOtp),
          const SizedBox(height: 22),
          Obx(
            () => AuthSubmitButton(
              label: t('auth.verify_otp'),
              isLoading: controller.isLoading.value,
              onPressed: controller.verifyOtp,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Didn't receive the code?", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              TextButton(
                onPressed: controller.resendOtp,
                child: Text(t('auth.resend_otp'), style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
