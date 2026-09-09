import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/routes/app_routes.dart';

class AuthController extends GetxController {
  AuthController(
    this._api,
    this._storage,
  );

  final DealerApiService _api;
  final AuthStorage _storage;

  // 0 = Mobile OTP
  // 1 = Email / Password
  final loginMode = 0.obs;

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

    final enteredMobile =
        mobileController.text.trim();

    final dealerName =
        nameController.text.trim();

    final firmName =
        firmNameController.text.trim();

    final gstNumber =
        gstController.text.trim();

    if (dealerName.length < 3) {
      Get.snackbar(
        'Dealer Name Required',
        'Enter dealer owner/contact name.',
      );
      return;
    }

    if (firmName.length < 2) {
      Get.snackbar(
        'Firm Name Required',
        'Enter shop/firm name.',
      );
      return;
    }

    if (!_isValidMobile(enteredMobile)) {
      Get.snackbar(
        'Mobile Required',
        'Enter a valid 10 digit mobile number.',
      );
      return;
    }

    isLoading.value = true;

    try {
      await _api.requestOtp(
        enteredMobile,
      );

      // Save data required by dealer OTP verification.
      mobile.value = enteredMobile;
      dealerNameForOtp.value = dealerName;
      firmNameForOtp.value = firmName;
      gstForOtp.value = gstNumber;

      // Always start with empty OTP.
      otpController.clear();

      Get.toNamed(
        AppRoutes.otp,
      );
    } catch (error) {
      Get.snackbar(
        'OTP Failed',
        _errorMessage(error),
      );
    } finally {
      isLoading.value = false;
    }
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

    final enteredOtp =
        otpController.text.trim();

    if (mobile.value.trim().isEmpty) {
      Get.snackbar(
        'Mobile Missing',
        'Please request OTP again.',
      );

      Get.offAllNamed(
        AppRoutes.login,
      );

      return;
    }

    if (enteredOtp.length != 6) {
      Get.snackbar(
        'OTP Required',
        'Enter the 6 digit OTP.',
      );
      return;
    }

    if (!GetUtils.isNumericOnly(
      enteredOtp,
    )) {
      Get.snackbar(
        'Invalid OTP',
        'OTP must contain only numbers.',
      );
      return;
    }

    isLoading.value = true;

