import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/localization/t.dart';

class ProductDetailController extends GetxController {
  ProductDetailController(this._cart);

  final CartService _cart;
  final quantity = 1.obs;

  ProductModel get product => Get.arguments as ProductModel;

  /// The pack size currently shown/added to cart — starts as the product's
  /// default variant and changes when the dealer picks another one.
  late final selected = product.obs;

  void selectVariant(int variantId) => selected.value = product.withVariant(variantId);

  void increase() => quantity.value++;
  void decrease() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    for (var i = 0; i < quantity.value; i++) {
      _cart.add(selected.value);
    }
    Get.snackbar(t('common.added'), t('common.added_to_cart', {'name': product.name}), snackPosition: SnackPosition.BOTTOM);
  }
}
