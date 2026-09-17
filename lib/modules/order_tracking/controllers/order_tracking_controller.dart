import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../app/data/models/order_detail_model.dart';
import '../../../app/data/models/tracking_model.dart';
import '../../../app/data/services/order_document_api_service.dart';
import '../../../app/localization/t.dart';

/// Loads the delivery timeline and the full order for one order.
///
/// The order id arrives as a route argument (an int, or
/// `{'order_id': id, 'focus': 'items'}` from the "Details" button).
class OrderTrackingController extends GetxController {
  OrderTrackingController(this._api);

  final OrderDocumentApiService _api;

  final tracking = Rxn<OrderTrackingModel>();
  final detail = Rxn<OrderDetailModel>();
  final isLoading = false.obs;
  final error = ''.obs;

  /// Anchors the items section so "Details" can scroll straight to it.
  final itemsKey = GlobalKey();

  late final int orderId = _resolveOrderId();

  late final bool _focusItems = Get.arguments is Map && Get.arguments['focus'] == 'items';
  bool _focusConsumed = false;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  /// True once, when the screen was opened to show the items.
  bool consumeItemsFocus() {
    if (!_focusItems || _focusConsumed) return false;
    _focusConsumed = true;
    return true;
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
