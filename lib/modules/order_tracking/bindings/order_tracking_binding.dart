import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/order_document_api_service.dart';
import '../controllers/order_tracking_controller.dart';

class OrderTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDocumentApiService>(() => OrderDocumentApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<OrderTrackingController>(() => OrderTrackingController(Get.find<OrderDocumentApiService>()));
  }
}
