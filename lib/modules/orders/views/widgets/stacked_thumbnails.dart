import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';

/// Up to three product images overlapping each other.
class StackedThumbnails extends StatelessWidget {
  const StackedThumbnails({super.key, required this.urls});

  final List<String> urls;

  static const _size = 52.0;
  static const _offset = 24.0;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary),
      );
    }

    return SizedBox(
      width: _size + (urls.length - 1) * _offset,
      height: _size,
      child: Stack(
        children: [
          for (var i = 0; i < urls.length; i++)
            Positioned(
              left: i * _offset,
              child: Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 4)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ProductImage(imageUrl: urls[i], fit: BoxFit.cover),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
