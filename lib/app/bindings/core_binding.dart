import 'package:get/get.dart';

import '../core/security/get_session_expiry_handler.dart';
import '../core/security/session_expiry_handler.dart';
import '../data/services/api_client.dart';
import '../data/services/auth_storage.dart';
import '../data/services/cart_service.dart';
import '../data/services/dealer_api_service.dart';
import '../data/services/notification_api_service.dart';
import '../../modules/notifications/controllers/notifications_controller.dart';

/// Wires the app-wide singletons.
///
/// Every dependency is registered against the type its consumers ask for, so a
/// test (or a future rewrite) can substitute an implementation without editing
/// the modules that use it.
class CoreBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(), permanent: true);
    }

    Get.lazyPut<SessionExpiryHandler>(
      () => GetSessionExpiryHandler(Get.find<AuthStorage>()),
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
