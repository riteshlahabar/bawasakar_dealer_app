import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';

/// Full-width offer strip (`strip_offer_banner`), shown like the website:
/// image only, no section heading.
class StripOfferBanner extends StatelessWidget {
  const StripOfferBanner({
    super.key,
    required this.item,
    required this.onTap,
  });

  final HomepageItemModel item;
  final VoidCallback onTap;

  /// Strip images are wide (e.g. 1916 x 821); the website caps them at 125px.
  static const _aspectRatio = 1916 / 821;
  static const _maxHeight = 125.0;

  @override
  Widget build(BuildContext context) {
    final image = item.imageUrl ?? item.mobileImageUrl;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = image == null
              ? 72.0
              : (constraints.maxWidth / _aspectRatio).clamp(60.0, _maxHeight);

          return Material(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: image != null
                    ? ProductImage(imageUrl: image, fit: BoxFit.cover)
                    : _textStrip(),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Used only when admin set no strip image.
  Widget _textStrip() {
    final offer = item.discountText.isNotEmpty ? item.discountText : item.subtitle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.title.isNotEmpty)
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                if (offer.isNotEmpty)
                  Text(
                    offer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}
