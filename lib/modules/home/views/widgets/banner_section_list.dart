import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import '../../../../app/widgets/section_header.dart';
import 'small_banner_card.dart';

/// Horizontal row of small banner tiles for a banner-type homepage section.
class BannerSectionList extends StatelessWidget {
  const BannerSectionList({
    super.key,
    required this.section,
    required this.onItemTap,
  });

  final HomepageSectionModel section;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    if (section.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title.trim().isNotEmpty)
          SectionHeader(title: section.title),
        SizedBox(
          height: 128,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: section.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              return SizedBox(
                width: 220,
                child: SmallBannerCard(
                  item: section.items[index],
                  onTap: onItemTap,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
