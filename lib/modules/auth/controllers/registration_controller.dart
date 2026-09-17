import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../location/controllers/location_form_controller.dart';
import '../services/otp_auth_service.dart';
import '../utils/auth_input_utils.dart';
import '../../../app/localization/t.dart';

/// Registration step 3: firm details for a mobile already verified by OTP.
///
/// Route arguments: `{'mobile': String, 'registrationToken': String}`.
class RegistrationController extends GetxController {
  RegistrationController(this._otpAuth, this.location);

  final OtpAuthService _otpAuth;
  final LocationFormController location;

  final nameController = TextEditingController();
  final firmNameController = TextEditingController();
  final gstController = TextEditingController();

  final isLoading = false.obs;

  String mobile = '';
  String _registrationToken = '';

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map) {
      mobile = args['mobile']?.toString() ?? '';
      _registrationToken = args['registrationToken']?.toString() ?? '';
    }
  }

  @override
  void onReady() {
    super.onReady();

    if (_registrationToken.isEmpty) {
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(t('auth.verification_required'), t('auth.verify_first'));
    }
  }

  Future<void> submit() async {
    if (isLoading.value) {
      return;
    }

    final name = nameController.text.trim();
    final firm = firmNameController.text.trim();
    final gst = gstController.text.trim().toUpperCase();

    final error = AuthInputUtils.validateRegistration(name: name, firm: firm, gst: gst);

    if (error != null) {
      Get.snackbar(error.title, error.message);
      return;
    }

    final locationError = location.validate();

    if (locationError != null) {
      Get.snackbar(t('location.title'), locationError);
      return;
    }

    isLoading.value = true;

    try {
      final loggedIn = await _otpAuth.registerDealer(
        registrationToken: _registrationToken,
        mobile: mobile,
        name: name,
        firmName: firm,
        gstNumber: gst,
        location: location.payload,
      );

      if (loggedIn) {
        Get.offAllNamed(AppRoutes.main);
        return;
      }

      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(
        t('auth.registration_submitted'),
        t('auth.registration_complete'),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (error) {
      Get.snackbar(t('auth.registration_failed'), AuthInputUtils.errorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    firmNameController.dispose();
    gstController.dispose();
    super.onClose();
  }
}
