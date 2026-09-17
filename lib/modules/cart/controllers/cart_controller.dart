import 'package:get/get.dart';

import '../../../app/data/models/credit_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/address_selection_service.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/data/services/dealer_credit_api_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/order_products.dart';
import '../../../app/localization/t.dart';

class CartController extends GetxController {
  CartController(this.cart, this.addresses, this._api, this._credit);

  final CartService cart;
  final AddressSelectionService addresses;
  final DealerApiService _api;
  final DealerCreditApiService _credit;

  final credit = Rxn<CreditModel>();

  /// Products from past orders, shown on the empty cart.
  final recentProducts = <ProductModel>[].obs;

  /// Credit still available, or null when the dealer has no credit limit.
  double? get availableCredit {
    final value = credit.value;
    if (value == null || value.creditLimit <= 0) return null;

    final available = value.creditLimit - value.outstandingBalance;
    return available < 0 ? 0 : available;
  }

  bool get exceedsCredit => availableCredit != null && cart.subtotal > availableCredit!;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    await Future.wait([_loadCredit(), addresses.load(), _loadRecentProducts()]);
  }

  void increase(ProductModel product) => cart.add(product);
  void decrease(ProductModel product) => cart.decrease(product);
  void remove(ProductModel product) => cart.remove(product);
  void saveForLater(ProductModel product) => cart.saveForLater(product);
  void moveToCart(ProductModel product) => cart.moveToCart(product);
  void removeSaved(ProductModel product) => cart.removeSaved(product);

  void addToCart(ProductModel product) {
    cart.add(product);
    Get.snackbar(t('common.added'), t('common.added_to_cart', {'name': product.name}), snackPosition: SnackPosition.BOTTOM);
  }

  void checkout() {
    if (cart.items.isEmpty) {
      Get.snackbar(t('cart.empty_checkout_title'), t('cart.empty_checkout_dealer'));
      return;
    }
    Get.toNamed(AppRoutes.checkout);
  }

  Future<void> _loadCredit() async {
    try {
      credit.value = await _credit.outstanding();
    } catch (_) {
      // The banner simply stays hidden.
    }
  }

  Future<void> _loadRecentProducts() async {
    try {
      recentProducts.assignAll(OrderProducts.fromOrdersResponse(await _api.orders()).take(10));
    } catch (_) {
      // Empty cart still shows "Shop Now".
    }
  }
}
