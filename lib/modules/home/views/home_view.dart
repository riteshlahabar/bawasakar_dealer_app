import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/homepage_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/loading_view.dart';
import '../../../app/widgets/product_card.dart';
import '../../../app/widgets/product_image.dart';
import '../../../app/widgets/section_header.dart';
import '../../catalog/controllers/catalog_controller.dart';
import '../../main_shell/controllers/main_shell_controller.dart';
import '../controllers/home_controller.dart';

class HomeView
    extends GetView<HomeController> {
  const HomeView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Obx(() {
      final isEmpty =
          controller.products.isEmpty &&
          controller.categories.isEmpty &&
          controller.sections.isEmpty &&
          controller.banners.isEmpty;

      if (controller.isLoading.value &&
          isEmpty) {
        return const LoadingView(
          message:
              'Loading dealer store...',
        );
      }

      final otherSections =
          controller.sections
              .where(
                (section) =>
                    !section.isHero &&
                    !section.isCategory,
              )
              .toList();

      final content =
          <Widget>[
        _topSearch(),

        _heroBanners(),

        _dealerSummary(),

        _categories(),
      ];

      for (final section
          in otherSections) {
        content.add(
          _homepageSection(
            context,
            section,
          ),
        );
      }

      // Fallback only if Laravel has no
      // homepage sections configured.
      if (otherSections.isEmpty) {
        content.addAll([
          _productSection(
            'Animal Medicine',
            controller.featuredProducts,
          ),

          _productSection(
            'Top Selling Items',
            controller.topSellingProducts,
          ),

          _productSection(
            'New Arrivals',
            controller.newArrivals,
          ),
        ]);
      }

      if (controller.errorMessage
              .value.isNotEmpty &&
          controller.products.isEmpty) {
        content.add(
          _apiError(),
        );
      }

      content.add(
        const SizedBox(
          height: 24,
        ),
      );

      return RefreshIndicator(
        onRefresh:
            controller.loadHome,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: content,
        ),
      );
    });
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _topSearch() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                controller
                    .searchText
                    .value = value;
              },
              decoration:
                  const InputDecoration(
                hintText:
                    'Search dealer products...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          InkWell(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            onTap: () {
              _openCategory(0);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    AppColors.primary,
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
              child: const Icon(
                Icons
                    .grid_view_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HERO BANNERS
  // ============================================================

  Widget _heroBanners() {
    final banners =
        controller.banners;

    if (banners.isEmpty) {
      return _fallbackHeroBanner();
    }

    return SizedBox(
      height: 188,
      child: PageView.builder(
        padEnds: false,
        controller:
            PageController(
          viewportFraction: .92,
        ),
        itemCount:
            banners.length,
        itemBuilder: (
          _,
          index,
        ) {
          return Padding(
            padding: EdgeInsets.only(
              left:
                  index == 0
                      ? 16
                      : 8,
              right: 8,
            ),
            child: _bannerCard(
              banners[index],
              height: 176,
              large: true,
            ),
          );
        },
      ),
    );
  }

  Widget _fallbackHeroBanner() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: _bannerCard(
        const HomepageItemModel(
          id: 0,
          title:
              'Dealer Price Store',
          subtitle:
              'B2B Products at Dealer Prices',
          buttonText:
              'Start Order',
          imageUrl:
              'assets/images/animal_medicine_banner.png',
        ),
        height: 176,
        large: true,
        isAsset: true,
      ),
    );
  }

  // ============================================================
  // DEALER SUMMARY
  // ============================================================

  Widget _dealerSummary() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryCard(
              'Credit Limit',
              controller.creditLimit,
              Icons
                  .account_balance_wallet_outlined,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: _summaryCard(
              'Outstanding',
              controller.outstanding,
              Icons
                  .payments_outlined,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: _summaryCard(
              'Pending',
              controller.pendingOrders,
              Icons
                  .pending_actions_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: .04,
            ),
            blurRadius: 12,
            offset:
                const Offset(
              0,
              6,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color:
                AppColors.primary,
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            value,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style:
                const TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w900,
              color:
                  AppColors.textPrimary,
            ),
          ),

          const SizedBox(
            height: 2,
          ),

          Text(
            title,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style:
                const TextStyle(
              fontSize: 10.5,
              color:
                  AppColors.textSecondary,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _categories() {
    if (controller
        .categories.isEmpty) {
      return const SizedBox
          .shrink();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title:
              'Shop By Category',
          actionText:
              'View All',
          onAction: () {
            _openCategory(0);
          },
        ),

        SizedBox(
          height: 104,
          child:
              ListView.separated(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 16,
            ),
            scrollDirection:
                Axis.horizontal,
            itemCount:
                controller
                    .categories
                    .length,
            separatorBuilder:
                (_, __) =>
                    const SizedBox(
              width: 10,
            ),
            itemBuilder:
                (_, index) {
              final category =
                  controller
                          .categories[
                      index];

              return _CategoryTile(
                category:
                    category,
                onTap: () {
                  _openCategory(
                    category.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _openCategory(
    int categoryId,
  ) {
    final catalog =
        Get.find<
            CatalogController>();

    catalog.selectCategory(
      categoryId,
    );

    Get.find<
            MainShellController>()
        .changeTab(1);
  }

  // ============================================================
  // DYNAMIC HOMEPAGE SECTIONS
  // ============================================================

  Widget _homepageSection(
    BuildContext context,
    HomepageSectionModel section,
  ) {
    // Product section:
    // Admin title becomes app heading.
    if (section.hasProducts) {
      return _productSection(
        section.title.isEmpty
            ? 'Products'
            : section.title,
        section.products,
        subtitle:
            section.subtitle,
      );
    }

    // Banner-type section.
    if (section.hasBanners) {
      return _bannerSection(
        section,
      );
    }

    return const SizedBox
        .shrink();
  }

  // ============================================================
  // PRODUCT SECTION
  // ============================================================

  Widget _productSection(
    String title,
    List<ProductModel> items, {
    String subtitle = '',
  }) {
    if (items.isEmpty) {
      return const SizedBox
          .shrink();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          actionText:
              'See All',
          onAction: () {
            _openCategory(0);
          },
        ),

        if (subtitle
            .trim()
            .isNotEmpty)
          Padding(
            padding:
                const EdgeInsets
                    .fromLTRB(
              16,
              0,
              16,
              8,
            ),
            child: Align(
              alignment:
                  Alignment
                      .centerLeft,
              child: Text(
                subtitle,
                style:
                    const TextStyle(
                  fontSize: 11.5,
                  color: AppColors
                      .textSecondary,
                ),
              ),
            ),
          ),

        SizedBox(
          height: 248,
          child:
              ListView.separated(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 16,
            ),
            scrollDirection:
                Axis.horizontal,
            itemCount:
                items.length,
            separatorBuilder:
                (_, __) =>
                    const SizedBox(
              width: 12,
            ),
            itemBuilder:
                (_, index) {
              return SizedBox(
                width: 156,
                child:
                    ProductCard(
                  product:
                      items[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BANNER SECTION
  // ============================================================

  Widget _bannerSection(
    HomepageSectionModel section,
  ) {
    if (section
        .items.isEmpty) {
      return const SizedBox
          .shrink();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        if (section.title
            .trim()
            .isNotEmpty)
          SectionHeader(
            title:
                section.title,
          ),

        SizedBox(
          height: 128,
          child:
              ListView.separated(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 16,
            ),
            scrollDirection:
                Axis.horizontal,
            itemCount:
                section
                    .items.length,
            separatorBuilder:
                (_, __) =>
                    const SizedBox(
              width: 12,
            ),
            itemBuilder:
                (_, index) {
              return SizedBox(
                width: 220,
                child:
                    _smallBannerCard(
                  section
                      .items[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _smallBannerCard(
    HomepageItemModel item,
  ) {
    final image =
        item.bestImageUrl;

    return InkWell(
      onTap: () {
        _openCategory(0);
      },
      borderRadius:
          BorderRadius.circular(
        16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color:
              AppColors.primarySoft,
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          border: Border.all(
            color:
                AppColors.border,
          ),
        ),
        clipBehavior:
            Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (image != null)
              ProductImage(
                imageUrl: image,
                fit:
                    BoxFit.cover,
              ),

            DecoratedBox(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin: Alignment
                      .bottomCenter,
                  end: Alignment
                      .topCenter,
                  colors: [
                    Colors.black
                        .withValues(
                      alpha: .50,
                    ),
                    Colors
                        .transparent,
                  ],
                ),
              ),
            ),

            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  if (item.title
                      .isNotEmpty)
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 13,
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),

                  if (item.subtitle
                      .isNotEmpty)
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 10.5,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HERO BANNER CARD
  // ============================================================

  Widget _bannerCard(
    HomepageItemModel banner, {
    required double height,
    bool large = false,
    bool isAsset = false,
  }) {
    final imageUrl =
        banner.bestImageUrl;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(
          large ? 22 : 18,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        color:
            AppColors.primarySoft,
      ),
      clipBehavior:
          Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null)
            ProductImage(
              imageUrl:
                  isAsset
                      ? null
                      : imageUrl,
              assetPath:
                  isAsset
                      ? imageUrl
                      : null,
              fit:
                  BoxFit.cover,
            ),

          DecoratedBox(
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                begin: Alignment
                    .centerLeft,
                end: Alignment
                    .centerRight,
                colors: [
                  Colors.white
                      .withValues(
                    alpha: .94,
                  ),
                  Colors.white
                      .withValues(
                    alpha: .50,
                  ),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Positioned(
            left: 16,
            top: 14,
            bottom: 14,
            width: 215,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,
              children: [
                if (banner
                        .highlightText
                        .isNotEmpty ||
                    banner
                        .discountText
                        .isNotEmpty) ...[
                  Text(
                    banner
                            .highlightText
                            .isNotEmpty
                        ? banner
                            .highlightText
                        : banner
                            .discountText,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color: AppColors
                          .primary,
                      fontSize: 10.5,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                ],

                Text(
                  banner.title,
                  maxLines:
                      large ? 2 : 1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style: TextStyle(
                    fontSize:
                        large
                            ? 22
                            : 16,
                    height: 1.08,
                    fontWeight:
                        FontWeight
                            .w900,
                    color: AppColors
                        .textPrimary,
                  ),
                ),

                if (banner
                        .subtitle
                        .isNotEmpty ||
                    banner
                        .description
                        .isNotEmpty) ...[
                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    banner
                            .subtitle
                            .isNotEmpty
                        ? banner
                            .subtitle
                        : banner
                            .description,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color: AppColors
                          .textSecondary,
                      fontSize: 11.5,
                      height: 1.25,
                    ),
                  ),
                ],

                if (large) ...[
                  const Spacer(),

                  SizedBox(
                    height: 34,
                    child:
                        ElevatedButton(
                      onPressed: () {
                        _openCategory(
                          0,
                        );
                      },
                      style:
                          ElevatedButton
                              .styleFrom(
                        minimumSize:
                            const Size(
                          108,
                          34,
                        ),
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              14,
                        ),
                      ),
                      child: Text(
                        banner
                                .buttonText
                                .isEmpty
                            ? 'Shop Now'
                            : banner
                                .buttonText,
                        style:
                            const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // API ERROR
  // ============================================================

  Widget _apiError() {
    return Padding(
      padding:
          const EdgeInsets.all(
        16,
      ),
      child: Container(
        padding:
            const EdgeInsets.all(
          22,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border: Border.all(
            color:
                AppColors.border,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons
                  .cloud_off_rounded,
              size: 38,
              color:
                  AppColors.primary,
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              'Unable to load dealer products',
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            OutlinedButton.icon(
              onPressed:
                  controller.loadHome,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CATEGORY TILE
// ============================================================

class _CategoryTile
    extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    this.onTap,
  });

  final CategoryModel category;

  final VoidCallback? onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final imageUrl =
        category.imageUrl
                ?.trim() ??
            '';

    final assetPath =
        category.assetPath
                ?.trim() ??
            '';

    final hasImage =
        imageUrl.isNotEmpty ||
        assetPath.isNotEmpty;

    return InkWell(
      borderRadius:
          BorderRadius.circular(
        18,
      ),
      onTap: onTap,
      child: SizedBox(
        width: 82,
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration:
                  BoxDecoration(
                color: AppColors
                    .primarySoft,
                borderRadius:
                    BorderRadius
                        .circular(
                  18,
                ),
                border:
                    Border.all(
                  color: AppColors
                      .border,
                ),
              ),
              clipBehavior:
                  Clip.antiAlias,
              child: hasImage
                  ? ProductImage(
                      imageUrl:
                          imageUrl,
                      assetPath:
                          assetPath,
                      fit:
                          BoxFit.cover,
                    )
                  : Icon(
                      _iconFor(
                        category
                            .name,
                      ),
                      color:
                          AppColors
                              .primary,
                      size: 28,
                    ),
            ),

            const SizedBox(
              height: 7,
            ),

            Text(
              category.name,
              maxLines: 2,
              overflow:
                  TextOverflow
                      .ellipsis,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 10.5,
                height: 1.15,
                fontWeight:
                    FontWeight
                        .w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(
    String name,
  ) {
    final value =
        name.toLowerCase();

    if (value.contains(
          'medicine',
        ) ||
        value.contains(
          'veterinary',
        ) ||
        value.contains(
          'animal',
        )) {
      return Icons
          .medication_liquid_rounded;
    }

    if (value.contains(
      'seed',
    )) {
      return Icons.grass_rounded;
    }

    if (value.contains(
      'fertil',
    )) {
      return Icons.eco_rounded;
    }

    if (value.contains(
          'tool',
        ) ||
        value.contains(
          'equipment',
        )) {
      return Icons
          .agriculture_rounded;
    }

    if (value.contains(
          'feed',
        ) ||
        value.contains(
          'supplement',
        )) {
      return Icons
          .inventory_2_rounded;
    }

    return Icons.spa_rounded;
  }
}