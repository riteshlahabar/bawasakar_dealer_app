import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import '../../../../app/widgets/section_header.dart';
import 'bank_offer_card.dart';
import '../../../../app/localization/t.dart';

/// "Bank & Wallet Offers" section: a fixed two-column grid of offer cards,
/// matching the two-column layout on the website.
class BankOfferGrid extends StatelessWidget {
  const BankOfferGrid({
    super.key,
    required this.section,
    required this.onItemTap,
  });

  final HomepageSectionModel section;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    final items = section.items;
    final hasCoupon = items.any((item) => item.couponCode.trim().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: section.title.trim().isEmpty ? t('catalog.bank_offers') : section.title,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            // Same height for every card; taller when a coupon footer exists.
            mainAxisExtent: hasCoupon ? 206 : 168,
          ),
          itemBuilder: (_, index) => BankOfferCard(
            item: items[index],
            fallbackTitle: section.title,
            onTap: onItemTap,
          ),
        ),
      ],
    );
  }
}
