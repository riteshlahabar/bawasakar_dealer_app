import 'dart:async';

import 'package:get/get.dart';

import '../../../app/data/cache/json_cache_store.dart';
import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/homepage_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/localization/localized_cache_key.dart';
import '../utils/home_response_parser.dart';

class HomeController extends GetxController {
  HomeController(this._api, this._cache);

  static const _homepageCacheKey = 'dealer_homepage';

  final DealerApiService _api;
  final JsonCacheStore _cache;

  final isLoading = false.obs;
  final categories = <CategoryModel>[].obs;
  final products = <ProductModel>[].obs;
  final banners = <HomepageItemModel>[].obs;
  final sections = <HomepageSectionModel>[].obs;
  final dashboard = <String, dynamic>{}.obs;
  final searchText = ''.obs;
  final errorMessage = ''.obs;

  List<ProductModel> get featuredProducts {
    final data = products.where((item) => item.isFeatured).toList();

    return data.isEmpty ? products.take(8).toList() : data;
  }

  List<ProductModel> get topSellingProducts {
    final data = products.where((item) => item.isTopSelling).toList();

    return data.isEmpty ? products.skip(1).take(8).toList() : data;
  }

  List<ProductModel> get newArrivals {
    final data = products.where((item) => item.isNewArrival).toList();

    return data.isEmpty ? products.take(8).toList() : data;
  }

  String get creditLimit =>
      HomeResponseParser.money(dashboard['credit_limit']);

  String get outstanding =>
      HomeResponseParser.money(dashboard['outstanding_balance']);

  String get pendingOrders =>
      dashboard['pending_orders']?.toString() ?? '0';

  String get totalOrders => dashboard['orders_count']?.toString() ?? '0';

  @override
  void onReady() {
    super.onReady();

    loadHome();
  }

  /// Shows the last saved homepage instantly, then refreshes it from the
  /// server. [fresh] (pull-to-refresh) skips the saved copy and server cache.
  Future<void> loadHome({bool fresh = false}) async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    errorMessage.value = '';

    try {
      if (!fresh && sections.isEmpty && products.isEmpty) {
        final cached = await _cache.read(localizedCacheKey(_homepageCacheKey));

        if (cached != null) {
          _applyHomepage(cached);
        }
      }

      // Dealer dashboard failure should not block homepage catalog.
      await _loadDashboard();

      // Main source: same homepage system as customer, but audience=dealer.
      final homepageResponse = await _api.homepage();

      _applyHomepage(homepageResponse);

      unawaited(_cache.write(localizedCacheKey(_homepageCacheKey), homepageResponse));

      // If admin has categories but has not configured product rows yet,
      // load catalog products as fallback.
      if (categories.isEmpty || products.isEmpty) {
        await _loadCatalogFallback(keepHomepageRows: true, fresh: fresh);
      }
    } catch (error) {
      errorMessage.value = error.toString();

      // A saved homepage stays on screen when the network fails.
      if (sections.isEmpty && products.isEmpty) {
        await _loadCatalogFallback(keepHomepageRows: false, fresh: fresh);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _applyHomepage(Map<String, dynamic> response) {
    final payload = HomeResponseParser.payload(response);

    banners.assignAll(
      HomeResponseParser.parseHomepageItems(payload['banners']),
    );

    categories.assignAll(
      HomeResponseParser.parseCategories(payload['categories']),
    );

    sections.assignAll(HomeResponseParser.parseSections(payload['rows']));

    // Collect products appearing in all admin-configured homepage sections.
    final homepageProducts = sections
        .expand((section) => section.products)
        .toList();

    products.assignAll(HomeResponseParser.uniqueProducts(homepageProducts));
  }

  Future<void> _loadDashboard() async {
    try {
      final response = await _api.dashboard();

      final rawData = response['data'];

      if (rawData is Map) {
        dashboard.value = Map<String, dynamic>.from(rawData);
      }
    } catch (_) {
      // Keep dashboard cards as zero instead of breaking catalog.
      dashboard.clear();
    }
  }

  Future<void> _loadCatalogFallback({
    required bool keepHomepageRows,
    required bool fresh,
  }) async {
    try {
      final categoryResponse = await _api.categories(fresh: fresh);

      final productResponse = await _api.products(audience: 'dealer', fresh: fresh);

      if (categories.isEmpty) {
        final categoryPayload = HomeResponseParser.payload(categoryResponse);

        categories.assignAll(
          HomeResponseParser.parseCategories(
            categoryPayload['categories'] ?? categoryResponse,
          ),
        );
      }

      if (products.isEmpty) {
        final productPayload = HomeResponseParser.payload(productResponse);

        products.assignAll(
          HomeResponseParser.parseProducts(
            productPayload['products'] ?? productResponse,
          ),
        );
      }

      if (!keepHomepageRows) {
        sections.clear();
        banners.clear();
      }
    } catch (error) {
      errorMessage.value = error.toString();

      if (!keepHomepageRows) {
        sections.clear();
        banners.clear();
      }

      // IMPORTANT:
      // No MockCatalog here.
      // Dealer app must not display fake products when API is unavailable.
    }
  }
}
