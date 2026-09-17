import 'dart:async';

import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/localization/translation_service.dart';
import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthStorage _storage = Get.find<AuthStorage>();

  @override
  void onReady() {
    super.onReady();
    _loadTranslations();
    Future<void>.delayed(const Duration(seconds: 5), () {
      Get.offAllNamed(_storage.isLoggedIn ? AppRoutes.main : AppRoutes.login);
    });
  }

  /// The splash already waits five seconds, so the cached strings load and the
  /// server refresh runs before the first real screen is drawn.
  Future<void> _loadTranslations() async {
    if (!Get.isRegistered<TranslationService>()) return;

    final translations = Get.find<TranslationService>();
    await translations.load();
    unawaited(translations.refresh());
  }
}
