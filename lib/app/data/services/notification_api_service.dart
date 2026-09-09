import '../../config/api_config.dart';
import '../models/notification_model.dart';
import 'api_client.dart';

/// Notification inbox endpoints.
class NotificationApiService {
  NotificationApiService(this._client);

  final ApiClient _client;

  /// Returns the page of notifications plus the account-wide unread count,
  /// which the shell badge shows without a second request.
  Future<({List<NotificationModel> items, int unread})> list({int page = 1}) async {
    final response = await _client.getJson(
      ApiConfig.notifications,
      query: {'page': page},
    );
    final data = response['data'];
    final raw = data?['notifications'];

    return (
      items: raw is List
          ? raw
              .whereType<Map<String, dynamic>>()
              .map(NotificationModel.fromJson)
              .toList()
          : const <NotificationModel>[],
      unread: int.tryParse(data?['unread_count']?.toString() ?? '') ?? 0,
    );
  }

  /// An empty [ids] list marks the whole inbox read.
  Future<void> markRead([List<int> ids = const []]) =>
      _client.postJson(ApiConfig.notificationsRead, {'ids': ids});
}
