import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Dealer OTP')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(22)),
            child: const Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 34),
          ),
          const SizedBox(height: 22),
          const Text('Enter OTP', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Obx(() => Text('OTP sent to ${controller.mobile.value}. Dealer product access starts only after admin approval.', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.35))),
          const SizedBox(height: 22),
          TextField(
            controller: controller.forms.otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.password_rounded), labelText: '6 Digit OTP', counterText: ''),
          ),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.verifyOtp,
                child: Text(controller.isLoading.value ? 'Verifying...' : 'Verify OTP'),
              )),
        ],
      ),
    );
  }
}
