/// Saves the last successful API response per key so a screen can show it
/// instantly on the next app open, then refresh from the server.
///
/// Only a display shortcut: prices and stock are always refreshed from the
/// server, and order totals are computed server-side.
abstract class JsonCacheStore {
  /// The saved response, or null when nothing (or nothing readable) is saved.
  Future<Map<String, dynamic>?> read(String key);

  Future<void> write(String key, Map<String, dynamic> value);

  /// Removes every saved response — called on logout / session expiry so the
  /// next dealer never sees the previous dealer's data.
  Future<void> clear();
}
