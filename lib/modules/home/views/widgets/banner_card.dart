import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';
import '../../../../app/localization/t.dart';

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

  static const _textWidth = 215.0;

  @override
  Widget build(BuildContext context) {
    final imageUrl = banner.bestImageUrl;

    // Short full-width banners scale their text down to fit inside.
    final compact = height < 150;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
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
          // The white fade is only for the built-in fallback banner; admin
          // banner images are shown without the whitish overlay.
          if (imageUrl == null || isAsset)
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
            left: compact ? 12 : 16,
            top: compact ? 8 : 14,
            bottom: compact ? 10 : 14,
            width: _textWidth,
            child: compact ? _compactLayout() : _details(withButton: large),
          ),
        ],
      ),
    );
  }

  /// Text scales down at the top; the Shop Now button stays at the bottom.
  Widget _compactLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: SizedBox(width: _textWidth, child: _details(withButton: false)),
            ),
          ),
        ),
        if (large) ...[
          const SizedBox(height: 6),
          _shopNowButton(height: 28),
        ],
      ],
    );
  }

  Widget _details({required bool withButton}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: withButton ? MainAxisSize.max : MainAxisSize.min,
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
        if (banner.title.isNotEmpty)
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
        if (withButton) ...[
          const Spacer(),
          _shopNowButton(height: 34),
        ],
      ],
    );
  }

  Widget _shopNowButton({required double height}) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onShopNow,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(height == 34 ? 108 : 92, height),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        child: Text(
          banner.buttonText.isEmpty ? t('catalog.shop_now') : banner.buttonText,
          style: TextStyle(fontSize: height == 34 ? 12 : 11),
        ),
      ),
    );
  }
}
