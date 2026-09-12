import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';

/// Large promotional banner card used by the hero carousel and its fallback.
class BannerCard extends StatelessWidget {
  const BannerCard({
    super.key,
    required this.banner,
    required this.height,
    this.large = false,
    this.isAsset = false,
    required this.onShopNow,
  });

  final HomepageItemModel banner;
  final double height;
  final bool large;
  final bool isAsset;
  final VoidCallback onShopNow;

  @override
  Widget build(BuildContext context) {
    final imageUrl = banner.bestImageUrl;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(large ? 22 : 18),
        border: Border.all(color: AppColors.border),
        color: AppColors.primarySoft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null)
            ProductImage(
              imageUrl: isAsset ? null : imageUrl,
              assetPath: isAsset ? imageUrl : null,
              fit: BoxFit.cover,
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withValues(alpha: .94),
                  Colors.white.withValues(alpha: .50),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 14,
            bottom: 14,
            width: 215,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (banner.highlightText.isNotEmpty ||
                    banner.discountText.isNotEmpty) ...[
                  Text(
                    banner.highlightText.isNotEmpty
                        ? banner.highlightText
                        : banner.discountText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                Text(
                  banner.title,
                  maxLines: large ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: large ? 22 : 16,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (banner.subtitle.isNotEmpty ||
                    banner.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    banner.subtitle.isNotEmpty
                        ? banner.subtitle
                        : banner.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11.5,
                      height: 1.25,
                    ),
                  ),
                ],
                if (large) ...[
                  const Spacer(),
                  SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: onShopNow,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(108, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: Text(
                        banner.buttonText.isEmpty
                            ? 'Shop Now'
                            : banner.buttonText,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
