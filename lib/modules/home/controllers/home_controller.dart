import 'package:get/get.dart';

import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/homepage_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../utils/home_response_parser.dart';

class HomeController extends GetxController {
  HomeController(this._api);

  final DealerApiService _api;

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

  Future<void> loadHome() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    errorMessage.value = '';

    try {
      // Dealer dashboard failure should not block homepage catalog.
      await _loadDashboard();

      // Main source: same homepage system as customer, but audience=dealer.
      final homepageResponse = await _api.homepage();

      final payload = HomeResponseParser.payload(homepageResponse);

      banners.assignAll(
        HomeResponseParser.parseHomepageItems(payload['banners']),
      );

      categories.assignAll(
        HomeResponseParser.parseCategories(payload['categories']),
      );

      sections.assignAll(HomeResponseParser.parseSections(payload['rows']));

      // Collect products appearing in all admin-configured homepage
      // sections.
      final homepageProducts = sections
          .expand((section) => section.products)
          .toList();

      products.assignAll(HomeResponseParser.uniqueProducts(homepageProducts));

      // If admin has categories but has not configured product rows yet,
      // load catalog products as fallback.
      if (categories.isEmpty || products.isEmpty) {
        await _loadCatalogFallback(keepHomepageRows: true);
      }
    } catch (error) {
      errorMessage.value = error.toString();

      await _loadCatalogFallback(keepHomepageRows: false);
    } finally {
      isLoading.value = false;
    }
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
  }) async {
    try {
      final categoryResponse = await _api.categories();

      final productResponse = await _api.products(audience: 'dealer');

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
