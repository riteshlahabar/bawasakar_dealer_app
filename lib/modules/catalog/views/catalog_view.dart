import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/category_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../../../app/widgets/product_card.dart';
import '../../../app/widgets/product_image.dart';
import '../controllers/catalog_controller.dart';

class CatalogView
    extends GetView<CatalogController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.products.isEmpty) {
        return const LoadingView();
      }

      return Column(
        children: [
          _search(),
          Expanded(
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                _categoryMenu(),
                Expanded(
                  child: _productArea(),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        6,
        16,
        12,
      ),
      child: TextField(
        onChanged: (value) =>
            controller.search.value =
                value,
        decoration:
            const InputDecoration(
          hintText:
              'Search dealer product',
          prefixIcon:
              Icon(Icons.search_rounded),
        ),
      ),
    );
  }

  Widget _categoryMenu() {
    return Container(
      width: 76,
      decoration:
          const BoxDecoration(
        color: Color(0xFFF6F8F5),
        border: Border(
          right: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Obx(
        () => ListView.builder(
          padding:
              const EdgeInsets.only(
            top: 6,
            bottom: 18,
          ),
          itemCount:
              controller
                      .categories.length +
                  1,
          itemBuilder: (_, index) {
            final isAll = index == 0;

            final category = isAll
                ? null
                : controller.categories[
                    index - 1];

            final id =
                category?.id ?? 0;

            final active =
                controller
                        .selectedCategoryId
                        .value ==
                    id;

            return _CategoryMenuTile(
              title: isAll
                  ? 'All'
                  : category!.name,
              active: active,
              category: category,
              onTap: () =>
                  controller
                      .selectCategory(
                id,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _productArea() {
    return Obx(() {
      final products =
          controller.filteredProducts;

      if (controller.isLoading.value &&
          products.isNotEmpty) {
        return Stack(
          children: [
            _productGrid(products),
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              child:
                  LinearProgressIndicator(
                minHeight: 2,
              ),
            ),
          ],
        );
      }

      if (products.isEmpty) {
        return RefreshIndicator(
          onRefresh:
              controller.loadCatalog,
          child:
              const SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: 420,
              child: EmptyState(
                title: 'No Products',
                message:
                    'No dealer product found in selected category.',
              ),
            ),
          ),
        );
      }

      return _productGrid(products);
    });
  }

  Widget _productGrid(
    List products,
  ) {
    return RefreshIndicator(
      onRefresh:
          controller.loadCatalog,
      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final columns =
              constraints.maxWidth >= 250
                  ? 2
                  : 1;

          return GridView.builder(
            padding:
                const EdgeInsets.fromLTRB(
              12,
              4,
              12,
              20,
            ),
            itemCount: products.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio:
                  columns == 1
                      ? .78
                      : .58,
            ),
            itemBuilder: (_, index) =>
                ProductCard(
              product: products[index],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryMenuTile
    extends StatelessWidget {
  const _CategoryMenuTile({
    required this.title,
    required this.active,
    required this.onTap,
    this.category,
  });

  final String title;
  final bool active;
  final VoidCallback onTap;
  final CategoryModel? category;

  @override
  Widget build(BuildContext context) {
    final hasImage =
        category?.imageUrl
                ?.trim()
                .isNotEmpty ??
            false;

    return Material(
      color: active
          ? Colors.white
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.fromLTRB(
            6,
            9,
            6,
            9,
          ),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: active
                    ? AppColors.primary
                    : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors
                          .primarySoft
                      : Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                  border: Border.all(
                    color: active
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
                clipBehavior:
                    Clip.antiAlias,
                child: category == null
                    ? const Icon(
                        Icons
                            .grid_view_rounded,
                        color:
                            AppColors.primary,
                        size: 25,
                      )
                    : hasImage
                        ? ProductImage(
                            imageUrl:
                                category!
                                    .imageUrl,
                            assetPath:
                                category!
                                    .assetPath,
                            fit:
                                BoxFit.cover,
                          )
                        : Icon(
                            _iconFor(
                              title,
                            ),
                            color:
                                AppColors
                                    .primary,
                            size: 25,
                          ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 9.5,
                  height: 1.15,
                  color: active
                      ? AppColors.primary
                      : AppColors
                          .textPrimary,
                  fontWeight: active
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String name) {
    final value =
        name.toLowerCase();

    if (value.contains('medicine') ||
        value.contains('veterinary')) {
      return Icons
          .medication_liquid_rounded;
    }

    if (value.contains('seed')) {
      return Icons.grass_rounded;
    }

    if (value.contains('fertil')) {
      return Icons.eco_rounded;
    }

    if (value.contains('tool') ||
        value.contains('equipment')) {
      return Icons
          .agriculture_rounded;
    }

    if (value.contains('feed') ||
        value.contains('supplement')) {
      return Icons
          .inventory_2_rounded;
    }

    return Icons.spa_rounded;
  }
}