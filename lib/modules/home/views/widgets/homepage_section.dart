import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import 'banner_section_list.dart';
import 'product_section.dart';

/// Dispatches a Laravel-driven homepage section to a product row or a
/// banner row depending on its content.
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
    // Product section: Admin title becomes app heading.
    if (section.hasProducts) {
      return ProductSection(
        title: section.title.isEmpty ? 'Products' : section.title,
        items: section.products,
        subtitle: section.subtitle,
        onSeeAll: onSeeAll,
      );
    }

    // Banner-type section.
    if (section.hasBanners) {
      return BannerSectionList(section: section, onItemTap: onSeeAll);
    }

    return const SizedBox.shrink();
  }
}
