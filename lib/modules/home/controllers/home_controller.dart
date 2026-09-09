import 'package:get/get.dart';

import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/homepage_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/dealer_api_service.dart';

class HomeController
    extends GetxController {
  HomeController(this._api);

  final DealerApiService _api;

  final isLoading = false.obs;

  final categories =
      <CategoryModel>[].obs;

  final products =
      <ProductModel>[].obs;

  final banners =
      <HomepageItemModel>[].obs;

  final sections =
      <HomepageSectionModel>[].obs;

  final dashboard =
      <String, dynamic>{}.obs;

  final searchText = ''.obs;

  final errorMessage = ''.obs;

  List<ProductModel>
      get featuredProducts {
    final data = products
        .where(
          (item) =>
              item.isFeatured,
        )
        .toList();

    return data.isEmpty
        ? products.take(8).toList()
        : data;
  }

  List<ProductModel>
      get topSellingProducts {
    final data = products
        .where(
          (item) =>
              item.isTopSelling,
        )
        .toList();

    return data.isEmpty
        ? products
            .skip(1)
            .take(8)
            .toList()
        : data;
  }

  List<ProductModel>
      get newArrivals {
    final data = products
        .where(
          (item) =>
              item.isNewArrival,
        )
        .toList();

    return data.isEmpty
        ? products.take(8).toList()
        : data;
  }

  String get creditLimit =>
      _money(
        dashboard['credit_limit'],
      );

  String get outstanding =>
      _money(
        dashboard[
            'outstanding_balance'],
      );

  String get pendingOrders =>
      dashboard['pending_orders']
              ?.toString() ??
          '0';

  String get totalOrders =>
      dashboard['orders_count']
              ?.toString() ??
          '0';

  @override
  void onReady() {
    super.onReady();

    loadHome();
  }

  Future<void> loadHome() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    errorMessage.value = '';

    try {
      // Dealer dashboard failure should not
      // block homepage catalog.
      await _loadDashboard();

      // Main source:
      // Same homepage system as customer,
      // but audience=dealer.
      final homepageResponse =
          await _api.homepage();

      final payload =
          _payload(
        homepageResponse,
      );

      banners.assignAll(
        _parseHomepageItems(
          payload['banners'],
        ),
      );

      categories.assignAll(
        _parseCategories(
          payload['categories'],
        ),
      );

      sections.assignAll(
        _parseSections(
          payload['rows'],
        ),
      );

      // Collect products appearing in all
      // admin-configured homepage sections.
      final homepageProducts =
          sections
              .expand(
                (section) =>
                    section.products,
              )
              .toList();

      products.assignAll(
        _uniqueProducts(
          homepageProducts,
        ),
      );

      // If admin has categories but has not
      // configured product rows yet, load
      // catalog products as fallback.
      if (categories.isEmpty ||
          products.isEmpty) {
        await _loadCatalogFallback(
          keepHomepageRows: true,
        );
      }
    } catch (error) {
      errorMessage.value =
          error.toString();

      await _loadCatalogFallback(
        keepHomepageRows: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadDashboard() async {
    try {
      final response =
          await _api.dashboard();

      final rawData =
          response['data'];

      if (rawData is Map) {
        dashboard.value =
            Map<String, dynamic>.from(
          rawData,
        );
      }
    } catch (_) {
      // Keep dashboard cards as zero
      // instead of breaking catalog.
      dashboard.clear();
    }
  }

  Future<void> _loadCatalogFallback({
    required bool keepHomepageRows,
  }) async {
    try {
      final categoryResponse =
          await _api.categories();

      final productResponse =
          await _api.products(
        audience: 'dealer',
      );

      if (categories.isEmpty) {
        final categoryPayload =
            _payload(
          categoryResponse,
        );

        categories.assignAll(
          _parseCategories(
            categoryPayload[
                    'categories'] ??
                categoryResponse,
          ),
        );
      }

      if (products.isEmpty) {
        final productPayload =
            _payload(
          productResponse,
        );

        products.assignAll(
          _parseProducts(
            productPayload[
                    'products'] ??
                productResponse,
          ),
        );
      }

      if (!keepHomepageRows) {
        sections.clear();
        banners.clear();
      }
    } catch (error) {
      errorMessage.value =
          error.toString();

      if (!keepHomepageRows) {
        sections.clear();
        banners.clear();
      }

      // IMPORTANT:
      // No MockCatalog here.
      // Dealer app must not display fake
      // products when API is unavailable.
    }
  }

  Map<String, dynamic> _payload(
    Map<String, dynamic> response,
  ) {
    final data =
        response['data'];

    if (data is Map) {
      return Map<String, dynamic>.from(
        data,
      );
    }

    return response;
  }

  List<CategoryModel> _parseCategories(
    dynamic source,
  ) {
    final list =
        _extractList(
      source,
      const [
        'categories',
        'data',
        'items',
      ],
    );

    return list
        .whereType<Map>()
        .map(
          (item) =>
              CategoryModel.fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
        )
        .where(
          (item) =>
              item.id > 0,
        )
        .toList();
  }

  List<ProductModel> _parseProducts(
    dynamic source,
  ) {
    final list =
        _extractList(
      source,
      const [
        'products',
        'data',
        'items',
      ],
    );

    return list
        .whereType<Map>()
        .map(
          (item) =>
              ProductModel.fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
        )
        .where(
          (item) =>
              item.id > 0,
        )
        .toList();
  }

  List<HomepageItemModel>
      _parseHomepageItems(
    dynamic source,
  ) {
    final list =
        _extractList(
      source,
      const [
        'banners',
        'items',
        'data',
      ],
    );

    return list
        .whereType<Map>()
        .map(
          (item) =>
              HomepageItemModel
                  .fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
        )
        .toList();
  }

  List<HomepageSectionModel>
      _parseSections(
    dynamic source,
  ) {
    final list =
        _extractList(
      source,
      const [
        'rows',
        'sections',
        'data',
      ],
    );

    return list
        .whereType<Map>()
        .map(
          (item) =>
              HomepageSectionModel
                  .fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
        )
        .toList();
  }

  List<dynamic> _extractList(
    dynamic source,
    List<String> keys,
  ) {
    if (source is List) {
      return source;
    }

    if (source is! Map) {
      return const [];
    }

    dynamic current =
        source;

    for (final key in keys) {
      if (current is Map &&
          current[key] is List) {
        return current[key]
            as List;
      }

      if (current is Map &&
          current[key] is Map) {
        current =
            current[key];
      }
    }

    if (source['data'] is Map) {
      return _extractList(
        source['data'],
        keys,
      );
    }

    return const [];
  }

  List<ProductModel> _uniqueProducts(
    List<ProductModel> items,
  ) {
    final seen =
        <int>{};

    final unique =
        <ProductModel>[];

    for (final item in items) {
      if (seen.add(item.id)) {
        unique.add(item);
      }
    }

    return unique;
  }

  String _money(
    dynamic value,
  ) {
    final amount =
        double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;

    return '₹${amount.toStringAsFixed(0)}';
  }
}