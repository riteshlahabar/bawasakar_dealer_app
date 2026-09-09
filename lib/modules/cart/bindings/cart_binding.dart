import 'package:get/get.dart';

import '../../../app/data/services/cart_service.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(), permanent: true);
    }
    Get.lazyPut<CartController>(() => CartController(Get.find<CartService>()));
  }
}
