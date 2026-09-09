import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dealer Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('B2B Order Summary', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 8),
                const Text('This order will be sent to your assigned salesman, then forwarded to admin for processing.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5, height: 1.35)),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${controller.cart.totalItems} items', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                    Text('₹${controller.cart.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Payment Preference', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 10),
                Obx(
                  () => RadioGroup<String>(
                    groupValue: controller.paymentMethod.value,
                    onChanged: (value) => controller.paymentMethod.value = value ?? 'Pay Later / Credit',
                    child: const Column(
                      children: [
                        RadioListTile<String>(
                          value: 'Pay Later / Credit',
                          activeColor: AppColors.primary,
                          title: Text('Pay Later / Dealer Credit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                        RadioListTile<String>(
                          value: 'Cash / UPI Collection',
                          activeColor: AppColors.primary,
                          title: Text('Cash / UPI Collection', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextField(controller: controller.notes, maxLines: 3, decoration: const InputDecoration(labelText: 'Order Notes / Delivery Instructions')),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.placeOrder,
                child: Text(controller.isLoading.value ? 'Submitting Order...' : 'Submit Dealer Order ₹${controller.cart.subtotal.toStringAsFixed(0)}'),
              )),
        ],
      ),
    );
  }
}
