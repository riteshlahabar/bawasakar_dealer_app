import '../data/models/product_model.dart';

/// Rebuilds catalog products from past order items, for "Buy again".
class OrderProducts {
  const OrderProducts._();

  /// Unique products from an orders list API response.
  static List<ProductModel> fromOrdersResponse(Map<String, dynamic> response) {
    dynamic data = response['data'] ?? response;

    if (data is Map && data['orders'] != null) data = data['orders'];
    if (data is Map && data['data'] is List) data = data['data'];
    if (data is! List) return const [];

    return fromItems(
      data.whereType<Map>().expand((order) => order['items'] is List ? (order['items'] as List).whereType<Map>() : const <Map>[]),
    );
  }

  /// Unique products from raw order item maps (with `product`, `variant` and
  /// `product_image_url`).
  static List<ProductModel> fromItems(Iterable<Map> items) {
    final seen = <int>{};
    final products = <ProductModel>[];

    for (final item in items) {
      final product = item['product'];
      if (product is! Map) continue;

      final json = Map<String, dynamic>.from(product);
      final variant = item['variant'];

      if (variant is Map) {
        json['variants'] = [Map<String, dynamic>.from(variant)];
        json['main_variant_id'] = variant['id'];
      }

      final image = item['product_image_url'];
      if (image != null) json['image_url'] = image;

      final model = ProductModel.fromJson(json);
      if (model.id > 0 && seen.add(model.id)) products.add(model);
    }

    return products;
  }
}
