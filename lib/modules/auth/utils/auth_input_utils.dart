import 'package:get/get.dart';
import '../../../app/localization/t.dart';

/// A validation failure: a snackbar title paired with its message.
class AuthValidationError {
  const AuthValidationError(this.title, this.message);

  final String title;
  final String message;
}

/// Stateless validation / formatting helpers shared by the OTP,
/// registration and email/password auth flows.
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
      return t('common.something_wrong');
    }

    return message;
  }

  /// Login and registration both start with the mobile number only; firm
  /// details are checked by [validateRegistration] after OTP verification.
  static AuthValidationError? validateOtpRequest({required String mobile}) {
    if (!isValidMobile(mobile)) {
      return AuthValidationError(
        t('auth.mobile_required'),
        t('auth.enter_valid_mobile_10'),
      );
    }

    return null;
  }

  static AuthValidationError? validateOtpCode(String otp) {
    if (otp.length != 6) {
      return AuthValidationError(
        t('auth.otp_required'),
        t('auth.enter_otp_the'),
      );
    }

    if (!GetUtils.isNumericOnly(otp)) {
      return AuthValidationError(
        t('auth.invalid_otp'),
        t('auth.otp_numbers_only'),
      );
    }

    return null;
  }

  static AuthValidationError? validateEmailLogin({
    required String email,
    required String password,
  }) {
    if (!GetUtils.isEmail(email)) {
      return AuthValidationError(
        t('auth.email_required'),
        t('auth.enter_valid_email'),
      );
    }

    if (password.trim().isEmpty) {
      return AuthValidationError(
        t('auth.password_required'),
        t('auth.enter_password'),
      );
    }

    if (password.length < 6) {
      return AuthValidationError(
        t('auth.password_required'),
        t('auth.password_min'),
      );
    }

    return null;
  }

  static AuthValidationError? validateRegistration({
    required String name,
    required String firm,
    required String gst,
  }) {
    if (name.length < 3) {
      return AuthValidationError(
        t('auth.name_required'),
        t('auth.enter_contact_name'),
      );
    }

    if (firm.length < 2) {
      return AuthValidationError(
        t('auth.firm_name_required'),
        t('auth.enter_firm_name'),
      );
    }

    if (gst.isNotEmpty && !RegExp(r'^[0-9]{2}[A-Z0-9]{13}$').hasMatch(gst)) {
      return AuthValidationError(
        t('auth.invalid_gst'),
        t('auth.enter_valid_gst'),
      );
    }

    return null;
  }
}
