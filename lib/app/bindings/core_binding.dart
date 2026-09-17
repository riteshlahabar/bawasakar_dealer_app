import 'package:get/get.dart';

import '../core/security/get_session_expiry_handler.dart';
import '../core/security/session_expiry_handler.dart';
import '../data/cache/file_json_cache_store.dart';
import '../data/cache/json_cache_store.dart';
import '../data/services/address_selection_service.dart';
import '../data/services/api_client.dart';
import '../data/services/auth_storage.dart';
import '../data/services/cart_service.dart';
import '../data/services/dealer_api_service.dart';
import '../data/services/notification_api_service.dart';
import '../localization/locale_storage.dart';
import '../localization/translation_api_service.dart';
import '../localization/translation_service.dart';
import '../../modules/notifications/controllers/notifications_controller.dart';

/// Wires the app-wide singletons.
///
/// Every dependency is registered against the type its consumers ask for, so a
/// test (or a future rewrite) can substitute an implementation without editing
/// the modules that use it.
class CoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JsonCacheStore>(
      () => FileJsonCacheStore(),
      fenix: true,
    );

    // Created after the cache store so a saved cart can be restored.
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(Get.find<JsonCacheStore>()), permanent: true);
    }

    Get.lazyPut<SessionExpiryHandler>(
      () => GetSessionExpiryHandler(
        Get.find<AuthStorage>(),
        Get.find<JsonCacheStore>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<AuthStorage>(),
        onExpired: Get.find<SessionExpiryHandler>(),
      ),
      fenix: true,
    );

    Get.lazyPut<DealerApiService>(
      () => DealerApiService(Get.find<ApiClient>()),
      fenix: true,
    );

    // Chosen delivery address, shared by the cart and checkout.
    Get.lazyPut<AddressSelectionService>(
      () => AddressSelectionService(Get.find<DealerApiService>()),
      fenix: true,
    );

    // Language: registered permanent so every screen and the ApiClient can
    // read the active locale without re-creating the map.
    Get.lazyPut<TranslationApiService>(
      () => TranslationApiService(Get.find<ApiClient>()),
      fenix: true,
    );
    if (!Get.isRegistered<TranslationService>()) {
      Get.put<TranslationService>(
        TranslationService(
          Get.find<TranslationApiService>(),
          Get.find<LocaleStorage>(),
          Get.find<JsonCacheStore>(),
        ),
        permanent: true,
      );
    }

    // Global so the shell's bell can carry an unread badge on every tab.
    Get.lazyPut<NotificationApiService>(
      () => NotificationApiService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(
        Get.find<NotificationApiService>(),
        Get.find<AuthStorage>(),
      ),
      fenix: true,
    );
  }
}
