import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/return_request_model.dart';
import '../../../app/data/services/order_document_api_service.dart';

/// Lists the customer's returns and raises new ones.
class ReturnsController extends GetxController {
  ReturnsController(this._api);

  final OrderDocumentApiService _api;

  final requests = <ReturnRequestModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final error = ''.obs;
  final reasonInput = TextEditingController();

  bool get isEmpty => requests.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      requests.assignAll(await _api.returns());
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// The eligibility window and refund cap are enforced server side; a refusal
  /// comes back as a message the sheet shows verbatim.
  Future<bool> submit(int orderId) async {
    final reason = reasonInput.text.trim();
    if (reason.isEmpty) {
      Get.snackbar('Return', 'Tell us why you are returning this order.');
      return false;
    }

    isSubmitting.value = true;
    try {
      await _api.requestReturn(orderId: orderId, reason: reason);
      reasonInput.clear();
      await load();
      Get.snackbar('Return', 'Your return request has been submitted.');
      return true;
    } catch (failure) {
      Get.snackbar('Return', failure.toString());
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    reasonInput.dispose();
    super.onClose();
  }
}
