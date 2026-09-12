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

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return FallbackHeroBanner(onShopNow: onShopNow);
    }

    return SizedBox(
      height: 188,
      child: PageView.builder(
        padEnds: false,
        controller: PageController(viewportFraction: .92),
        itemCount: banners.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: 8,
            ),
            child: BannerCard(
              banner: banners[index],
              height: 176,
              large: true,
              onShopNow: onShopNow,
            ),
          );
        },
      ),
    );
  }
}
