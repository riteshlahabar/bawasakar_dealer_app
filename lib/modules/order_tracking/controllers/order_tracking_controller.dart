import 'package:get/get.dart';

import '../../../app/data/models/order_detail_model.dart';
import '../../../app/data/models/tracking_model.dart';
import '../../../app/data/services/order_document_api_service.dart';
import '../../../app/localization/t.dart';

/// Loads the delivery timeline and the full order for one order.
///
/// Shared by the Track Order screen (progress + timeline) and the Order
/// Details screen (items + price breakdown) — both need the same data, just
/// laid out differently, so one controller serves both routes.
class OrderTrackingController extends GetxController {
  OrderTrackingController(this._api);

  final OrderDocumentApiService _api;

  final tracking = Rxn<OrderTrackingModel>();
  final detail = Rxn<OrderDetailModel>();
  final isLoading = false.obs;
  final error = ''.obs;

  late final int orderId = Get.arguments is int ? Get.arguments as int : 0;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    if (orderId <= 0) {
      error.value = t('tracking.no_order');
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      // Both requests run together; order detail is extra and never blocks
      // the timeline.
      final detailFuture = _loadDetail();
      tracking.value = await _api.tracking(orderId);
      await detailFuture;
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadDetail() async {
    try {
      detail.value = await _api.orderDetail(orderId);
    } catch (_) {
      // Tracking still shows without the item list.
    }
  }
}