    try {
      final response =
          await _api.verifyOtp(
        mobile: mobile.value.trim(),
        otp: enteredOtp,
        name:
            dealerNameForOtp.value.trim(),
        firmName:
            firmNameForOtp.value.trim(),
        gstNumber:
            gstForOtp.value.trim(),
      );

      final loggedIn =
          await _saveFromResponse(
        response,
        fallbackMobile:
            mobile.value.trim(),
      );

      if (loggedIn) {
        otpController.clear();

        Get.offAllNamed(
          AppRoutes.main,
        );

        return;
      }

      // Registration completed successfully,
      // but backend did not return a token.
      // For a new dealer this means admin approval
      // is still required.
      otpController.clear();

      Get.offAllNamed(
        AppRoutes.login,
      );

      Get.snackbar(
        'Approval Pending',
        'Dealer registration completed successfully. '
            'Admin approval is required before dealer product access.',
        snackPosition: SnackPosition.BOTTOM,
        duration:
            const Duration(seconds: 5),
      );
    } catch (error) {
      Get.snackbar(
        'OTP Verification Failed',
        _errorMessage(error),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend OTP for the currently entered dealer mobile.
  Future<void> resendOtp() async {
    if (isLoading.value) {
      return;
    }

    final mobileNo =
        mobile.value.trim();

    if (!_isValidMobile(mobileNo)) {
      Get.snackbar(
        'Mobile Missing',
        'Please return to login and enter your mobile number again.',
      );
      return;
    }

    isLoading.value = true;

    try {
      await _api.requestOtp(
        mobileNo,
      );

      otpController.clear();

      Get.snackbar(
        'OTP Sent',
        'A new OTP has been requested.',
      );
    } catch (error) {
      Get.snackbar(
        'OTP Failed',
        _errorMessage(error),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Dealer email/password login.
  ///
  /// Laravel already provides:
  /// POST /api/v1/auth/dealer/login
  Future<void> loginWithEmail() async {
    if (isLoading.value) {
      return;
    }

    final email =
        emailController.text.trim();

    final password =
        passwordController.text;

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Email Required',
        'Enter a valid email address.',
      );
      return;
    }

    if (password.trim().isEmpty) {
      Get.snackbar(
        'Password Required',
        'Enter your password.',
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Password Required',
        'Password must be at least 6 characters.',
      );
      return;
    }

    isLoading.value = true;

    try {
      final response =
          await _api.emailLogin(
        email: email,
        password: password,
      );

      final loggedIn =
          await _saveFromResponse(
        response,
        fallbackEmail: email,
      );

      if (loggedIn) {
        passwordController.clear();

        Get.offAllNamed(
          AppRoutes.main,
        );

        return;
      }

      Get.snackbar(
        'Approval Pending',
        'Your dealer account is waiting for admin approval.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Login Failed',
        _errorMessage(error),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Dealer signup.
  ///
  /// Signup uses mobile OTP registration.
  Future<void> signup() async {
    if (isLoading.value) {
      return;
    }

    final name =
        signupName.text.trim();

    final firm =
        signupFirmName.text.trim();

    final mobileNo =
        signupMobile.text.trim();

    final email =
        signupEmail.text.trim();

    final gst =
        signupGst.text.trim();

    if (name.length < 3) {
      Get.snackbar(
        'Name Required',
        'Enter dealer owner/contact name.',
      );
      return;
    }

    if (firm.length < 2) {
      Get.snackbar(
        'Firm Name Required',
        'Enter shop/firm name.',
      );
      return;
    }

    if (!_isValidMobile(mobileNo)) {
      Get.snackbar(
        'Mobile Required',
        'Enter a valid 10 digit mobile number.',
      );
      return;
    }

    if (email.isNotEmpty &&
        !GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Enter a valid email address or leave it blank.',
      );
      return;
    }

    // Fill the normal OTP registration fields.
    mobileController.text = mobileNo;
    nameController.text = name;
    firmNameController.text = firm;
    gstController.text = gst;

    // Store optional email locally for later use if required.
    if (email.isNotEmpty) {
      emailController.text = email;
    }

    await requestOtp();
  }

  /// Reads Laravel login / OTP response.
  ///
  /// Returns:
  /// true  = valid token received
  /// false = request succeeded but no token was returned,
  ///         usually because dealer approval is pending.
  Future<bool> _saveFromResponse(
    Map<String, dynamic> response, {
    String fallbackMobile = '',
    String fallbackEmail = '',
  }) async {
    final rawData =
        response['data'] ?? response;

    if (rawData is! Map) {
      throw const FormatException(
        'Invalid response received from server.',
      );
    }

    final data =
        Map<String, dynamic>.from(
      rawData,
    );

    final rawUser =
        data['user'];

    final user = rawUser is Map
        ? Map<String, dynamic>.from(
            rawUser,
          )
        : <String, dynamic>{};

    final token =
        (data['token'] ??
                data['access_token'])
            ?.toString()
            .trim() ??
        '';

    // No token is valid for a newly registered
    // dealer waiting for admin approval.
    if (token.isEmpty) {
      return false;
    }

    final serverName =
        user['name']
                ?.toString()
                .trim() ??
            '';

    final serverMobile =
        user['mobile']
                ?.toString()
                .trim() ??
            '';

    final serverEmail =
        user['email']
                ?.toString()
                .trim() ??
            '';

    final name = serverName.isNotEmpty
        ? serverName
        : dealerNameForOtp.value
                .trim()
                .isNotEmpty
            ? dealerNameForOtp.value
                .trim()
            : 'Dealer';

    final savedMobile =
        serverMobile.isNotEmpty
            ? serverMobile
            : fallbackMobile.trim();

    final savedEmail =
        serverEmail.isNotEmpty
            ? serverEmail
            : fallbackEmail.trim();

    await _storage.saveSession(
      token: token,
      name: name,
      mobile: savedMobile,
      email: savedEmail,
    );

    return true;
  }

  bool _isValidMobile(
    String value,
  ) {
    final mobile =
        value.replaceAll(
      RegExp(r'\s+'),
      '',
    );

    return RegExp(
      r'^[0-9]{10}$',
    ).hasMatch(mobile);
  }

  String _errorMessage(
    Object error,
  ) {
    var message =
        error.toString().trim();

    if (message.startsWith(
      'Exception: ',
    )) {
      message = message.substring(
        'Exception: '.length,
      );
    }

    if (message.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    return message;
  }

  /// Clear registration-related temporary fields.
  void clearRegistrationData() {
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

    mobile.value = '';
    dealerNameForOtp.value = '';
    firmNameForOtp.value = '';
    gstForOtp.value = '';
  }

  @override
  void onClose() {
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

    super.onClose();
  }
}