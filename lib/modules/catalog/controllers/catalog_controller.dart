import 'package:get/get.dart';

import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/dealer_api_service.dart';

class CatalogController
    extends GetxController {
  CatalogController(this._api);

  final DealerApiService _api;

  final isLoading = false.obs;

  final categories =
      <CategoryModel>[].obs;

  final products =
      <ProductModel>[].obs;

  final selectedCategoryId = 0.obs;

  final search = ''.obs;

  final errorMessage = ''.obs;

  List<ProductModel>
      get filteredProducts {
    final term =
        search.value.trim().toLowerCase();

    if (term.isEmpty) {
      return products.toList();
    }

    return products.where((item) {
      return item.name
              .toLowerCase()
              .contains(term) ||
          item.sku
              .toLowerCase()
              .contains(term) ||
          item.categoryName
              .toLowerCase()
              .contains(term);
    }).toList();
  }

  @override
  void onReady() {
    super.onReady();
    loadCatalog();
  }

  void prepareCategory(int id) {
    selectedCategoryId.value = id;
    search.value = '';
  }

  Future<void> loadCatalog() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _loadCategories();
      await _loadSelectedProducts();
    } catch (error) {
      errorMessage.value =
          error.toString();

      products.clear();

      Get.snackbar(
        'Catalog',
        error.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCategories() async {
    final response =
        await _api.categories(
      fresh: true,
    );

    categories.assignAll(
      _parseCategories(response),
    );
  }

  Future<void> selectCategory(
    int id,
  ) async {
    if (isLoading.value) {
      return;
    }

    selectedCategoryId.value = id;
    search.value = '';

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _loadSelectedProducts();
    } catch (error) {
      products.clear();

      errorMessage.value =
          error.toString();

      Get.snackbar(
        'Products',
        error.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void>
      _loadSelectedProducts() async {
    final selectedId =
        selectedCategoryId.value;

    final result =
        <ProductModel>[];

    var page = 1;

    while (true) {
      final response =
          await _api.products(
        audience: 'dealer',
        categoryId:
            selectedId == 0
                ? null
                : selectedId,
        page: page,
        perPage: 100,
        fresh: true,
      );

      final pageProducts =
          _parseProducts(response);

      result.addAll(pageProducts);

      final lastPage =
          _extractLastPage(response);

      if (page >= lastPage ||
          pageProducts.isEmpty) {
        break;
      }

      page++;
    }

    products.assignAll(result);
  }

  int _extractLastPage(
    Map<String, dynamic> response,
  ) {
    dynamic data = response['data'];

    if (data is Map &&
        data['products'] is Map) {
      data = data['products'];
    }

    if (data is Map) {
      return int.tryParse(
            data['last_page']
                    ?.toString() ??
                '',
          ) ??
          1;
    }

    return 1;
  }

  List<CategoryModel> _parseCategories(
    Map<String, dynamic> response,
  ) {
    final list = _extractList(
      response,
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
          (item) => item.id > 0,
        )
        .toList();
  }

  List<ProductModel> _parseProducts(
    Map<String, dynamic> response,
  ) {
    final list = _extractList(
      response,
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
          (item) => item.id > 0,
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

    for (final key in keys) {
      final value = source[key];

      if (value is List) {
        return value;
      }

      if (value is Map) {
        final nested =
            _extractList(
          value,
          keys,
        );

        if (nested.isNotEmpty) {
          return nested;
        }
      }
    }

    return const [];
  }
}