import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/dealer_credit_api_service.dart';
import '../controllers/payments_controller.dart';

class PaymentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DealerCreditApiService>(() => DealerCreditApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<PaymentsController>(() => PaymentsController(Get.find<DealerCreditApiService>()));
  }
}
