import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../services/email_auth_service.dart';
import '../services/otp_auth_service.dart';
import '../services/otp_verify_result.dart';
import '../utils/auth_form_fields.dart';
import '../utils/auth_input_utils.dart';
import '../../../app/localization/t.dart';

class AuthController extends GetxController {
  AuthController(
    this._otpAuth,
    this._emailAuth,
  );

  final OtpAuthService _otpAuth;
  final EmailAuthService _emailAuth;

  /// Every TextEditingController used across the login/signup/OTP forms.
  final forms = AuthFormFields();

  // 0 = Mobile OTP
  // 1 = Email / Password
  final loginMode = 0.obs;

  final isLoading = false.obs;

  /// Mobile the current OTP was sent to.
  final mobile = ''.obs;

  /// True when the OTP screen was reached from registration, so it can show
  /// the registration steps.
  final isRegistering = false.obs;

  void changeLoginMode(int mode) {
    loginMode.value = mode;
  }

  /// Login: send OTP to the mobile entered on the login screen.
  Future<void> requestOtp() {
    isRegistering.value = false;
    return _sendOtp(forms.mobileController.text.trim());
  }

  /// Registration step 1: send OTP to the mobile entered on the signup screen.
  Future<void> startRegistration() {
    isRegistering.value = true;
    return _sendOtp(forms.signupMobile.text.trim());
  }

  /// Verify OTP (registration step 2 / login).
  ///
  /// Registered dealer: logged in, or told approval is pending.
  /// New number: continues to the firm-details form.
  Future<void> verifyOtp() async {
    if (isLoading.value) {
      return;
    }

    final enteredOtp = forms.otpController.text.trim();
    final verifiedMobile = mobile.value.trim();

    if (verifiedMobile.isEmpty) {
      Get.snackbar(t('auth.mobile_missing'), t('auth.request_otp_again'));
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    final error = AuthInputUtils.validateOtpCode(enteredOtp);

    if (error != null) {
      Get.snackbar(error.title, error.message);
      return;
    }

    await _guarded(t('auth.otp_verification_failed'), () async {
      final result = await _otpAuth.verifyOtp(mobile: verifiedMobile, otp: enteredOtp);

      forms.otpController.clear();

      switch (result.status) {
        case OtpVerifyStatus.loggedIn:
          Get.offAllNamed(AppRoutes.main);
        case OtpVerifyStatus.registrationRequired:
          Get.offNamed(AppRoutes.registrationDetails, arguments: {
            'mobile': verifiedMobile,
            'registrationToken': result.registrationToken,
          });
        case OtpVerifyStatus.approvalPending:
          Get.offAllNamed(AppRoutes.login);
          Get.snackbar(
            t('auth.approval_pending'),
            t('auth.approval_pending_message'),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
      }
    });
  }

  /// Resend OTP for the current mobile.
  Future<void> resendOtp() async {
    if (isLoading.value) {
      return;
    }

    final mobileNo = mobile.value.trim();

    if (!AuthInputUtils.isValidMobile(mobileNo)) {
      Get.snackbar(
        t('auth.mobile_missing'),
        t('auth.enter_mobile_again'),
      );
      return;
    }

    await _guarded(t('auth.otp_failed'), () async {
      await _otpAuth.requestOtp(mobileNo);
      forms.otpController.clear();
      Get.snackbar(t('auth.otp_sent'), t('auth.otp_resent'));
    });
  }

  /// Dealer email/password login.
  ///
  /// Laravel endpoint:
  /// POST /api/v1/auth/dealer/login
  Future<void> loginWithEmail() async {
    if (isLoading.value) {
      return;
    }

    final email = forms.emailController.text.trim();
    final password = forms.passwordController.text;

    final error = AuthInputUtils.validateEmailLogin(
      email: email,
      password: password,
    );

    if (error != null) {
      Get.snackbar(error.title, error.message);
      return;
    }

    await _guarded(t('auth.login_failed'), () async {
      final loggedIn = await _emailAuth.login(
        email: email,
        password: password,
        fallbackName: t('common.dealer'),
      );

      if (loggedIn) {
        forms.passwordController.clear();
        Get.offAllNamed(AppRoutes.main);
        return;
      }

      Get.snackbar(
        t('auth.approval_pending'),
        t('auth.approval_pending_message'),
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> _sendOtp(String enteredMobile) async {
    if (isLoading.value) {
      return;
    }

    final error = AuthInputUtils.validateOtpRequest(mobile: enteredMobile);

    if (error != null) {
      Get.snackbar(error.title, error.message);
      return;
    }

    await _guarded(t('auth.otp_failed'), () async {
      await _otpAuth.requestOtp(enteredMobile);

      mobile.value = enteredMobile;

      // Always start with empty OTP.
      forms.otpController.clear();

      Get.toNamed(AppRoutes.otp);
    });
  }

  /// Runs [action] while `isLoading` is true, reporting any error as a
  /// snackbar titled [errorTitle].
  Future<void> _guarded(
    String errorTitle,
    Future<void> Function() action,
  ) async {
    isLoading.value = true;

    try {
      await action();
    } catch (error) {
      Get.snackbar(errorTitle, AuthInputUtils.errorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    forms.dispose();
    super.onClose();
  }
}
