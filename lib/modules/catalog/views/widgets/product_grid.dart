import 'package:flutter/material.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/widgets/product_card.dart';

/// Responsive (1 or 2 column) grid of dealer product cards that asks for the
/// next page when scrolled near the bottom.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onRefresh,
    this.onLoadMore,
    this.isLoadingMore = false,
  });

  final List<ProductModel> products;
  final Future<void> Function() onRefresh;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (onLoadMore != null &&
              notification.metrics.axis == Axis.vertical &&
              notification.metrics.extentAfter < 600) {
            onLoadMore!();
          }

          return false;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 250 ? 2 : 1;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  sliver: SliverGrid.builder(
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: columns == 1 ? .78 : .58,
                    ),
                    itemBuilder: (_, index) => ProductCard(product: products[index]),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: isLoadingMore
                        ? const Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.4),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
