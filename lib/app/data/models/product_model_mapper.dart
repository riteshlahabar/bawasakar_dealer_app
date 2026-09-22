import 'product_model.dart';

/// Builds a [ProductModel] from a Laravel product JSON payload.
class ProductModelMapper {
  const ProductModelMapper._();

  static ProductModel fromJson(Map<String, dynamic> json) {
    final unitPrice = _firstPrice(json, const [
      'dealer_price',
      'price',
      'sale_price',
      'selling_price',
      'customer_price',
    ]);
    final unitMrp = _firstPrice(json, const [
      'mrp',
      'old_price',
      'compare_price',
      'customer_price',
    ]);

    final variant = _mainVariant(json);
    final unitsPerCase = variant == null ? 1 : _asDouble(variant['units_per_case']).round().clamp(1, 100000).toInt();
    final variantUnitPrice = variant == null ? 0.0 : _asDouble(variant['dealer_price']);
    final variantMrp = variant == null ? 0.0 : _asDouble(variant['mrp']);
    final serverCasePrice = variant == null ? 0.0 : _asDouble(variant['dealer_case_price']);

    return ProductModel(
      unitsPerCase: unitsPerCase,

      casePrice: serverCasePrice > 0
          ? serverCasePrice
          : (variantUnitPrice > 0 ? variantUnitPrice : unitPrice) * unitsPerCase,

      caseMrp: (variantMrp > 0 ? variantMrp : unitMrp) * unitsPerCase,

      variantName: (variant?['name'] ?? variant?['display_name'] ?? variant?['value'])?.toString() ?? '',

      mainVariantId: variant == null ? 0 : _asInt(variant['id']),

      availableStock: variant == null || variant['available_stock'] == null ? null : _asDouble(variant['available_stock']),

      source: json,

      id: _asInt(json['id']),

      name:
          json['name']?.toString() ?? json['product_name']?.toString() ?? '',

      sku: json['sku']?.toString() ?? '',

      // IMPORTANT:
      // Dealer price must always have first priority.
      price: unitPrice,

      mrp: unitMrp,

      gstPercent: _asDouble(json['gst_percent']),

      type:
          json['product_type']?.toString() ??
          json['type']?.toString() ??
          'product',

      description:
          json['description']?.toString() ??
          json['storefront_description']?.toString() ??
          '',

      shortDescription: json['short_description']?.toString() ?? '',

      categoryId: _asInt(json['category_id']),

      categoryName: _categoryName(json),

      unit: _unitName(json),

      imageUrl: _image(json),

      homepageImageUrl: _cleanImage(json['homepage_image_url']),

      homepageMobileImageUrl: _cleanImage(json['homepage_mobile_image_url']),

      imageVersion: _imageVersion(json),

      isFeatured: _asBool(json['is_featured']),

      isTrending: _asBool(json['is_trending']),

      isTopSelling: _asBool(json['is_top_selling']),

      isNewArrival: _asBool(json['is_new_arrival']),

      variants: _variantOptions(json),

      additionalInfo: _additionalInfo(json),

      careInstructions: json['care_instructions']?.toString() ?? '',
    );
  }

  static List<ProductInfoRow> _additionalInfo(Map<String, dynamic> json) {
    final rows = json['additional_info'];

    if (rows is! List) {
      return const [];
    }

    return rows
        .whereType<Map>()
        .map((row) => ProductInfoRow(
              label: row['label']?.toString().trim() ?? '',
              value: row['value']?.toString().trim() ?? '',
            ))
        .where((row) => row.label.isNotEmpty || row.value.isNotEmpty)
        .toList();
  }

  /// Every pack size on the payload, so the product detail page can offer a
  /// selector — not just the one [_mainVariant] picked for display.
  static List<ProductVariantOption> _variantOptions(Map<String, dynamic> json) {
    final variants = json['variants'];

    if (variants is! List) {
      return const [];
    }

    return variants
        .whereType<Map>()
        .map((item) => _variantOption(Map<String, dynamic>.from(item)))
        .where((variant) => variant.id > 0)
        .toList();
  }

