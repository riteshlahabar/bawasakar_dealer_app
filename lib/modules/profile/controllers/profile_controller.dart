import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/routes/app_routes.dart';

class ProfileController extends GetxController {
  ProfileController(this._api, this._storage);

  final DealerApiService _api;
  final AuthStorage _storage;
  final isLoading = false.obs;
  final profile = <String, dynamic>{}.obs;

  String get name => _storage.userName ?? 'Dealer';
  String get mobile => _storage.mobile ?? '';
  String get email => _storage.email ?? '';

  String get firmName {
    final data = profile['user'];
    if (data is Map && data['dealer_profile'] is Map) {
      return data['dealer_profile']['firm_name']?.toString() ?? '';
    }
    return '';
  }

  @override
  void onReady() {
    super.onReady();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final response = await _api.profile();
      profile.value = Map<String, dynamic>.from((response['data'] ?? const {}) as Map);
    } catch (_) {
      profile.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try { await _api.logout(); } catch (_) {}
    await _storage.clear();
    Get.offAllNamed(AppRoutes.login);
  }
}
