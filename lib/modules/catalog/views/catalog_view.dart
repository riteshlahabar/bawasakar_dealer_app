import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/catalog_controller.dart';
import 'widgets/catalog_search_field.dart';
import 'widgets/category_menu.dart';
import 'widgets/product_grid.dart';

class CatalogView extends GetView<CatalogController> {
  const CatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.products.isEmpty) {
        return const LoadingView();
      }

      return Column(
        children: [
          CatalogSearchField(
            onSearchChanged: (value) => controller.search.value = value,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(
                  () => CategoryMenu(
                    categories: controller.categories,
                    selectedCategoryId: controller.selectedCategoryId.value,
                    onCategorySelected: controller.selectCategory,
                  ),
                ),
                Expanded(
                  child: Obx(() => _productArea()),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _productArea() {
    final products = controller.filteredProducts;

    if (controller.isLoading.value && products.isNotEmpty) {
      return Stack(
        children: [
          ProductGrid(products: products, onRefresh: controller.loadCatalog),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
        ],
      );
    }

    if (products.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.loadCatalog,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 420,
            child: EmptyState(
              title: 'No Products',
              message: 'No dealer product found in selected category.',
            ),
          ),
        ),
      );
    }

    return ProductGrid(products: products, onRefresh: controller.loadCatalog);
  }
}
