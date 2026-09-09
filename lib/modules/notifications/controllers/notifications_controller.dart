import 'package:get/get.dart';

import '../../../app/data/models/notification_model.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/notification_api_service.dart';

/// Owns the notification inbox and its unread badge count.
class NotificationsController extends GetxController {
  NotificationsController(this._api, this._session);

  final NotificationApiService _api;
  final AuthStorage _session;

  final items = <NotificationModel>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;
  final error = ''.obs;

  bool get isEmpty => items.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    // A guest has no inbox. Calling the endpoint anyway would 401 and the
    // session handler would bounce them to login just for opening the app.
    if (!_session.isLoggedIn) {
      items.clear();
      unreadCount.value = 0;
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      final result = await _api.list();
      items.assignAll(result.items);
      unreadCount.value = result.unread;
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAllRead() async {
    if (unreadCount.value == 0) return;
    try {
      await _api.markRead();
      await load();
    } catch (failure) {
      Get.snackbar('Notifications', failure.toString());
    }
  }

  Future<void> markRead(NotificationModel notification) async {
    if (!notification.isUnread) return;
    try {
      await _api.markRead([notification.id]);
      await load();
    } catch (failure) {
      Get.snackbar('Notifications', failure.toString());
    }
  }
}
