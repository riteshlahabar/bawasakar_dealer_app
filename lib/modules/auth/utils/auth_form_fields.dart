import 'package:flutter/material.dart';

/// Groups every [TextEditingController] used by the login, signup (mobile
/// step) and OTP screens so [AuthController] itself only holds Rx state and
/// thin flow methods. Firm-details fields live in `RegistrationController`.
class AuthFormFields {
  // Login
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Registration step 1
  final signupMobile = TextEditingController();

  // Do not prefill production OTP.
  final otpController = TextEditingController();

  void dispose() {
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    signupMobile.dispose();
    otpController.dispose();
  }
}
