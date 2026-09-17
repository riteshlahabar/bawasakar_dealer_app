import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// "Remove from cart?" confirmation that slides up from the bottom.
class CartRemoveSheet extends StatelessWidget {
  const CartRemoveSheet({super.key, required this.product, required this.onConfirm});

  final ProductModel product;
  final VoidCallback onConfirm;

  static Future<void> show({required ProductModel product, required VoidCallback onConfirm}) {
    return Get.bottomSheet<void>(
      CartRemoveSheet(product: product, onConfirm: onConfirm),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 16),
            Text(t('cart.remove_title'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () => Get.back<void>(), child: Text(t('common.cancel'))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                    onPressed: () {
                      Get.back<void>();
                      onConfirm();
                    },
                    child: Text(t('common.remove')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
