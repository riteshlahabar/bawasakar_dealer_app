import 'package:get/get.dart';

import '../../../app/data/models/order_model.dart';
import '../../../app/data/services/dealer_api_service.dart';

class OrdersController extends GetxController {
  OrdersController(this._api);

  final DealerApiService _api;
  final isLoading = false.obs;
  final orders = <OrderModel>[].obs;

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
