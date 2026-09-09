import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthStorage _storage = Get.find<AuthStorage>();

  @override
  void onReady() {
    super.onReady();
    Future<void>.delayed(const Duration(milliseconds: 850), () {
      Get.offAllNamed(_storage.isLoggedIn ? AppRoutes.main : AppRoutes.login);
    });
  }
}
