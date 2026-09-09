import '../../config/api_config.dart';
import '../models/invoice_model.dart';
import '../models/return_request_model.dart';
import '../models/tracking_model.dart';
import 'api_client.dart';

/// Everything an order produces after it is placed: its delivery timeline, its
/// invoice, and any return raised against it.
class OrderDocumentApiService {
  OrderDocumentApiService(this._client);

  final ApiClient _client;

  Future<OrderTrackingModel> tracking(int orderId) async {
    final response = await _client.getJson(ApiConfig.orderTracking(orderId));
    final data = response['data'];

    return OrderTrackingModel.fromJson(
      data is Map<String, dynamic> ? data : const <String, dynamic>{},
    );
  }

  Future<List<InvoiceModel>> invoices({int page = 1}) async {
    final response = await _client.getJson(
      ApiConfig.invoices,
      query: {'page': page},
    );
    final raw = response['data']?['invoices'];

    if (raw is! List) return const <InvoiceModel>[];

    return raw.whereType<Map<String, dynamic>>().map(InvoiceModel.fromJson).toList();
  }

  Future<List<ReturnRequestModel>> returns({int page = 1}) async {
    final response = await _client.getJson(
      ApiConfig.returns,
      query: {'page': page},
    );
    final raw = response['data']?['returns'];

    if (raw is! List) return const <ReturnRequestModel>[];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(ReturnRequestModel.fromJson)
        .toList();
  }

  Future<void> requestReturn({
    required int orderId,
    required String reason,
    double? refundAmount,
  }) {
    return _client.postJson(ApiConfig.returns, {
      'order_id': orderId,
      'reason': reason.trim(),
      if (refundAmount != null && refundAmount > 0) 'refund_amount': refundAmount,
    });
  }
}
