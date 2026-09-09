import 'package:get/get.dart';

import '../../../app/data/models/credit_model.dart';
import '../../../app/data/services/dealer_credit_api_service.dart';

/// Payment history with its paid/pending totals.
class PaymentsController extends GetxController {
  PaymentsController(this._api);

  final DealerCreditApiService _api;

  final payments = <PaymentModel>[].obs;
  final paidTotal = 0.0.obs;
  final pendingTotal = 0.0.obs;
  final isLoading = false.obs;
  final error = ''.obs;

  bool get isEmpty => payments.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final result = await _api.payments();
      payments.assignAll(result.payments);
      paidTotal.value = result.paid;
      pendingTotal.value = result.pending;
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
