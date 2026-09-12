import 'package:flutter/material.dart';

/// Groups every [TextEditingController] used by the auth screens (mobile
/// OTP login/registration, email/password login, and signup) so
/// [AuthController] itself only holds Rx state and thin flow methods.
class AuthFormFields {
  // Login / OTP registration controllers
  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final firmNameController = TextEditingController();
  final gstController = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Do not prefill production OTP.
  final otpController = TextEditingController();

  // Signup controllers
  final signupName = TextEditingController();
  final signupFirmName = TextEditingController();
  final signupMobile = TextEditingController();
  final signupEmail = TextEditingController();
  final signupGst = TextEditingController();

  /// Clear registration-related text fields (mobile OTP + signup forms).
  void clearRegistration() {
    nameController.clear();
    firmNameController.clear();
    gstController.clear();
    mobileController.clear();

    signupName.clear();
    signupFirmName.clear();
    signupMobile.clear();
    signupEmail.clear();
    signupGst.clear();

    otpController.clear();
  }

  void dispose() {
    mobileController.dispose();
    nameController.dispose();
    firmNameController.dispose();
    gstController.dispose();

    emailController.dispose();
    passwordController.dispose();

    otpController.dispose();

    signupName.dispose();
    signupFirmName.dispose();
    signupMobile.dispose();
    signupEmail.dispose();
    signupGst.dispose();
  }
}
