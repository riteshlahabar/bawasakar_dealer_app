import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import 'bank_offer_grid.dart';
import 'banner_section_list.dart';
import 'offer_zone_carousel.dart';
import 'strip_offer_banner.dart';
import 'product_section.dart';
import '../../../../app/localization/t.dart';

/// Dispatches a Laravel-driven homepage section to a product row, the bank
/// offer grid, or a banner row depending on its content.
class HomepageSection extends StatelessWidget {
  const HomepageSection({
    super.key,
    required this.section,
    required this.onSeeAll,
  });

  final HomepageSectionModel section;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    // Bank & Wallet Offers: two columns, same as the website. Checked before
    // products so offer products are never shown as plain product cards.
    if (section.isCoupon) {
      return section.items.isEmpty
          ? const SizedBox.shrink()
          : BankOfferGrid(section: section, onItemTap: onSeeAll);
    }

    // Offer strip: full-width image, no section heading (same as website).
    if (section.type == 'strip_offer_banner') {
      return section.items.isEmpty
          ? const SizedBox.shrink()
          : StripOfferBanner(item: section.items.first, onTap: onSeeAll);
    }

    // Offer Zone: one full-width banner at a time, swipeable.
    if (section.type == 'offer_section') {
      return OfferZoneCarousel(section: section, onItemTap: onSeeAll);
    }

    // Banner-type sections render their entries as banners.
    if (section.isBannerType) {
      return section.hasBanners
          ? BannerSectionList(section: section, onItemTap: onSeeAll)
          : const SizedBox.shrink();
    }

    // Product section: Admin title becomes app heading.
    if (section.hasProducts) {
      return ProductSection(
        title: section.title.isEmpty ? t('common.products') : section.title,
        items: section.products,
        subtitle: section.subtitle,
        onSeeAll: onSeeAll,
      );
    }

    // Any other section that only has banners.
    if (section.hasBanners) {
      return BannerSectionList(section: section, onItemTap: onSeeAll);
    }

    return const SizedBox.shrink();
  }
}
