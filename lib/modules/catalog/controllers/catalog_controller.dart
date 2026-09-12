import 'package:get/get.dart';

import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../utils/catalog_response_parser.dart';

class CatalogController extends GetxController {
  CatalogController(this._api);

  final DealerApiService _api;

  final isLoading = false.obs;

  final categories = <CategoryModel>[].obs;

  final products = <ProductModel>[].obs;

  final selectedCategoryId = 0.obs;

  final search = ''.obs;

  final errorMessage = ''.obs;

  List<ProductModel> get filteredProducts {
    final term = search.value.trim().toLowerCase();

    if (term.isEmpty) {
      return products.toList();
    }

    return products.where((item) {
      return item.name.toLowerCase().contains(term) ||
          item.sku.toLowerCase().contains(term) ||
          item.categoryName.toLowerCase().contains(term);
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
      errorMessage.value = error.toString();

      products.clear();

      Get.snackbar('Catalog', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCategories() async {
    final response = await _api.categories(fresh: true);

    categories.assignAll(CatalogResponseParser.parseCategories(response));
  }

  Future<void> selectCategory(int id) async {
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

      errorMessage.value = error.toString();

      Get.snackbar('Products', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSelectedProducts() async {
    final selectedId = selectedCategoryId.value;

    final result = <ProductModel>[];

    var page = 1;

    while (true) {
      final response = await _api.products(
        audience: 'dealer',
        categoryId: selectedId == 0 ? null : selectedId,
        page: page,
        perPage: 100,
        fresh: true,
      );

      final pageProducts = CatalogResponseParser.parseProducts(response);

      result.addAll(pageProducts);

      final lastPage = CatalogResponseParser.extractLastPage(response);

      if (page >= lastPage || pageProducts.isEmpty) {
        break;
      }

      page++;
    }

    products.assignAll(result);
  }
}
