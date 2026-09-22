import 'product_model_mapper.dart';
import '../../localization/t.dart';

/// One pack size a product is offered in, e.g. "250 ML" vs "1 L" — each with
/// its own case price, MRP and stock.
class ProductVariantOption {
  const ProductVariantOption({
    required this.id,
    required this.name,
    required this.unitsPerCase,
    required this.casePrice,
    required this.caseMrp,
    this.availableStock,
    this.isDefault = false,
  });

  final int id;
  final String name;
  final int unitsPerCase;
  final double casePrice;
  final double caseMrp;

  /// Retail units in stock for this variant; null when unknown.
  final double? availableStock;
  final bool isDefault;
}

/// One label/value row in a product's "Additional Info" table.
class ProductInfoRow {
  const ProductInfoRow({required this.label, required this.value});

  final String label;
  final String value;
}

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
    this.variants = const [],
    this.additionalInfo = const [],
    this.careInstructions = '',
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

  /// Every pack size this product is offered in; empty when the product has
  /// no variants of its own.
  final List<ProductVariantOption> variants;

  /// The "Additional Info" label/value table; empty when not filled in.
  final List<ProductInfoRow> additionalInfo;

  final String careInstructions;

  /// Raw API payload, kept so the cart can be saved and restored.
  final Map<String, dynamic> source;

  /// e.g. "1 case = 50 x 100 ML".
  String get caseLabel {
    final size = variantName.trim().isNotEmpty ? ' x $variantName' : '';

    return t('catalog.case_equals', {'n': '$unitsPerCase', 'size': size});
  }

  /// This product with a different pack size selected — re-derived from the
  /// raw API payload so price, case size and stock all come from that
  /// variant, not the one the product loaded with.
  ProductModel withVariant(int variantId) {
    if (source.isEmpty) return this;

    final reselected = Map<String, dynamic>.from(source);
    reselected['main_variant_id'] = variantId;

    return ProductModelMapper.fromJson(reselected);
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModelMapper.fromJson(json);
}
