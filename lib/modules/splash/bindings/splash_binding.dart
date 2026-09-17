import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // CartService is registered once by CoreBinding (with its saved cart).
    Get.put<SplashController>(SplashController());
  }
}
