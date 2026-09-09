import 'package:shared_preferences/shared_preferences.dart';

import '../../core/security/secure_key_value_store.dart';

/// Holds the signed-in dealer's session.
///
/// Values are persisted through an injected [SecureKeyValueStore] (Keystore on
/// Android, Keychain on iOS) and mirrored into memory so the rest of the app
/// keeps the cheap synchronous getters it already uses. Nothing here talks to
/// a plugin directly, so the whole class is testable with a fake store.
class AuthStorage {
  AuthStorage(this._store);

  static const _tokenKey = 'dealer_auth_token';
  static const _userNameKey = 'dealer_user_name';
  static const _mobileKey = 'dealer_mobile';
  static const _emailKey = 'dealer_email';

  static const _keys = <String>[_tokenKey, _userNameKey, _mobileKey, _emailKey];

  final SecureKeyValueStore _store;
  final Map<String, String> _cache = <String, String>{};

  Future<AuthStorage> init() async {
    for (final key in _keys) {
      final value = await _store.read(key);
      if (value != null && value.isNotEmpty) _cache[key] = value;
    }
    await _migrateLegacyPlaintextSession();
    return this;
  }

  String? get token => _cache[_tokenKey];
  String? get userName => _cache[_userNameKey];
  String? get mobile => _cache[_mobileKey];
  String? get email => _cache[_emailKey];

  bool get isLoggedIn => (token ?? '').isNotEmpty;

  Future<void> saveSession({
    required String token,
    required String name,
    String mobile = '',
    String email = '',
  }) async {
    await _put(_tokenKey, token.trim());
    await _put(_userNameKey, name.trim());
    await _put(_mobileKey, mobile.trim());
    await _put(_emailKey, email.trim());
  }

  Future<void> clear() async {
    _cache.clear();
    for (final key in _keys) {
      await _store.delete(key);
    }
  }

  Future<void> _put(String key, String value) async {
    if (value.isEmpty) {
      _cache.remove(key);
      await _store.delete(key);
      return;
    }
    _cache[key] = value;
    await _store.write(key, value);
  }

  /// Moves a session written by an older build out of SharedPreferences, where
  /// it sat unencrypted, and erases the plaintext copy. Runs once: after the
  /// move the legacy keys no longer exist.
  Future<void> _migrateLegacyPlaintextSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_tokenKey)) return;

    for (final key in _keys) {
      final legacy = prefs.getString(key);
      if (legacy != null && legacy.isNotEmpty && !_cache.containsKey(key)) {
        await _put(key, legacy);
      }
      await prefs.remove(key);
    }
  }
}
