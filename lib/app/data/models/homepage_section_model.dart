import 'homepage_item_model.dart';
import 'product_model.dart';

class HomepageSectionModel {
  const HomepageSectionModel({
    required this.key,
    required this.title,
    required this.type,
    this.subtitle = '',
    this.layoutType = '',
    this.items = const [],
    this.products = const [],
  });

  final String key;

  final String title;
  final String subtitle;

  final String type;
  final String layoutType;

  final List<HomepageItemModel> items;

  final List<ProductModel> products;

  factory HomepageSectionModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    final rawProducts = json['products'];

    return HomepageSectionModel(
      key: json['section_key']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      type: json['section_type']?.toString() ?? '',
      layoutType: json['layout_type']?.toString() ?? '',
      items: rawItems is List
          ? rawItems
              .whereType<Map>()
              .map(
                (item) =>
                    HomepageItemModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
          : const [],
      products: rawProducts is List
          ? rawProducts
              .whereType<Map>()
              .map(
                (item) => ProductModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
          : const [],
    );
  }

  bool get isHero => type == 'hero_slider';

  bool get isCategory => type == 'category_section';

  bool get hasProducts => products.isNotEmpty;

  bool get hasBanners =>
      items.any((item) => item.bestImageUrl != null);
}
