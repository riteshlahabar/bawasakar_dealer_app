import 'dart:async';

import '../../../app/data/cache/json_cache_store.dart';
import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../utils/catalog_response_parser.dart';

/// A page of catalog products plus whether more pages exist.
class CatalogPage {
  const CatalogPage(this.products, {required this.hasMore});

  final List<ProductModel> products;
  final bool hasMore;
}

/// Loads dealer catalog categories and product pages, and keeps the saved
/// copies that let the Category tab show instantly on the next app open.
class CatalogRepository {
  CatalogRepository(this._api, this._cache);

  static const pageSize = 20;
  static const _categoriesKey = 'dealer_catalog_categories';

  final DealerApiService _api;
  final JsonCacheStore _cache;

  /// Saved categories, or empty.
  Future<List<CategoryModel>> savedCategories() async {
    final cached = await _cache.read(_categoriesKey);

    return cached == null ? const [] : CatalogResponseParser.parseCategories(cached);
  }

  /// Categories from the server (saved for next time). Throws on failure.
  Future<List<CategoryModel>> loadCategories({bool fresh = false}) async {
    final response = await _api.categories(fresh: fresh);

    unawaited(_cache.write(_categoriesKey, response));

    return CatalogResponseParser.parseCategories(response);
  }

  /// The saved first page for a category, or null when none is saved.
  Future<List<ProductModel>?> savedFirstPage(int categoryId) async {
    final cached = await _cache.read(_productsKey(categoryId));

    return cached == null ? null : CatalogResponseParser.parseProducts(cached);
  }

  /// One page from the server. An unfiltered first page is also saved.
  Future<CatalogPage> fetchPage({
    required int categoryId,
    required String query,
    required int page,
    bool fresh = false,
  }) async {
    final response = await _api.products(
      audience: 'dealer',
      categoryId: categoryId == 0 ? null : categoryId,
      search: query.isEmpty ? null : query,
      page: page,
      perPage: pageSize,
      fresh: fresh,
    );

    if (page == 1 && query.isEmpty) {
      unawaited(_cache.write(_productsKey(categoryId), response));
    }

    return CatalogPage(
      CatalogResponseParser.parseProducts(response),
      hasMore: page < CatalogResponseParser.extractLastPage(response),
    );
  }

  String _productsKey(int categoryId) => 'dealer_catalog_products_$categoryId';
}
