import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../../cart/views/widgets/cart_price_details.dart';
import '../controllers/checkout_controller.dart';
import 'widgets/checkout_address_card.dart';
import '../../../app/localization/t.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('cart.checkout_title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CheckoutAddressCard(service: controller.addresses),
          const SizedBox(height: 14),
          Text(t('checkout.order_summary'), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
          const SizedBox(height: 8),
          Text(t('checkout.salesman_note'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.35)),
          const SizedBox(height: 12),
          CartPriceDetails(cart: controller.cart),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('checkout.payment_preference'), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 10),
                Material(
                  type: MaterialType.transparency,
                  child: Obx(
                    () => RadioGroup<String>(
                      groupValue: controller.paymentMethod.value,
                      onChanged: (value) => controller.paymentMethod.value = value ?? 'credit',
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            value: 'credit',
                            activeColor: AppColors.primary,
                            title: Text(t('checkout.pay_later'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          ),
                          RadioListTile<String>(
                            value: 'cod',
                            activeColor: AppColors.primary,
                            title: Text(t('checkout.cash_upi'), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextField(controller: controller.notes, maxLines: 3, decoration: InputDecoration(labelText: t('checkout.order_notes'))),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.placeOrder,
                child: Text(controller.isLoading.value ? t('checkout.submitting_order') : t('checkout.submit_dealer_order', {'amount': '₹${controller.cart.subtotal.toStringAsFixed(0)}'})),
              )),
        ],
      ),
    );
  }
}
