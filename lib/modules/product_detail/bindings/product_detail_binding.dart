import 'package:get/get.dart';

import '../../../app/data/services/cart_service.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(), permanent: true);
    }
    Get.lazyPut<ProductDetailController>(() => ProductDetailController(Get.find<CartService>()));
  }
}
