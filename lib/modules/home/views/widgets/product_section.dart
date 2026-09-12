import 'package:flutter/material.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_card.dart';
import '../../../../app/widgets/section_header.dart';

/// Horizontal row of product cards under a titled section header.
class ProductSection extends StatelessWidget {
  const ProductSection({
    super.key,
    required this.title,
    required this.items,
    this.subtitle = '',
    required this.onSeeAll,
  });

  final String title;
  final List<ProductModel> items;
  final String subtitle;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          actionText: 'See All',
          onAction: onSeeAll,
        ),
        if (subtitle.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        SizedBox(
          height: 248,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              return SizedBox(
                width: 156,
                child: ProductCard(product: items[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
