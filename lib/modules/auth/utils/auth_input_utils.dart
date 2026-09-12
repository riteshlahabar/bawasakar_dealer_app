import 'package:get/get.dart';

/// A validation failure: a snackbar title paired with its message.
class AuthValidationError {
  const AuthValidationError(this.title, this.message);

  final String title;
  final String message;
}

/// Stateless validation / formatting helpers shared by the OTP and
/// email/password auth flows.
class AuthInputUtils {
  const AuthInputUtils._();

  static bool isValidMobile(String value) {
    final mobile = value.replaceAll(RegExp(r'\s+'), '');

    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  static String errorMessage(Object error) {
    var message = error.toString().trim();

    if (message.startsWith('Exception: ')) {
      message = message.substring('Exception: '.length);
    }

    if (message.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    return message;
  }

  static AuthValidationError? validateOtpRequest({
    required String dealerName,
    required String firmName,
    required String mobile,
  }) {
    if (dealerName.length < 3) {
      return const AuthValidationError(
        'Dealer Name Required',
        'Enter dealer owner/contact name.',
      );
    }

    if (firmName.length < 2) {
      return const AuthValidationError(
        'Firm Name Required',
        'Enter shop/firm name.',
      );
    }

    if (!isValidMobile(mobile)) {
      return const AuthValidationError(
        'Mobile Required',
        'Enter a valid 10 digit mobile number.',
      );
    }

    return null;
  }

  static AuthValidationError? validateOtpCode(String otp) {
    if (otp.length != 6) {
      return const AuthValidationError(
        'OTP Required',
        'Enter the 6 digit OTP.',
      );
    }

    if (!GetUtils.isNumericOnly(otp)) {
      return const AuthValidationError(
        'Invalid OTP',
        'OTP must contain only numbers.',
      );
    }

    return null;
  }

  static AuthValidationError? validateEmailLogin({
    required String email,
    required String password,
  }) {
    if (!GetUtils.isEmail(email)) {
      return const AuthValidationError(
        'Email Required',
        'Enter a valid email address.',
      );
    }

    if (password.trim().isEmpty) {
      return const AuthValidationError(
        'Password Required',
        'Enter your password.',
      );
    }

    if (password.length < 6) {
      return const AuthValidationError(
        'Password Required',
        'Password must be at least 6 characters.',
      );
    }

    return null;
  }

  static AuthValidationError? validateSignup({
    required String name,
    required String firm,
    required String mobile,
    required String email,
  }) {
    if (name.length < 3) {
      return const AuthValidationError(
        'Name Required',
        'Enter dealer owner/contact name.',
      );
    }

    if (firm.length < 2) {
      return const AuthValidationError(
        'Firm Name Required',
        'Enter shop/firm name.',
      );
    }

    if (!isValidMobile(mobile)) {
      return const AuthValidationError(
        'Mobile Required',
        'Enter a valid 10 digit mobile number.',
      );
    }

    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      return const AuthValidationError(
        'Invalid Email',
        'Enter a valid email address or leave it blank.',
      );
    }

    return null;
  }
}
