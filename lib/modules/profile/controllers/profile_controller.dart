import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/data/cache/json_cache_store.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/profile_fields.dart';
import '../../../app/localization/t.dart';

class ProfileController extends GetxController {
  ProfileController(this._api, this._storage, this._cache, this._picker);

  final DealerApiService _api;
  final AuthStorage _storage;
  final JsonCacheStore _cache;
  final ImagePicker _picker;
  final isLoading = false.obs;
  final isUploading = false.obs;
  final profile = <String, dynamic>{}.obs;

  String get name => _storage.userName ?? t('common.dealer');
  String get mobile => _storage.mobile ?? '';
  String get email => _storage.email ?? '';

  Map<String, dynamic> get user => ProfileFields.map(profile['user']);

  String get photoUrl => ProfileFields.text(user['profile_photo_url']);

  String get firmName => ProfileFields.text(ProfileFields.map(user['dealer_profile'])['firm_name']);

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

  /// Picks a photo from [source], shrinks it, and uploads it as the profile photo.
  Future<void> changePhoto(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, maxWidth: 800, maxHeight: 800, imageQuality: 80);
      if (file == null) return;

      isUploading.value = true;
      await _api.uploadProfilePhoto(file.path);
      await loadProfile();
      Get.snackbar(t('profile.photo_updated'), t('profile.photo_updated_message'));
    } catch (error) {
      Get.snackbar(t('profile.upload_failed'), error.toString());
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> logout() async {
    try { await _api.logout(); } catch (_) {}
    await _storage.clear();
    await _cache.clear();
    Get.offAllNamed(AppRoutes.login);
  }
}
