import 'package:get/get.dart';

import '../../../app/data/models/tracking_model.dart';
import '../../../app/data/services/order_document_api_service.dart';

/// Loads the delivery timeline for one order.
///
/// The order id arrives as a route argument so the screen can be pushed from
/// the order list, the order detail or a notification tap.
class OrderTrackingController extends GetxController {
  OrderTrackingController(this._api);

  final OrderDocumentApiService _api;

  final tracking = Rxn<OrderTrackingModel>();
  final isLoading = false.obs;
  final error = ''.obs;

  late final int orderId = _resolveOrderId();

  @override
  void onInit() {
    load();
    super.onInit();
  }

  int _resolveOrderId() {
    final argument = Get.arguments;
    if (argument is int) return argument;
    if (argument is Map && argument['order_id'] != null) {
      return int.tryParse(argument['order_id'].toString()) ?? 0;
    }
    return 0;
  }

  Future<void> load() async {
    if (orderId <= 0) {
      error.value = 'No order selected.';
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      tracking.value = await _api.tracking(orderId);
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
