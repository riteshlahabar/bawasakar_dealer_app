import 'package:get/get.dart';

import '../../../app/data/models/invoice_model.dart';
import '../../../app/data/services/order_document_api_service.dart';
import '../services/invoice_file_opener.dart';

/// Lists invoices raised against the dealer's orders.
class InvoicesController extends GetxController {
  InvoicesController(this._api, this._files);

  final OrderDocumentApiService _api;
  final InvoiceFileOpener _files;

  final invoices = <InvoiceModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final search = ''.obs;

  /// Id of the invoice currently being downloaded, so only its row spins.
  final downloadingId = 0.obs;

  bool get isEmpty => invoices.isEmpty && !isLoading.value;

  List<InvoiceModel> get visibleInvoices {
    final term = search.value.trim().toLowerCase();
    if (term.isEmpty) return invoices;

    return invoices
        .where((invoice) =>
            invoice.invoiceNo.toLowerCase().contains(term) ||
            invoice.orderNo.toLowerCase().contains(term))
        .toList();
  }

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

  void onSearchChanged(String value) => search.value = value;

  Future<void> download(InvoiceModel invoice) async {
    if (downloadingId.value != 0) return;

    downloadingId.value = invoice.id;
    try {
      await _files.openPdf(invoice.id, invoiceNo: invoice.invoiceNo);
    } finally {
      downloadingId.value = 0;
    }
  }
}
