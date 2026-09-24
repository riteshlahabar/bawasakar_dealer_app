import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';

/// Green brand header with the company logo, shown above every auth card.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBack = false,
    this.showBranding = true,
  });

  final String title;
  final String subtitle;
  final bool showBack;

  /// Login shows the artwork on its own; the other auth screens keep the
  /// logo, title and subtitle over it.
  final bool showBranding;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final logoSize = showBack ? 76.0 : 96.0;

    // Login shows the artwork by itself — no scrim over it, since it already
    // carries the company logo on its own green ground. The panel is taller
    // than the image's own proportions, so the sides (outer leaf shapes, not
    // the logo) are cropped to fill it.
    if (!showBranding) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        child: Image.asset(
          'assets/images/login_image.png',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, topInset + (showBack ? 4 : 28), 24, 64),
      decoration: BoxDecoration(
        // Brand artwork instead of the old flat green. The dark-green scrim
        // keeps the white logo, title and subtitle readable over it whatever
        // the photo's own brightness is, and the colour also shows through
        // while the image is still decoding.
        color: AppColors.primaryDark,
        image: DecorationImage(
          image: const AssetImage('assets/images/login_image.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primaryDark.withValues(alpha: .55),
            BlendMode.srcOver,
          ),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          if (showBack)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          Container(
            width: logoSize,
            height: logoSize,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Image.asset('assets/images/app_logo.png'),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: .80), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
