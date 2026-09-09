import 'package:get/get.dart';

import '../../../app/data/services/cart_service.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CartService>(CartService(), permanent: true);
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
