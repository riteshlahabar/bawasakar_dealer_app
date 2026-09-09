import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/routes/app_routes.dart';

class CartController extends GetxController {
  CartController(this.cart);

  final CartService cart;

  void increase(ProductModel product) => cart.add(product);
  void decrease(ProductModel product) => cart.decrease(product);
  void remove(ProductModel product) => cart.remove(product);

  void checkout() {
    if (cart.items.isEmpty) {
      Get.snackbar('Cart Empty', 'Add dealer products before checkout.');
      return;
    }
    Get.toNamed(AppRoutes.checkout);
  }
}
