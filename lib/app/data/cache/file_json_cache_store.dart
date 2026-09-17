import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'json_cache_store.dart';

/// [JsonCacheStore] backed by one JSON file per key in the app's private
/// support directory. Every failure is swallowed: a broken cache must never
/// break a screen, it just means the next load comes from the server.
class FileJsonCacheStore implements JsonCacheStore {
  Directory? _directory;

  @override
  Future<Map<String, dynamic>?> read(String key) async {
    try {
      final file = await _file(key);

      if (!await file.exists()) {
        return null;
      }

      final decoded = jsonDecode(await file.readAsString());

      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, Map<String, dynamic> value) async {
    try {
      final file = await _file(key);
      final temp = File('${file.path}.tmp');

      // Write then rename, so a crash mid-write never leaves a half file.
      await temp.writeAsString(jsonEncode(value), flush: true);
      await temp.rename(file.path);
    } catch (_) {
      // Caching is best effort.
    }
  }

  @override
  Future<void> clear() async {
    try {
      final directory = await _cacheDirectory();

      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    } catch (_) {
      // Nothing to clear.
    } finally {
      _directory = null;
    }
  }

  Future<File> _file(String key) async {
    final safeKey = key.replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '_');
    final directory = await _cacheDirectory();

    return File('${directory.path}${Platform.pathSeparator}$safeKey.json');
  }

  Future<Directory> _cacheDirectory() async {
    final existing = _directory;

    if (existing != null) {
      return existing;
    }

    final base = await getApplicationSupportDirectory();
    final directory = Directory('${base.path}${Platform.pathSeparator}api_cache');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return _directory = directory;
  }
}
