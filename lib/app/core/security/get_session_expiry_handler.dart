import 'package:get/get.dart';

import '../../data/cache/json_cache_store.dart';
import '../../data/services/auth_storage.dart';
import '../../routes/app_routes.dart';
import 'session_expiry_handler.dart';

/// Wipes the session (and the saved API responses) and returns to login when
/// the backend answers 401.
///
/// Guarded so a burst of parallel requests that all fail cannot trigger a
/// stack of login screens.
class GetSessionExpiryHandler implements SessionExpiryHandler {
  GetSessionExpiryHandler(this._storage, this._cache);

  final AuthStorage _storage;
  final JsonCacheStore _cache;
  bool _handling = false;

  @override
  Future<void> onSessionExpired() async {
    if (_handling) return;
    _handling = true;
    try {
      await _storage.clear();
      await _cache.clear();
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed<void>(AppRoutes.login);
      }
    } finally {
      _handling = false;
    }
  }
}
