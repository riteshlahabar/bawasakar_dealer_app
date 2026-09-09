import 'package:get/get.dart';

import '../../../app/data/models/invoice_model.dart';
import '../../../app/data/services/order_document_api_service.dart';

/// Lists invoices raised against the customer's orders.
class InvoicesController extends GetxController {
  InvoicesController(this._api);

  final OrderDocumentApiService _api;

  final invoices = <InvoiceModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  bool get isEmpty => invoices.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      invoices.assignAll(await _api.invoices());
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
