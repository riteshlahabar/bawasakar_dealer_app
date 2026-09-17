import 'package:get/get.dart';

import '../../../app/data/cache/json_cache_store.dart';
import '../../../app/data/services/address_selection_service.dart';
import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(Get.find<JsonCacheStore>()), permanent: true);
    }
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<AuthStorage>()), fenix: true);
    Get.lazyPut<DealerApiService>(() => DealerApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(Get.find<DealerApiService>(), Get.find<CartService>(), Get.find<AddressSelectionService>()),
    );
  }
}
