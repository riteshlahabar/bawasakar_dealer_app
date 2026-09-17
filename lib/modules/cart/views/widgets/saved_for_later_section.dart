import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';
import '../../../../app/localization/t.dart';

/// Products moved out of the cart with "Save for later".
class SavedForLaterSection extends StatelessWidget {
  const SavedForLaterSection({
    super.key,
    required this.products,
    required this.onMoveToCart,
    required this.onDelete,
  });

  final List<ProductModel> products;
  final ValueChanged<ProductModel> onMoveToCart;
  final ValueChanged<ProductModel> onDelete;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 2, 10),
            child: Text('${t('cart.saved_for_later_count')} (${products.length})', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          ),
          for (final product in products)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
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
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: ProductImage(imageUrl: product.imageUrl, assetPath: product.assetPath, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        Text('₹${_money.format(product.casePrice)} / case', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        Row(
                          children: [
                            _link(t('cart.move_to_cart'), () => onMoveToCart(product)),
                            _link(t('common.delete'), () => onDelete(product), color: AppColors.danger),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _link(String label, VoidCallback onTap, {Color? color}) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: const EdgeInsets.only(right: 12), minimumSize: const Size(0, 30), foregroundColor: color),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
