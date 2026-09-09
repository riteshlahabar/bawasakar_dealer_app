import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../controllers/addresses_controller.dart';

class AddressesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<AuthStorage>()), fenix: true);
    Get.lazyPut<DealerApiService>(() => DealerApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<AddressesController>(() => AddressesController(Get.find<DealerApiService>()));
  }
}
