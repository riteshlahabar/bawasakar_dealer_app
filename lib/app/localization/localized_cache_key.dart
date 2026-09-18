import 'package:get/get.dart';

import 'app_locales.dart';
import 'translation_service.dart';

/// Catalog text (section titles, banners, product names) is translated by the
/// server, so each language keeps its own cached copy.
String localizedCacheKey(String base) {
  final locale = Get.isRegistered<TranslationService>()
      ? Get.find<TranslationService>().locale
      : AppLocales.fallback;

  return '${base}_$locale';
}
