import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/address_selection_service.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/localization/t.dart';

class CheckoutController extends GetxController {
  CheckoutController(this._api, this.cart, this.addresses);

  final DealerApiService _api;
  final CartService cart;
  final AddressSelectionService addresses;

  final notes = TextEditingController();
  final paymentMethod = 'Pay Later / Credit'.obs;
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    if (addresses.addresses.isEmpty) addresses.load();
  }

  Future<void> placeOrder() async {
    if (cart.items.isEmpty) {
      Get.snackbar(t('cart.empty_checkout_title'), t('cart.empty_checkout_dealer'));
      return;
    }
    isLoading.value = true;
    try {
      final address = addresses.selected.value;
      final noteText = [
        'Dealer order from mobile app',
        'Payment: ${paymentMethod.value}',
        if (address != null) 'Deliver to: ${[address.name, address.mobile, address.fullAddress].where((part) => part.isNotEmpty).join(', ')}',
        notes.text.trim(),
      ].where((line) => line.isNotEmpty).join('\n');

      await _api.createOrder(cart.toOrderItems(), notes: noteText);
      cart.clear();
      Get.offAllNamed(AppRoutes.main);
      Get.snackbar(t('checkout.order_submitted'), t('checkout.sent_to_salesman'));
    } catch (error) {
      Get.snackbar(t('checkout.order_failed'), error.toString());
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
