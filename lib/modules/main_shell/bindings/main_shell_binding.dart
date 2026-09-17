import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/data/cache/json_cache_store.dart';
import '../../../app/data/services/address_selection_service.dart';
import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/data/services/dealer_credit_api_service.dart';
import '../../../app/data/services/order_document_api_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../catalog/controllers/catalog_controller.dart';
import '../../catalog/services/catalog_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/main_shell_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(Get.find<JsonCacheStore>()), permanent: true);
    }
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<AuthStorage>()), fenix: true);
    Get.lazyPut<DealerApiService>(() => DealerApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<OrderDocumentApiService>(() => OrderDocumentApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<DealerCreditApiService>(() => DealerCreditApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<MainShellController>(() => MainShellController(Get.find<AuthStorage>()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find<DealerApiService>(), Get.find<JsonCacheStore>()));
    Get.lazyPut<CatalogController>(
      () => CatalogController(CatalogRepository(Get.find<DealerApiService>(), Get.find<JsonCacheStore>())),
    );
    Get.lazyPut<CartController>(
      () => CartController(
        Get.find<CartService>(),
        Get.find<AddressSelectionService>(),
        Get.find<DealerApiService>(),
        Get.find<DealerCreditApiService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<OrdersController>(
      () => OrdersController(Get.find<DealerApiService>(), Get.find<OrderDocumentApiService>(), Get.find<CartService>()),
    );
    Get.lazyPut<OrdersController>(
      () => OrdersController(
        Get.find<DealerApiService>(),
        Get.find<OrderDocumentApiService>(),
        Get.find<CartService>(),
        history: true,
      ),
      tag: OrdersController.historyTag,
    );
    // fenix: also used by the Account page and the Logout chip.
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<DealerApiService>(), Get.find<AuthStorage>(), Get.find<JsonCacheStore>(), ImagePicker()),
      fenix: true,
    );
  }
}
