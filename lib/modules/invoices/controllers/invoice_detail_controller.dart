import 'package:get/get.dart';

import '../../../app/data/models/invoice_detail_model.dart';
import '../../../app/data/services/order_document_api_service.dart';
import '../services/invoice_file_opener.dart';
import '../../../app/localization/t.dart';

/// One invoice, opened from the invoice list or from an order.
class InvoiceDetailController extends GetxController {
  InvoiceDetailController(this._api, this._files, this.invoiceId);

  final OrderDocumentApiService _api;
  final InvoiceFileOpener _files;
  final int invoiceId;

  final invoice = Rxn<InvoiceDetailModel>();
  final isLoading = false.obs;
  final isDownloading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    if (invoiceId <= 0) {
      error.value = t('invoice.not_found');
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      invoice.value = await _api.invoiceDetail(invoiceId);
    } catch (failure) {
      error.value = failure.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> download() async {
    if (isDownloading.value) return;

    isDownloading.value = true;
    try {
      await _files.openPdf(invoiceId, invoiceNo: invoice.value?.invoiceNo);
    } finally {
      isDownloading.value = false;
    }
  }
}
