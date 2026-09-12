import 'product_model_mapper.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.mrp,
    required this.gstPercent,
    required this.type,
    this.description = '',
    this.shortDescription = '',
    this.categoryId = 0,
    this.categoryName = '',
    this.unit = '',
    this.imageUrl,
    this.homepageImageUrl,
    this.homepageMobileImageUrl,
    this.imageVersion = '',
    this.assetPath,
    this.isFeatured = false,
    this.isTrending = false,
    this.isTopSelling = false,
    this.isNewArrival = false,
  });

  final int id;

  final String name;
  final String sku;

  // Dealer price
  final double price;

  final double mrp;
  final double gstPercent;

  final String type;

  final String description;
  final String shortDescription;

  final int categoryId;
  final String categoryName;

  final String unit;

  final String? imageUrl;

  final String? homepageImageUrl;

  final String? homepageMobileImageUrl;

  final String imageVersion;

  final String? assetPath;

  final bool isFeatured;
  final bool isTrending;
  final bool isTopSelling;
  final bool isNewArrival;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModelMapper.fromJson(json);
}
