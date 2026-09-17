import 'dart:async';

import 'package:get/get.dart';

import '../cache/json_cache_store.dart';
import '../models/product_model.dart';

class CartItem {
  CartItem({required this.product, required this.quantity});

  final ProductModel product;

  /// Number of cases.
  int quantity;

  double get lineTotal => product.casePrice * quantity;

  double get mrpTotal => (product.caseMrp > product.casePrice ? product.caseMrp : product.casePrice) * quantity;
}

/// Dealer cart (quantities in cases) plus "Save for later", saved on the phone
/// so both survive an app restart. Prices here are for display only; the
/// server computes the real order total.
class CartService extends GetxService {
  CartService(this._cache);

  static const _cacheKey = 'dealer_cart';

  final JsonCacheStore _cache;

  final items = <CartItem>[].obs;
  final savedForLater = <ProductModel>[].obs;

  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold<double>(0, (sum, item) => sum + item.lineTotal);
  double get mrpTotal => items.fold<double>(0, (sum, item) => sum + item.mrpTotal);
  double get savings => mrpTotal > subtotal ? mrpTotal - subtotal : 0;

  @override
  void onInit() {
    super.onInit();
    ever<List<CartItem>>(items, (_) => _persist());
    ever<List<ProductModel>>(savedForLater, (_) => _persist());
    _restore();
  }

  void add(ProductModel product) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      items[index].quantity++;
      items.refresh();
    } else {
      items.add(CartItem(product: product, quantity: 1));
    }
  }

  void decrease(ProductModel product) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index < 0) return;
    if (items[index].quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index].quantity--;
      items.refresh();
    }
  }

  void remove(ProductModel product) {
    items.removeWhere((item) => item.product.id == product.id);
  }

  void saveForLater(ProductModel product) {
    remove(product);
    if (!savedForLater.any((saved) => saved.id == product.id)) {
      savedForLater.add(product);
    }
  }

  void moveToCart(ProductModel product) {
    savedForLater.removeWhere((saved) => saved.id == product.id);
    add(product);
  }

  void removeSaved(ProductModel product) {
    savedForLater.removeWhere((saved) => saved.id == product.id);
  }

  /// Empties the cart after an order; "Save for later" is kept.
  void clear() => items.clear();

  List<Map<String, dynamic>> toOrderItems() {
    // With a variant the server treats quantity as cases.
    return items
        .map((item) => {
              'product_id': item.product.id,
              if (item.product.mainVariantId > 0) 'variant_id': item.product.mainVariantId,
              'quantity': item.quantity,
            })
        .toList();
  }

  Future<void> _restore() async {
    final data = await _cache.read(_cacheKey);
    if (data == null) return;

    final rawItems = data['items'];
    if (rawItems is List && items.isEmpty) {
      items.assignAll(rawItems.whereType<Map>().map((entry) {
        final product = entry['product'];
        final quantity = int.tryParse('${entry['quantity']}') ?? 0;
        return product is Map && quantity > 0
            ? CartItem(product: ProductModel.fromJson(Map<String, dynamic>.from(product)), quantity: quantity)
            : null;
      }).whereType<CartItem>());
    }

    final rawSaved = data['saved'];
    if (rawSaved is List && savedForLater.isEmpty) {
      savedForLater.assignAll(
        rawSaved.whereType<Map>().map((product) => ProductModel.fromJson(Map<String, dynamic>.from(product))),
      );
    }
  }

  void _persist() {
    unawaited(_cache.write(_cacheKey, {
      'items': [
        for (final item in items)
          if (item.product.source.isNotEmpty) {'product': item.product.source, 'quantity': item.quantity},
      ],
      'saved': [
        for (final product in savedForLater)
          if (product.source.isNotEmpty) product.source,
      ],
    }));
  }
}
