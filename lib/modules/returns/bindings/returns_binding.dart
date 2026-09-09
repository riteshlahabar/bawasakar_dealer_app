import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/order_document_api_service.dart';
import '../controllers/returns_controller.dart';

class ReturnsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDocumentApiService>(() => OrderDocumentApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<ReturnsController>(() => ReturnsController(Get.find<OrderDocumentApiService>()));
  }
}