  static ProductVariantOption _variantOption(Map<String, dynamic> variant) {
    final unitsPerCase = _asDouble(variant['units_per_case']).round().clamp(1, 100000).toInt();
    final dealerPrice = _asDouble(variant['dealer_price']);
    final mrp = _asDouble(variant['mrp']);
    final serverCasePrice = _asDouble(variant['dealer_case_price']);

    return ProductVariantOption(
      id: _asInt(variant['id']),
      name: (variant['name'] ?? variant['display_name'] ?? variant['value'])?.toString() ?? '',
      unitsPerCase: unitsPerCase,
      casePrice: serverCasePrice > 0 ? serverCasePrice : dealerPrice * unitsPerCase,
      caseMrp: mrp * unitsPerCase,
      availableStock: variant['available_stock'] == null ? null : _asDouble(variant['available_stock']),
      isDefault: _asBool(variant['is_default']),
    );
  }

  /// The product's main variant: `main_variant_id`, else the default
  /// variant, else the first one. Null when the payload has no variants.
  static Map<String, dynamic>? _mainVariant(Map<String, dynamic> json) {
    final variants = json['variants'];

    if (variants is! List) {
      return null;
    }

    final list = variants.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();

    if (list.isEmpty) {
      return null;
    }

    final mainId = _asInt(json['main_variant_id']);

    for (final variant in list) {
      if (mainId > 0 && _asInt(variant['id']) == mainId) {
        return variant;
      }
    }

    for (final variant in list) {
      if (_asBool(variant['is_default'])) {
        return variant;
      }
    }

    return list.first;
  }

  static String? _image(Map<String, dynamic> json) {
    final images = json['images'];

    final firstImage =
        images is List && images.isNotEmpty && images.first is Map
        ? images.first as Map
        : null;

    final candidates = [
      json['image_url'],
      json['main_image_url'],
      json['thumbnail_url'],
      json['image'],
      json['storefront_image'],
      firstImage?['url'],
      firstImage?['image_url'],
      firstImage?['path'],
      json['homepage_image_path'],
    ];

    for (final item in candidates) {
      final value = _cleanImage(item);

      if (value != null) {
        return value;
      }
    }

    return null;
  }

  static String? _cleanImage(dynamic item) {
    final value = item?.toString().trim() ?? '';

    if (value.isNotEmpty && value != 'null') {
      return value;
    }

    return null;
  }

  static String _imageVersion(Map<String, dynamic> json) {
    final value = json['image_version']?.toString().trim() ?? '';

    if (value.isNotEmpty && value != 'null') {
      return value;
    }

    final updatedAt = json['updated_at']?.toString().trim() ?? '';

    if (updatedAt.isNotEmpty && updatedAt != 'null') {
      return updatedAt;
    }

    return json['id']?.toString() ?? '';
  }

  static String _categoryName(Map<String, dynamic> json) {
    final category = json['category'];

    if (category is Map) {
      return category['storefront_name']?.toString() ??
          category['name']?.toString() ??
          '';
    }

    return json['category_name']?.toString() ?? category?.toString() ?? '';
  }

  static String _unitName(Map<String, dynamic> json) {
    final unit = json['unit'];

    if (unit is Map) {
      return unit['name']?.toString() ?? unit['short_name']?.toString() ?? '';
    }

    return json['unit_name']?.toString() ?? unit?.toString() ?? '';
  }

  static double _firstPrice(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = _asDouble(json[key]);

      if (value > 0) {
        return value;
      }
    }

    return 0;
  }

  static int _asInt(dynamic value) {
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _asBool(dynamic value) {
    final text = value?.toString().toLowerCase() ?? '';

    return text == '1' || text == 'true' || text == 'yes';
  }
}
