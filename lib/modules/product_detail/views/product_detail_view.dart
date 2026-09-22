import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/product_image.dart';
import '../controllers/product_detail_controller.dart';
import '../../../app/localization/t.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    final cart = Get.find<CartService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(t('catalog.product_details')),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.cart),
            icon: Obx(() => Badge(
                  isLabelVisible: cart.totalItems > 0,
                  label: Text(cart.totalItems.toString()),
                  backgroundColor: AppColors.orange,
                  child: const Icon(Icons.shopping_cart_outlined),
                )),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 320,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
            clipBehavior: Clip.antiAlias,
            child: ProductImage(imageUrl: product.imageUrl, assetPath: product.assetPath, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, height: 1.2)),
                const SizedBox(height: 8),
                Text(product.shortDescription.isNotEmpty ? product.shortDescription : t('catalog.default_short_description'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
                const SizedBox(height: 16),
                if (product.variants.length > 1) ...[
                  Text(t('catalog.pack_size'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Obx(() {
                    final selectedId = controller.selected.value.mainVariantId;

                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.variants.map((variant) {
                        final isSelected = variant.id == selectedId;

                        return ChoiceChip(
                          label: Text(variant.name.isNotEmpty ? variant.name : '#${variant.id}'),
                          selected: isSelected,
                          onSelected: (_) => controller.selectVariant(variant.id),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.primarySoft,
                          side: BorderSide.none,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 16),
                ],
                Obx(() {
                  final selected = controller.selected.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(selected.caseLabel, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      if (selected.caseMrp > selected.casePrice)
                        Text('₹${selected.caseMrp.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
                      Text.rich(
                        TextSpan(
                          text: '₹${selected.casePrice.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary),
                          children: [
                            TextSpan(
                              text: ' ${t('catalog.per_case')}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (_stock(selected) case final stock?) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: stock.color.withValues(alpha: .1), borderRadius: BorderRadius.circular(20)),
                          child: Text(stock.label, style: TextStyle(color: stock.color, fontSize: 11, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ],
                  );
                }),
                const SizedBox(height: 20),
                Text(t('catalog.more_details'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                _DetailRow(label: t('catalog.sku'), value: product.sku),
                _DetailRow(label: t('catalog.category'), value: product.categoryName.isNotEmpty ? product.categoryName : product.type),
                if (product.unit.isNotEmpty) _DetailRow(label: t('catalog.unit'), value: product.unit),
                _DetailRow(label: t('catalog.gst_rate'), value: '${_trimZero(product.gstPercent)}%'),
                Obx(() => _DetailRow(label: t('catalog.case_size'), value: '${controller.selected.value.unitsPerCase}')),
                const SizedBox(height: 18),
                Text(t('common.description'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text(product.description.isNotEmpty ? product.description : t('catalog.default_description'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6)),
                if (product.additionalInfo.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(t('catalog.additional_info'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  for (final row in product.additionalInfo) _DetailRow(label: row.label, value: row.value),
                ],
                if (product.careInstructions.trim().isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(t('catalog.care_instructions'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 7),
                  Text(product.careInstructions, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6)),
                ],
                const SizedBox(height: 90),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(
            children: [
              Obx(() => Container(
                    height: 48,
                    decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        IconButton(onPressed: controller.decrease, icon: const Icon(Icons.remove)),
                        Text(controller.quantity.value.toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
                        IconButton(onPressed: controller.increase, icon: const Icon(Icons.add)),
                      ],
                    ),
                  )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: controller.addToCart, child: Text(t('catalog.add_to_cart')))),
            ],
          ),
        ),
      ),
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

  static String _trimZero(double value) {
    return value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toString();
  }
}

/// One label/value line in the "More Details" block.
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
