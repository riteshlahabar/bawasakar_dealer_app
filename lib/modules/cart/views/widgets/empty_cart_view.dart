import 'package:flutter/material.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_card.dart';
import '../../../../app/localization/t.dart';

/// Empty cart: large illustration, Shop Now, and products from past orders.
class EmptyCartView extends StatelessWidget {
  const EmptyCartView({
    super.key,
    required this.products,
    required this.onShopNow,
    required this.onAdd,
    required this.onRefresh,
  });

  final List<ProductModel> products;
  final VoidCallback onShopNow;
  final ValueChanged<ProductModel> onAdd;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
        children: [
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
              child: const Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 22),
          Text(t('cart.empty_title'), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            t('cart.empty_hint'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton(onPressed: onShopNow, child: Text(t('catalog.shop_now'))),
            ),
          ),
          if (products.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text(t('common.buy_again'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            SizedBox(
              height: 248,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) => SizedBox(width: 156, child: ProductCard(product: products[index])),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
