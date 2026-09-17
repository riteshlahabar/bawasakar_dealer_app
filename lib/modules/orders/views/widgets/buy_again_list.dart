import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/empty_state.dart';
import '../../../../app/widgets/product_image.dart';
import '../../../../app/localization/t.dart';

/// "Buy Again" tab: products from past orders with an Add to cart button.
class BuyAgainList extends StatelessWidget {
  const BuyAgainList({super.key, required this.products, required this.onAdd});

  final List<ProductModel> products;
  final ValueChanged<ProductModel> onAdd;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 360,
            child: EmptyState(
              title: t('orders.nothing_to_buy_again'),
              message: t('orders.buy_again_message'),
              icon: Icons.replay_rounded,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final product = products[index];

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(width: 60, height: 60, child: ProductImage(imageUrl: product.imageUrl, fit: BoxFit.cover)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(product.caseLabel, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text('₹${_money.format(product.casePrice)} / case', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => onAdd(product),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 12)),
                child: Text(t('orders.add_to_cart'), style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }
}
