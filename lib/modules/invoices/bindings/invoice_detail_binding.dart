import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/invoice_download_service.dart';
import '../../../app/data/services/order_document_api_service.dart';
import '../controllers/invoice_detail_controller.dart';
import '../services/invoice_file_opener.dart';

class InvoiceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDocumentApiService>(() => OrderDocumentApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<InvoiceDownloadService>(() => InvoiceDownloadService(Get.find<AuthStorage>()), fenix: true);
    Get.lazyPut<InvoiceFileOpener>(() => InvoiceFileOpener(Get.find<InvoiceDownloadService>()), fenix: true);
    Get.lazyPut<InvoiceDetailController>(
      () => InvoiceDetailController(
        Get.find<OrderDocumentApiService>(),
        Get.find<InvoiceFileOpener>(),
        int.tryParse(Get.arguments?.toString() ?? '') ?? 0,
      ),
    );
  }
}
