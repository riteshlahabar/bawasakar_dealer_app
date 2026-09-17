import 'package:get/get.dart';

import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/product_model.dart';
import '../services/catalog_repository.dart';
import '../../../app/localization/t.dart';

class CatalogController extends GetxController {
  CatalogController(this._catalog);

  final CatalogRepository _catalog;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = false.obs;

  final categories = <CategoryModel>[].obs;
  final products = <ProductModel>[].obs;

  final selectedCategoryId = 0.obs;
  final search = ''.obs;
  final errorMessage = ''.obs;

  int _page = 1;

  // Bumped on every first-page load, so a slow response for a previous
  // category or search can never overwrite the current one.
  int _requestId = 0;

  // The search term the current product list was loaded for.
  String _activeQuery = '';

  List<ProductModel> get filteredProducts {
    final term = search.value.trim().toLowerCase();

    // Already filtered by the server, or nothing typed.
    if (term.isEmpty || term == _activeQuery.toLowerCase()) {
      return products.toList();
    }

    // Instant local filter while the debounced server search is pending.
    return products.where((item) {
      return item.name.toLowerCase().contains(term) ||
          item.sku.toLowerCase().contains(term) ||
          item.categoryName.toLowerCase().contains(term);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();

    debounce<String>(search, (value) {
      if (value.trim() != _activeQuery) _loadFirstPage();
    }, time: const Duration(milliseconds: 400));
  }

  @override
  void onReady() {
    super.onReady();

    _loadCategories();

    // Home may already have started a load through selectCategory().
    if (_requestId == 0) _loadFirstPage();
  }

  void prepareCategory(int id) {
    selectedCategoryId.value = id;
    search.value = '';
  }

  /// Pull-to-refresh: reloads categories and the first page from the server,
  /// skipping the saved copy and the server cache.
  Future<void> loadCatalog({bool fresh = true}) async {
    await Future.wait([
      _loadCategories(fresh: fresh),
      _loadFirstPage(fresh: fresh),
    ]);
  }

  Future<void> selectCategory(int id) {
    selectedCategoryId.value = id;
    search.value = '';

    return _loadFirstPage();
  }

  /// Next page, triggered when the grid is scrolled near the bottom.
  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore.value) return;

    final requestId = _requestId;
    final nextPage = _page + 1;

    isLoadingMore.value = true;

    try {
      final result = await _catalog.fetchPage(
        categoryId: selectedCategoryId.value,
        query: _activeQuery,
        page: nextPage,
      );

      if (requestId != _requestId) return;

      products.addAll(result.products);
      _page = nextPage;
      hasMore.value = result.hasMore;
    } catch (_) {
      // Keep what is loaded; scrolling again retries.
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _loadCategories({bool fresh = false}) async {
    if (!fresh && categories.isEmpty) {
      final saved = await _catalog.savedCategories();

      if (saved.isNotEmpty && categories.isEmpty) categories.assignAll(saved);
    }

    try {
      categories.assignAll(await _catalog.loadCategories(fresh: fresh));
    } catch (_) {
      // Saved categories (if any) stay visible.
    }
  }

  Future<void> _loadFirstPage({bool fresh = false}) async {
    final requestId = ++_requestId;
    final query = search.value.trim();
    final categoryId = selectedCategoryId.value;

    _activeQuery = query;
    _page = 1;
    hasMore.value = false;
    errorMessage.value = '';
    isLoading.value = true;

    // On refresh the list on screen already belongs to this category.
    var showingCurrent = fresh;

    if (!fresh && query.isEmpty) {
      final saved = await _catalog.savedFirstPage(categoryId);

      if (requestId != _requestId) return;

      if (saved != null) {
        products.assignAll(saved);
        showingCurrent = true;
      }
    }

    try {
      final result = await _catalog.fetchPage(categoryId: categoryId, query: query, page: 1, fresh: fresh);

      if (requestId != _requestId) return;

      products.assignAll(result.products);
      hasMore.value = result.hasMore;
    } catch (error) {
      if (requestId != _requestId) return;

      errorMessage.value = error.toString();

      if (!showingCurrent) {
        products.clear();
        Get.snackbar(t('common.products'), error.toString());
      }
    } finally {
      if (requestId == _requestId) isLoading.value = false;
    }
  }
}
