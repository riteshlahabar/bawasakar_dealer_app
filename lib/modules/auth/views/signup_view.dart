import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dealer Registration')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(20)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Register Dealer Firm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                SizedBox(height: 6),
                Text('Register with mobile OTP. Product catalogue and dealer prices are visible only after admin approval.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.35)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextField(controller: controller.signupName, decoration: const InputDecoration(labelText: 'Owner / Contact Name', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupFirmName, decoration: const InputDecoration(labelText: 'Firm / Shop Name', prefixIcon: Icon(Icons.business_outlined))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupMobile, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone_android))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupEmail, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email Address (optional)', prefixIcon: Icon(Icons.email_outlined))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupGst, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'GST Number (optional)', prefixIcon: Icon(Icons.receipt_long_outlined))),
          const SizedBox(height: 22),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.signup,
                child: Text(controller.isLoading.value ? 'Sending OTP...' : 'Register & Verify OTP'),
              )),
        ],
      ),
    );
  }
}
