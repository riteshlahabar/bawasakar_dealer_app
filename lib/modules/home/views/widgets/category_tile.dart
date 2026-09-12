import 'package:flutter/material.dart';

import '../../../../app/data/models/category_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';

/// A single tappable category tile in the horizontal category strip.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    this.onTap,
  });

  final CategoryModel category;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.imageUrl?.trim() ?? '';

    final assetPath = category.assetPath?.trim() ?? '';

    final hasImage = imageUrl.isNotEmpty || assetPath.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 82,
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: hasImage
                  ? ProductImage(
                      imageUrl: imageUrl,
                      assetPath: assetPath,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      _iconFor(category.name),
                      color: AppColors.primary,
                      size: 28,
                    ),
            ),
            const SizedBox(height: 7),
            Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String name) {
    final value = name.toLowerCase();

    if (value.contains('medicine') ||
        value.contains('veterinary') ||
        value.contains('animal')) {
      return Icons.medication_liquid_rounded;
    }

    if (value.contains('seed')) {
      return Icons.grass_rounded;
    }

    if (value.contains('fertil')) {
      return Icons.eco_rounded;
    }

    if (value.contains('tool') || value.contains('equipment')) {
      return Icons.agriculture_rounded;
    }

    if (value.contains('feed') || value.contains('supplement')) {
      return Icons.inventory_2_rounded;
    }

    return Icons.spa_rounded;
  }
}
