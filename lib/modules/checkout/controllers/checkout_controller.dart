import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/routes/app_routes.dart';

class CheckoutController extends GetxController {
  CheckoutController(this._api, this.cart);

  final DealerApiService _api;
  final CartService cart;

  final notes = TextEditingController();
  final paymentMethod = 'Pay Later / Credit'.obs;
  final isLoading = false.obs;

  Future<void> placeOrder() async {
    if (cart.items.isEmpty) {
      Get.snackbar('Cart Empty', 'Add dealer products before checkout.');
      return;
    }
    isLoading.value = true;
    try {
      final noteText = 'Dealer order from mobile app\nPayment: ${paymentMethod.value}\n${notes.text.trim()}';
      await _api.createOrder(cart.toOrderItems(), notes: noteText);
      cart.clear();
      Get.offAllNamed(AppRoutes.main);
      Get.snackbar('Order Submitted', 'Dealer order has been sent to assigned salesman.');
    } catch (error) {
      Get.snackbar('Order Failed', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    notes.dispose();
    super.onClose();
  }
}
