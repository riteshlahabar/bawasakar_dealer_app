import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/notification_api_service.dart';
import '../controllers/notifications_controller.dart';

/// Registered globally by [CoreBinding] so the shell can show an unread badge;
/// this route binding only guarantees it exists if the screen is opened
/// directly.
class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<NotificationsController>()) return;

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
