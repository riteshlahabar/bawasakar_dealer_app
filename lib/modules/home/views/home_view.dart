import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/loading_view.dart';
import '../../catalog/controllers/catalog_controller.dart';
import '../../main_shell/controllers/main_shell_controller.dart';
import '../controllers/home_controller.dart';
import 'widgets/api_error_view.dart';
import 'widgets/categories_section.dart';
import 'widgets/dealer_summary.dart';
import 'widgets/hero_banners.dart';
import 'widgets/homepage_section.dart';
import 'widgets/product_section.dart';
import 'widgets/top_search_bar.dart';
import '../../../app/localization/t.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEmpty =
          controller.products.isEmpty &&
          controller.categories.isEmpty &&
          controller.sections.isEmpty &&
          controller.banners.isEmpty;

      if (controller.isLoading.value && isEmpty) {
        return LoadingView(message: t('common.loading'));
      }

      final otherSections = controller.sections
          .where((section) => !section.isHero && !section.isCategory)
          .toList();

      final content = <Widget>[
        TopSearchBar(
          onSearchChanged: (value) => controller.searchText.value = value,
          onGridTap: () => _openCategory(0),
        ),

        HeroBanners(
          banners: controller.banners,
          onShopNow: () => _openCategory(0),
        ),

        DealerSummary(
          creditLimit: controller.creditLimit,
          outstanding: controller.outstanding,
          pendingOrders: controller.pendingOrders,
        ),

        CategoriesSection(
          categories: controller.categories,
          onViewAll: () => _openCategory(0),
          onCategoryTap: _openCategory,
        ),
      ];

      for (final section in otherSections) {
        content.add(
          HomepageSection(
            section: section,
            onSeeAll: () => _openCategory(0),
          ),
        );
      }

      // Fallback only if Laravel has no homepage sections configured.
      if (otherSections.isEmpty) {
        content.addAll([
          ProductSection(
            title: t('catalog.animal_medicine'),
            items: controller.featuredProducts,
            onSeeAll: () => _openCategory(0),
          ),

          ProductSection(
            title: t('catalog.top_selling'),
            items: controller.topSellingProducts,
            onSeeAll: () => _openCategory(0),
          ),

          ProductSection(
            title: t('catalog.new_arrivals'),
            items: controller.newArrivals,
            onSeeAll: () => _openCategory(0),
          ),
        ]);
      }

      if (controller.errorMessage.value.isNotEmpty &&
          controller.products.isEmpty) {
        content.add(ApiErrorView(onRetry: () => controller.loadHome(fresh: true)));
      }

      content.add(const SizedBox(height: 24));

      return RefreshIndicator(
        onRefresh: () => controller.loadHome(fresh: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: content,
        ),
      );
    });
  }

  void _openCategory(int categoryId) {
    final catalog = Get.find<CatalogController>();

    catalog.selectCategory(categoryId);

    Get.find<MainShellController>().changeTab(1);
  }
}
