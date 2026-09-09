import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/dealer_credit_api_service.dart';
import '../controllers/outstanding_controller.dart';

class OutstandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DealerCreditApiService>(() => DealerCreditApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<OutstandingController>(() => OutstandingController(Get.find<DealerCreditApiService>()));
  }
}
