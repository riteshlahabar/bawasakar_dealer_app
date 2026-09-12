import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/homepage_model.dart';
import '../../../app/data/models/product_model.dart';

/// Stateless helpers that turn a raw Laravel homepage/catalog API response
/// into the typed models [HomeController] displays.
class HomeResponseParser {
  const HomeResponseParser._();

  static Map<String, dynamic> payload(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return response;
  }

  static List<CategoryModel> parseCategories(dynamic source) {
    final list = _extractList(source, const ['categories', 'data', 'items']);

    return list
        .whereType<Map>()
        .map(
          (item) => CategoryModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.id > 0)
        .toList();
  }

  static List<ProductModel> parseProducts(dynamic source) {
    final list = _extractList(source, const ['products', 'data', 'items']);

    return list
        .whereType<Map>()
        .map(
          (item) => ProductModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.id > 0)
        .toList();
  }

  static List<HomepageItemModel> parseHomepageItems(dynamic source) {
    final list = _extractList(source, const ['banners', 'items', 'data']);

    return list
        .whereType<Map>()
        .map(
          (item) =>
              HomepageItemModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  static List<HomepageSectionModel> parseSections(dynamic source) {
    final list = _extractList(source, const ['rows', 'sections', 'data']);

    return list
        .whereType<Map>()
        .map(
          (item) =>
              HomepageSectionModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  static List<dynamic> _extractList(dynamic source, List<String> keys) {
    if (source is List) {
      return source;
    }

    if (source is! Map) {
      return const [];
    }

    dynamic current = source;

    for (final key in keys) {
      if (current is Map && current[key] is List) {
        return current[key] as List;
      }

      if (current is Map && current[key] is Map) {
        current = current[key];
      }
    }

    if (source['data'] is Map) {
      return _extractList(source['data'], keys);
    }

    return const [];
  }

  static List<ProductModel> uniqueProducts(List<ProductModel> items) {
    final seen = <int>{};

    final unique = <ProductModel>[];

    for (final item in items) {
      if (seen.add(item.id)) {
        unique.add(item);
      }
    }

    return unique;
  }

  static String money(dynamic value) {
    final amount = double.tryParse(value?.toString() ?? '') ?? 0;

    return '₹${amount.toStringAsFixed(0)}';
  }
}
