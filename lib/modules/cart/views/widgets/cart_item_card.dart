import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/data/services/cart_service.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';
import 'cart_remove_sheet.dart';
import 'qty_stepper.dart';
import '../../../../app/localization/t.dart';

/// One cart line: image, case details, stock, case price with savings,
/// quantity stepper and Save for later / Remove.
class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onSaveForLater,
  });

  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final VoidCallback onSaveForLater;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final stock = _stock(product);
    final hasMrp = product.caseMrp > product.casePrice;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 84,
                  height: 84,
                  child: ProductImage(imageUrl: product.imageUrl, assetPath: product.assetPath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(product.caseLabel, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    if (stock != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(stock.label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: stock.color)),
                      ),
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 6,
                      children: [
                        Text('₹${_money.format(product.casePrice)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                        const Text('/ case', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        if (hasMrp)
                          Text(
                            '₹${_money.format(product.caseMrp)}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, decoration: TextDecoration.lineThrough),
                          ),
                      ],
                    ),
                    if (hasMrp)
                      Text(
                        'You save ₹${_money.format((product.caseMrp - product.casePrice) * item.quantity)}',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.success),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              QtyStepper(
                quantity: item.quantity,
                onIncrease: onIncrease,
                onDecrease: item.quantity <= 1 ? _confirmRemove : onDecrease,
              ),
              const Spacer(),
              _link(t('common.save_for_later'), onSaveForLater),
              Container(width: 1, height: 16, color: AppColors.border),
              _link(t('common.remove'), _confirmRemove),
            ],
          ),
          const Divider(height: 18, color: AppColors.border),
          Row(
            children: [
              Text(t('cart.item_total'), style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              Text('₹${_money.format(item.lineTotal)}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmRemove() => CartRemoveSheet.show(product: item.product, onConfirm: onRemove);

  Widget _link(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(0, 32)),
      child: Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
    );
  }

  /// Stock in whole cases; null when the server did not send stock.
  static ({String label, Color color})? _stock(ProductModel product) {
    final units = product.availableStock;
    if (units == null) return null;

    final cases = (units / product.unitsPerCase).floor();
    if (cases <= 0) return (label: t('common.out_of_stock'), color: AppColors.danger);
    if (cases <= 5) {
      return (
        label: t(cases == 1 ? 'cart.only_one_case_left' : 'cart.only_cases_left', {'n': '$cases'}),
        color: AppColors.orange,
      );
    }
    return (label: t('common.in_stock'), color: AppColors.success);
  }
}
