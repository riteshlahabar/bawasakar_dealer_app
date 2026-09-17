import 'product_model_mapper.dart';
import '../../localization/t.dart';

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
    this.unitsPerCase = 1,
    this.casePrice = 0,
    this.caseMrp = 0,
    this.variantName = '',
    this.mainVariantId = 0,
    this.availableStock,
    this.source = const {},
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

  // Main variant, sold to dealers by the case.
  final int unitsPerCase;

  /// Dealer price for one full case (units per case x unit price).
  final double casePrice;

  final double caseMrp;
  final String variantName;

  final int mainVariantId;

  /// Retail units in stock for the main variant; null when unknown.
  final double? availableStock;

  /// Raw API payload, kept so the cart can be saved and restored.
  final Map<String, dynamic> source;

  /// e.g. "1 case = 50 x 100 ML".
  String get caseLabel {
    final size = variantName.trim().isNotEmpty ? ' x $variantName' : '';

    return t('catalog.case_equals', {'n': '$unitsPerCase', 'size': size});
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModelMapper.fromJson(json);
}
