import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../services/email_auth_service.dart';
import '../services/otp_auth_service.dart';
import '../utils/auth_form_fields.dart';
import '../utils/auth_input_utils.dart';

class AuthController extends GetxController {
  AuthController(
    this._otpAuth,
    this._emailAuth,
  );

  final OtpAuthService _otpAuth;
  final EmailAuthService _emailAuth;

  /// Every TextEditingController used across the login/OTP/signup forms.
  final forms = AuthFormFields();

  // 0 = Mobile OTP
  // 1 = Email / Password
  final loginMode = 0.obs;

  final isLoading = false.obs;

  // Temporary values used between OTP request and OTP verification.
  final mobile = ''.obs;
  final dealerNameForOtp = ''.obs;
  final firmNameForOtp = ''.obs;
  final gstForOtp = ''.obs;

  /// Switch login type:
  /// 0 = Mobile OTP
  /// 1 = Email/password
  void changeLoginMode(int mode) {
    loginMode.value = mode;
  }

  /// Request dealer OTP.
  ///
  /// Laravel endpoint:
  /// POST /api/v1/auth/otp/request
  Future<void> requestOtp() async {
    if (isLoading.value) {
      return;
    }

    final enteredMobile = forms.mobileController.text.trim();
    final dealerName = forms.nameController.text.trim();
    final firmName = forms.firmNameController.text.trim();
    final gstNumber = forms.gstController.text.trim();

    final error = AuthInputUtils.validateOtpRequest(
      dealerName: dealerName,
      firmName: firmName,
      mobile: enteredMobile,
    );

    if (error != null) {
      Get.snackbar(error.title, error.message);
      return;
    }

    await _guarded('OTP Failed', () async {
      await _otpAuth.requestOtp(enteredMobile);

      // Save data required by dealer OTP verification.
      mobile.value = enteredMobile;
      dealerNameForOtp.value = dealerName;
      firmNameForOtp.value = firmName;
      gstForOtp.value = gstNumber;

      // Always start with empty OTP.
      forms.otpController.clear();

      Get.toNamed(AppRoutes.otp);
    });
  }

  /// Verify OTP and login/register dealer.
  ///
  /// New dealer:
  /// Laravel may return user without token until admin approval.
  ///
  /// Approved dealer:
  /// Laravel returns token and app opens dealer dashboard.
  Future<void> verifyOtp() async {
    if (isLoading.value) {
      return;
    }

    final enteredOtp = forms.otpController.text.trim();

    if (mobile.value.trim().isEmpty) {
      Get.snackbar('Mobile Missing', 'Please request OTP again.');
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    final error = AuthInputUtils.validateOtpCode(enteredOtp);

    if (error != null) {
      Get.snackbar(error.title, error.message);
      return;
    }

    await _guarded('OTP Verification Failed', () async {
      final dealerName = dealerNameForOtp.value.trim();

      final loggedIn = await _otpAuth.verifyOtp(
        mobile: mobile.value.trim(),
        otp: enteredOtp,
        name: dealerName,
        firmName: firmNameForOtp.value.trim(),
        gstNumber: gstForOtp.value.trim(),
        fallbackName: dealerName.isNotEmpty ? dealerName : 'Dealer',
      );

      if (loggedIn) {
        forms.otpController.clear();
        Get.offAllNamed(AppRoutes.main);
        return;
      }

      // Registration completed successfully, but backend did not return a
      // token. For a new dealer this means admin approval is still
      // required.
      forms.otpController.clear();
      Get.offAllNamed(AppRoutes.login);

      Get.snackbar(
        'Approval Pending',
        'Dealer registration completed successfully. '
            'Admin approval is required before dealer product access.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    });
  }

  /// Resend OTP for the currently entered dealer mobile.
  Future<void> resendOtp() async {
    if (isLoading.value) {
      return;
    }

    final mobileNo = mobile.value.trim();

    if (!AuthInputUtils.isValidMobile(mobileNo)) {
      Get.snackbar(
        'Mobile Missing',
        'Please return to login and enter your mobile number again.',
      );
      return;
    }

    await _guarded('OTP Failed', () async {
      await _otpAuth.requestOtp(mobileNo);
      forms.otpController.clear();
      Get.snackbar('OTP Sent', 'A new OTP has been requested.');
    });
  }

  /// Dealer email/password login.
  ///
  /// Laravel already provides:
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

    await _guarded('Login Failed', () async {
      final dealerName = dealerNameForOtp.value.trim();

      final loggedIn = await _emailAuth.login(
        email: email,
        password: password,
        fallbackName: dealerName.isNotEmpty ? dealerName : 'Dealer',
      );

      if (loggedIn) {
        forms.passwordController.clear();
        Get.offAllNamed(AppRoutes.main);
        return;
      }

      Get.snackbar(
        'Approval Pending',
        'Your dealer account is waiting for admin approval.',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  /// Dealer signup.
  ///
  /// Signup uses mobile OTP registration.
  Future<void> signup() async {
    if (isLoading.value) {
      return;
    }

    final name = forms.signupName.text.trim();
    final firm = forms.signupFirmName.text.trim();
    final mobileNo = forms.signupMobile.text.trim();
    final email = forms.signupEmail.text.trim();
    final gst = forms.signupGst.text.trim();

    final error = AuthInputUtils.validateSignup(
      name: name,
      firm: firm,
      mobile: mobileNo,
      email: email,
    );

    if (error != null) {
      Get.snackbar(error.title, error.message);
      return;
    }

    // Fill the normal OTP registration fields.
    forms.mobileController.text = mobileNo;
    forms.nameController.text = name;
    forms.firmNameController.text = firm;
    forms.gstController.text = gst;

    // Store optional email locally for later use if required.
    if (email.isNotEmpty) {
      forms.emailController.text = email;
    }

    await requestOtp();
  }

  /// Clear registration-related temporary fields.
  void clearRegistrationData() {
    forms.clearRegistration();

    mobile.value = '';
    dealerNameForOtp.value = '';
    firmNameForOtp.value = '';
    gstForOtp.value = '';
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
