import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
          children: [
            const SizedBox(height: 4),
            _brandHeader(),
            const SizedBox(height: 26),
            const Text('Dealer Login', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text('Login after admin approval to see dealer pricing and place B2B orders.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.35)),
            const SizedBox(height: 22),
            _modeSwitch(),
            const SizedBox(height: 18),
            Obx(() => controller.loginMode.value == 0 ? _mobileLogin() : _emailLogin()),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('New dealer? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.signup),
                  child: const Text('Register firm', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _brandHeader() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 30),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bawaskar Dealer', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              SizedBox(height: 2),
              Text('B2B orders with dealer pricing', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _modeSwitch() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            _modeItem('Mobile OTP', 0),
            _modeItem('Email Login', 1),
          ],
        ),
      );
    });
  }

  Widget _modeItem(String title, int index) {
    final active = controller.loginMode.value == index;
    return Expanded(
      child: InkWell(
        onTap: () => controller.loginMode.value = index,
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: active ? Colors.white : AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  Widget _mobileLogin() {
    return Column(
      children: [
        TextField(
          controller: controller.nameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline), labelText: 'Owner / Contact Name'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.firmNameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.business_outlined), labelText: 'Firm / Shop Name'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.mobileController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.phone_android_rounded), labelText: 'Mobile Number'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.gstController,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.receipt_long_outlined), labelText: 'GST Number (optional)'),
        ),
        const SizedBox(height: 20),
        Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.requestOtp,
              child: Text(controller.isLoading.value ? 'Sending OTP...' : 'Send OTP'),
            )),
      ],
    );
  }

  Widget _emailLogin() {
    return Column(
      children: [
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.email_outlined), labelText: 'Email Address'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.passwordController,
          obscureText: true,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.lock_outline), labelText: 'Password'),
        ),
        const SizedBox(height: 20),
        Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.loginWithEmail,
              child: Text(controller.isLoading.value ? 'Checking...' : 'Login'),
            )),
        const SizedBox(height: 10),
        const Text('Dealer email login backend API is optional. Mobile OTP is ready now.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
      ],
    );
  }
}
