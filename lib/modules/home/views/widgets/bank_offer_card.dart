import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/homepage_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';
import '../../../../app/localization/t.dart';

/// One bank / wallet offer: logo, bank name, discount, terms and validity,
/// with a copyable coupon code footer when the offer has one.
class BankOfferCard extends StatelessWidget {
  const BankOfferCard({
    super.key,
    required this.item,
    required this.fallbackTitle,
    required this.onTap,
  });

  final HomepageItemModel item;
  final String fallbackTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = item.title.trim().isNotEmpty ? item.title : fallbackTitle;
    final discount = item.discountText.trim().isNotEmpty ? item.discountText : item.subtitle;
    final terms = item.description.trim().isNotEmpty && item.description != discount ? item.description : '';
    final coupon = item.couponCode.trim();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primarySoft, Colors.white],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _logo(),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                      ),
                      if (discount.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _discountChip(discount),
                      ],
                      if (terms.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          terms,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, height: 1.3, color: AppColors.textSecondary),
                        ),
                      ],
                      const Spacer(),
                      if (item.validityText.trim().isNotEmpty) _validity(item.validityText),
                    ],
                  ),
                ),
              ),
              if (coupon.isNotEmpty) _couponFooter(coupon),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    final logo = item.logoOrImageUrl;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: logo == null
          ? const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 22)
          : Padding(
              padding: const EdgeInsets.all(4),
              child: ProductImage(imageUrl: logo, fit: BoxFit.contain),
            ),
    );
  }

  Widget _discountChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.orange),
      ),
    );
  }

  Widget _validity(String text) {
    return Row(
      children: [
        const Icon(Icons.schedule_rounded, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _couponFooter(String code) {
    return Container(
      height: 38,
      padding: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              code,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: .8),
            ),
          ),
          InkWell(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: code));
              Get.snackbar(t('common.copied'), t('catalog.coupon_copied', {'code': code}), snackPosition: SnackPosition.BOTTOM);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy_rounded, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text(t('home.copy'), style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
