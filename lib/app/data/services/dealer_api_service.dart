import '../../config/api_config.dart';
import 'api_client.dart';

class DealerApiService {
  DealerApiService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> requestOtp(String mobile) {
    return _client.postJson(ApiConfig.requestOtp, {
      'mobile': mobile,
      'purpose': 'dealer_login',
    });
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
    required String name,
    required String firmName,
    String? gstNumber,
  }) {
    return _client.postJson(ApiConfig.verifyDealerOtp, {
      'mobile': mobile,
      'otp': otp,
      'name': name,
      'firm_name': firmName,
      if (gstNumber != null && gstNumber.trim().isNotEmpty) 'gst_number': gstNumber.trim(),
    });
  }

  Future<Map<String, dynamic>> emailLogin({required String email, required String password}) {
    return _client.postJson(ApiConfig.emailLogin, {
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> dashboard() => _client.getJson(ApiConfig.dealerDashboard);
  Future<Map<String, dynamic>> homepage() {
  return _client.getJson(
    ApiConfig.homepage,
    query: {
      'audience': 'dealer',
    },
  );
}
  Future<Map<String, dynamic>> profile() => _client.getJson(ApiConfig.dealerProfile);
  Future<Map<String, dynamic>> statements() => _client.getJson(ApiConfig.dealerStatements);
  Future<Map<String, dynamic>> saveAddress(Map<String, dynamic> data) => _client.postJson(ApiConfig.dealerAddresses, data);
  Future<Map<String, dynamic>> support({required String subject, required String message}) => _client.postJson(ApiConfig.dealerSupport, {'subject': subject, 'message': message});

  Future<Map<String, dynamic>> products({
  String audience = 'dealer',
  String? search,
  int? categoryId,
  String? categorySlug,
  int page = 1,
  int perPage = 100,
  bool fresh = true,
}) {
  return _client.getJson(
    ApiConfig.products,
    query: {
      'audience': audience,
      if (fresh) 'fresh': 1,
      'page': page,
      'per_page': perPage,
      if (search != null && search.trim().isNotEmpty)
        'search': search.trim(),
      if (categoryId != null && categoryId > 0)
        'category_id': categoryId,
      if (categorySlug != null &&
          categorySlug.trim().isNotEmpty)
        'category': categorySlug.trim(),
    },
  );
}

Future<Map<String, dynamic>> categories({
  bool fresh = true,
}) {
  return _client.getJson(
    ApiConfig.categories,
    query: {
      'audience': 'dealer',
      if (fresh) 'fresh': 1,
    },
  );
}



  Future<Map<String, dynamic>> orders() => _client.getJson(ApiConfig.dealerOrders);

  Future<Map<String, dynamic>> createOrder(List<Map<String, dynamic>> items, {String? notes}) {
    return _client.postJson(ApiConfig.dealerOrders, {
      'items': items,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
    });
  }

  Future<Map<String, dynamic>> logout() => _client.postJson(ApiConfig.logout, {});
}
