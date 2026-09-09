import '../../config/api_config.dart';
import '../models/report_model.dart';
import 'api_client.dart';

/// Purchase reporting for the dealer.
class DealerReportApiService {
  DealerReportApiService(this._client);

  final ApiClient _client;

  Future<OrderReportModel> orderReport({int months = 6}) async {
    final response = await _client.getJson(
      ApiConfig.orderReport,
      query: {'months': months},
    );
    final data = response['data'];

    return OrderReportModel.fromJson(
      data is Map<String, dynamic> ? data : const <String, dynamic>{},
    );
  }

  Future<List<ProductSalesModel>> salesReport({int months = 6}) async {
    final response = await _client.getJson(
      ApiConfig.salesReport,
      query: {'months': months},
    );
    final raw = response['data']?['products'];

    if (raw is! List) return const <ProductSalesModel>[];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(ProductSalesModel.fromJson)
        .toList();
  }
}
