import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import 'banner_card.dart';

/// Shown instead of the hero carousel when Laravel has no banners configured.
class FallbackHeroBanner extends StatelessWidget {
  const FallbackHeroBanner({super.key, required this.onShopNow});

  final VoidCallback onShopNow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BannerCard(
        banner: const HomepageItemModel(
          id: 0,
          title: 'Dealer Price Store',
          subtitle: 'B2B Products at Dealer Prices',
          buttonText: 'Start Order',
          imageUrl: 'assets/images/animal_medicine_banner.png',
        ),
        height: 176,
        large: true,
        isAsset: true,
        onShopNow: onShopNow,
      ),
    );
  }
}
