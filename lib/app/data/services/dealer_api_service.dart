import 'dart:io';

import 'package:get/get.dart' show FormData, MultipartFile;

import '../../config/api_config.dart';
import '../models/address_model.dart';
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

  /// Returns a login/approval response for a registered dealer, or
  /// `registration_required` + `registration_token` for a new number.
  Future<Map<String, dynamic>> verifyOtp({required String mobile, required String otp}) {
    return _client.postJson(ApiConfig.verifyDealerOtp, {
      'mobile': mobile,
      'otp': otp,
    });
  }

  Future<Map<String, dynamic>> registerDealer({
    required String registrationToken,
    required String name,
    required String firmName,
    String? gstNumber,
    Map<String, dynamic> location = const {},
  }) {
    return _client.postJson(ApiConfig.registerDealer, {
      ...location,
      'registration_token': registrationToken,
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
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) => _client.postJson(ApiConfig.dealerProfile, data);

  Future<Map<String, dynamic>> uploadProfilePhoto(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final filename = filePath.split(RegExp(r'[\\/]')).last;

    return _client.postForm(ApiConfig.profilePhoto, FormData({'photo': MultipartFile(bytes, filename: filename)}));
  }
  Future<Map<String, dynamic>> statements() => _client.getJson(ApiConfig.dealerStatements);
  Future<Map<String, dynamic>> saveAddress(Map<String, dynamic> data) => _client.postJson(ApiConfig.dealerAddresses, data);

  /// Saved delivery addresses, default first.
  Future<List<AddressModel>> addresses() async {
    final response = await _client.getJson(ApiConfig.dealerAddresses);
    final raw = response['data']?['addresses'];

    if (raw is! List) return const [];

    return raw.whereType<Map>().map((item) => AddressModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }
  Future<Map<String, dynamic>> support({required String subject, required String message}) => _client.postJson(ApiConfig.dealerSupport, {'subject': subject, 'message': message});

  Future<Map<String, dynamic>> products({
  String audience = 'dealer',
  String? search,
  int? categoryId,
  String? categorySlug,
  int page = 1,
  int perPage = 20,
  // true bypasses the server cache — only for pull-to-refresh.
  bool fresh = false,
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
  bool fresh = false,
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

  /// Places a dealer order. Delivery details and payment go in their own
  /// fields — the server stores them on the order — so `notes` carries only
  /// what the dealer actually typed.
  Future<Map<String, dynamic>> createOrder(
    List<Map<String, dynamic>> items, {
    String? notes,
    AddressModel? address,
    String? paymentMethod,
  }) {
    return _client.postJson(ApiConfig.dealerOrders, {
      'items': items,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      if (paymentMethod != null && paymentMethod.trim().isNotEmpty)
        'payment_method': paymentMethod.trim(),
      if (address != null) ...{
        'contact_name': address.name,
        'contact_mobile': address.mobile,
        'address_line1': address.line1,
        if (address.line2.isNotEmpty) 'address_line2': address.line2,
        if (address.city.isNotEmpty) 'city': address.city,
        if (address.state.isNotEmpty) 'state': address.state,
        if (address.pincode.isNotEmpty) 'pincode': address.pincode,
      },
    });
  }

  Future<Map<String, dynamic>> cancelOrder(int orderId, String reason) {
    return _client.postJson(ApiConfig.dealerOrderCancel(orderId), {'reason': reason.trim()});
  }

  /// False for accounts created by mobile OTP that never set a password.
  Future<bool> hasPassword() async {
    final response = await _client.getJson(ApiConfig.changePassword);
    final value = response['data']?['has_password'];

    return value == true || value == 1;
  }

  Future<Map<String, dynamic>> changePassword({
    String? currentPassword,
    required String password,
    required String confirmation,
  }) {
    return _client.postJson(ApiConfig.changePassword, {
      if (currentPassword != null && currentPassword.isNotEmpty) 'current_password': currentPassword,
      'password': password,
      'password_confirmation': confirmation,
    });
  }

  Future<Map<String, dynamic>> logout() => _client.postJson(ApiConfig.logout, {});
}
