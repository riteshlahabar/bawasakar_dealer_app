import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import 'banner_card.dart';
import 'fallback_hero_banner.dart';

/// Swipeable hero banner carousel, or the fallback banner when empty.
class HeroBanners extends StatelessWidget {
  const HeroBanners({
    super.key,
    required this.banners,
    required this.onShopNow,
  });

  final List<HomepageItemModel> banners;
  final VoidCallback onShopNow;

  /// Width / height of the admin hero banner images (e.g. 2176 x 723).
  static const _bannerAspectRatio = 3.0;

  static const _sidePadding = 12.0;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return FallbackHeroBanner(onShopNow: onShopNow);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Full screen width, and a height that follows the image's own shape
        // so the whole banner is visible instead of being cropped.
        final cardHeight = (constraints.maxWidth - _sidePadding * 2) / _bannerAspectRatio;

        return SizedBox(
          height: cardHeight,
          child: PageView.builder(
            itemCount: banners.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
                child: BannerCard(
                  banner: banners[index],
                  height: cardHeight,
                  large: true,
                  onShopNow: onShopNow,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
