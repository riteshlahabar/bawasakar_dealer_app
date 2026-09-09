import '../../config/api_config.dart';
import '../models/credit_model.dart';
import 'api_client.dart';

/// Credit limit, outstanding balance, ledger and payment history.
class DealerCreditApiService {
  DealerCreditApiService(this._client);

  final ApiClient _client;

  Future<CreditModel> outstanding() async {
    final response = await _client.getJson(ApiConfig.outstanding);
    final data = response['data'];

    return CreditModel.fromJson(
      data is Map<String, dynamic> ? data : const <String, dynamic>{},
    );
  }

  Future<List<LedgerEntryModel>> ledger({int page = 1}) async {
    final response = await _client.getJson(
      ApiConfig.ledger,
      query: {'page': page},
    );
    final raw = response['data']?['entries'];

    if (raw is! List) return const <LedgerEntryModel>[];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(LedgerEntryModel.fromJson)
        .toList();
  }

  /// Returns the page of payments plus the paid/pending totals the summary
  /// card shows, so the screen needs a single request.
  Future<({List<PaymentModel> payments, double paid, double pending})> payments({
    int page = 1,
  }) async {
    final response = await _client.getJson(
      ApiConfig.payments,
      query: {'page': page},
    );
    final data = response['data'];
    final raw = data?['payments'];
    final totals = data?['totals'];
    final totalsMap = totals is Map<String, dynamic> ? totals : const <String, dynamic>{};

    return (
      payments: raw is List
          ? raw.whereType<Map<String, dynamic>>().map(PaymentModel.fromJson).toList()
          : const <PaymentModel>[],
      paid: double.tryParse(totalsMap['paid']?.toString() ?? '') ?? 0,
      pending: double.tryParse(totalsMap['pending']?.toString() ?? '') ?? 0,
    );
  }
}
