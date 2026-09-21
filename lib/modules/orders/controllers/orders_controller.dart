import 'package:get/get.dart';

import '../../../app/data/models/order_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/data/services/order_document_api_service.dart';
import '../../../app/utils/order_products.dart';
import '../../main_shell/controllers/main_shell_controller.dart';
import '../utils/order_filter.dart';
import '../../../app/localization/t.dart';

class OrdersController extends GetxController {
  OrdersController(this._api, this._documents, this._cart, {this.history = false});

  /// GetX tag of the Order History instance; the Orders tab uses no tag.
  static const historyTag = 'history';

  final DealerApiService _api;
  final OrderDocumentApiService _documents;
  final CartService _cart;

  /// True for Order History (delivered/cancelled), false for Current Orders.
  final bool history;

  final isLoading = false.obs;
  final orders = <OrderModel>[].obs;

  final search = ''.obs;
  late final filter = (history ? OrderFilter.past : OrderFilter.current).obs;
  final period = OrderPeriod.all.obs;

  List<OrderFilter> get tabs => history ? OrderFilter.historyTabs : OrderFilter.currentTabs;

  /// Orders matching the tab, time filter and search text.
  List<OrderModel> get filteredOrders {
    final term = search.value.trim();

    return orders
        .where((order) => filter.value.matches(order.status))
        .where((order) => period.value.includes(order.placedAt))
        .where((order) => term.isEmpty || order.matches(term))
        .toList();
  }

  /// Unique products from past orders, for the "Buy Again" tab.
  List<ProductModel> get buyAgainProducts {
    final term = search.value.trim().toLowerCase();
    final products = OrderProducts.fromItems(orders.expand((order) => order.items));

    return term.isEmpty ? products : products.where((product) => product.name.toLowerCase().contains(term)).toList();
  }

  @override
  void onReady() {
    super.onReady();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final response = await _api.orders();
      final list = _extractList(response, const ['orders', 'data']);
      orders.assignAll(list.whereType<Map>().map((item) => OrderModel.fromJson(Map<String, dynamic>.from(item))));
    } catch (_) {
      orders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void addToCart(ProductModel product) {
    _cart.add(product);
    Get.snackbar(t('common.added'), t('common.added_to_cart', {'name': product.name}), snackPosition: SnackPosition.BOTTOM);
  }

  /// Adds every product of [order] to the cart and opens the Cart tab.
  void buyAgain(OrderModel order) {
    final products = OrderProducts.fromItems(order.items);

    if (products.isEmpty) {
      Get.snackbar(t('common.buy_again'), t('orders.unavailable_products'));
      return;
    }

    products.forEach(_cart.add);
    Get.snackbar(t('orders.added_to_cart_title'), t('orders.added_from_order', {'n': '${products.length}', 'order': order.orderNo}), snackPosition: SnackPosition.BOTTOM);

    if (Get.isRegistered<MainShellController>()) {
      Get.find<MainShellController>().changeTab(2);
    }
  }

  /// Raises a return; the server re-checks the window and eligibility.
  Future<bool> requestReturn(OrderModel order, String reason) async {
    try {
      await _documents.requestReturn(orderId: order.id, reason: reason);
      Get.snackbar(t('orders.return_requested'), t('orders.return_received', {'order': order.orderNo}));
      return true;
    } catch (error) {
      Get.snackbar(t('orders.return'), error.toString());
      return false;
    }
  }

  /// Cancels this order; the server re-checks it is still before packing.
  Future<bool> cancelOrder(OrderModel order, String reason) async {
    try {
      await _api.cancelOrder(order.id, reason);
      Get.snackbar(t('orders.order_cancelled'), t('orders.order_cancelled_message', {'order': order.orderNo}));
      await loadOrders();
      return true;
    } catch (error) {
      Get.snackbar(t('orders.cancel_order'), error.toString());
      return false;
    }
  }

  List<dynamic> _extractList(dynamic value, List<String> preferredKeys) {
    if (value is List) return value;
    if (value is Map) {
      for (final key in preferredKeys) {
        final child = value[key];
        if (child is List) return child;
        if (child is Map) {
          final data = child['data'];
          if (data is List) return data;
          final items = child['items'];
          if (items is List) return items;
        }
      }
      final data = value['data'];
      if (data is List) return data;
      if (data is Map) return _extractList(data, preferredKeys);
    }
    return const [];
  }
}
