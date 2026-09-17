import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/localization/t.dart';

class SupportController extends GetxController {
  SupportController(this._api);

  final DealerApiService _api;
  final subject = TextEditingController();
  final message = TextEditingController();
  final isLoading = false.obs;

  Future<void> submit() async {
    if (subject.text.trim().isEmpty || message.text.trim().isEmpty) {
      Get.snackbar(t('common.required'), t('support.enter_subject_message'));
      return;
    }
    isLoading.value = true;
    try {
      await _api.support(subject: subject.text.trim(), message: message.text.trim());
      Get.back<void>();
      Get.snackbar(t('support.sent'), t('support.sent_message'));
    } catch (error) {
      Get.snackbar(t('support.failed'), error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    subject.dispose(); message.dispose();
    super.onClose();
  }
}
