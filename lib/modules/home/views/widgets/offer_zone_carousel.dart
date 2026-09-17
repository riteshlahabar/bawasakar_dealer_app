import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/data/models/homepage_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/product_image.dart';
import '../../../../app/widgets/section_header.dart';

/// "Offer Zone" (`offer_section`): one full-width banner at a time, swipeable
/// when there is more than one, with page dots.
class OfferZoneCarousel extends StatefulWidget {
  const OfferZoneCarousel({
    super.key,
    required this.section,
    required this.onItemTap,
  });

  final HomepageSectionModel section;
  final VoidCallback onItemTap;

  @override
  State<OfferZoneCarousel> createState() => _OfferZoneCarouselState();
}

class _OfferZoneCarouselState extends State<OfferZoneCarousel> {
  /// Offer banners are landscape 4:3 (e.g. 1448 x 1086), shown in full.
  static const _aspectRatio = 4 / 3;

  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  // Landscape desktop image first; the portrait mobile image is too tall for
  // a full-width carousel.
  List<String> get _banners => widget.section.items
      .map((item) => item.imageUrl ?? item.mobileImageUrl)
      .whereType<String>()
      .toList();

  @override
  void initState() {
    super.initState();

    // Auto-slide every 4 seconds when there is more than one banner.
    _timer = Timer.periodic(const Duration(seconds: 4), (_) => _next());
  }

  void _next() {
    final count = _banners.length;

    if (count < 2 || !_controller.hasClients) return;

    _controller.animateToPage(
      (_page + 1) % count,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = _banners;

    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.section.title.trim().isNotEmpty)
          SectionHeader(title: widget.section.title),
        LayoutBuilder(
          builder: (context, constraints) {
            final height = (constraints.maxWidth - 32) / _aspectRatio;

            return SizedBox(
              height: height,
              child: PageView.builder(
                controller: _controller,
                itemCount: banners.length,
                onPageChanged: (page) => setState(() => _page = page),
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(18),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: widget.onItemTap,
                      child: ProductImage(imageUrl: banners[index], fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (banners.length > 1) _dots(banners.length),
      ],
    );
  }

  Widget _dots(int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _page ? 18 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: i == _page ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}
