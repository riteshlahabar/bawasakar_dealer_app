import 'package:flutter/material.dart';

import '../../../../app/data/models/category_model.dart';
import '../../../../app/widgets/section_header.dart';
import 'category_tile.dart';

/// "Shop By Category" horizontal strip.
class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
    required this.categories,
    required this.onViewAll,
    required this.onCategoryTap,
  });

  final List<CategoryModel> categories;
  final VoidCallback onViewAll;
  final ValueChanged<int> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Shop By Category',
          actionText: 'View All',
          onAction: onViewAll,
        ),
        SizedBox(
          height: 104,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final category = categories[index];

              return CategoryTile(
                category: category,
                onTap: () => onCategoryTap(category.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
