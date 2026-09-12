import 'package:flutter/material.dart';

import '../../../../app/data/models/product_model.dart';
import '../../../../app/widgets/product_card.dart';

/// Responsive (1 or 2 column) grid of dealer product cards.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onRefresh,
  });

  final List<ProductModel> products;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 250 ? 2 : 1;

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: columns == 1 ? .78 : .58,
            ),
            itemBuilder: (_, index) => ProductCard(product: products[index]),
          );
        },
      ),
    );
  }
}
