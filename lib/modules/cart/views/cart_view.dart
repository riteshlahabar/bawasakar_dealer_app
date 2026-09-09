import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/product_image.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.cart.items.isEmpty) {
        return const EmptyState(title: 'Cart is Empty', message: 'Add medicines, seeds or farm products to continue shopping.', icon: Icons.shopping_cart_outlined);
      }
      return Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.cart.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final item = controller.cart.items[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ProductImage(imageUrl: item.product.imageUrl, assetPath: item.product.assetPath, width: 72, height: 72, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text('₹${item.product.price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _QtyButton(icon: Icons.remove, onTap: () => controller.decrease(item.product)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(item.quantity.toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
                                ),
                                _QtyButton(icon: Icons.add, onTap: () => controller.increase(item.product)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () => controller.remove(item.product), icon: const Icon(Icons.delete_outline, color: AppColors.danger)),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Subtotal', style: TextStyle(color: AppColors.textSecondary)),
                      const Spacer(),
                      Text('₹${controller.cart.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: controller.checkout, child: const Text('Proceed to Checkout')),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}
