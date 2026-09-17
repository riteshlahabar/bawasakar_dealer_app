import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/localization/t.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController(this._api);

  static const minLength = 8;

  final DealerApiService _api;

  final current = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();

  /// Accounts created by mobile OTP have no password, so no current one is asked.
  final hasPassword = true.obs;
  final isChecking = true.obs;
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    _checkPassword();
  }

  Future<void> _checkPassword() async {
    try {
      hasPassword.value = await _api.hasPassword();
    } catch (_) {
      // Asking for the current password is the safe default.
      hasPassword.value = true;
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> submit() async {
    if (hasPassword.value && current.text.isEmpty) {
      Get.snackbar(t('common.required'), t('password.enter_current'));
      return;
    }
    if (password.text.length < minLength) {
      Get.snackbar(t('password.too_short'), t('password.min_length', {'n': '$minLength'}));
      return;
    }
    if (password.text != confirmation.text) {
      Get.snackbar(t('password.no_match'), t('password.no_match_message'));
      return;
    }

    isLoading.value = true;
    try {
      await _api.changePassword(
        currentPassword: hasPassword.value ? current.text : null,
        password: password.text,
        confirmation: confirmation.text,
      );
      Get.back<void>();
      Get.snackbar(t('password.changed'), t('password.changed_message'));
    } catch (error) {
      Get.snackbar(t('password.change_failed'), error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    current.dispose();
    password.dispose();
    confirmation.dispose();
    super.onClose();
  }
}
