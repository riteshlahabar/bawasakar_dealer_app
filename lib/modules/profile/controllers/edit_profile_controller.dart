import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/dealer_api_service.dart';
import '../../../app/utils/profile_fields.dart';
import '../../location/controllers/location_form_controller.dart';
import 'profile_controller.dart';
import '../../../app/localization/t.dart';

class EditProfileController extends GetxController {
  EditProfileController(this._api, this._profile, this.location);

  final DealerApiService _api;
  final ProfileController _profile;
  final LocationFormController location;

  final name = TextEditingController();
  final email = TextEditingController();
  final firmName = TextEditingController();
  final gstNumber = TextEditingController();
  final isSaving = false.obs;

  String get mobile {
    final value = ProfileFields.text(_profile.user['mobile']);
    return value.isNotEmpty ? value : _profile.mobile;
  }

  @override
  void onInit() {
    super.onInit();
    final user = _profile.user;
    final dealer = ProfileFields.map(user['dealer_profile']);

    name.text = ProfileFields.text(user['name']).isNotEmpty ? ProfileFields.text(user['name']) : _profile.name;
    email.text = ProfileFields.realEmail(ProfileFields.text(user['email']));
    firmName.text = ProfileFields.text(dealer['firm_name']);
    gstNumber.text = ProfileFields.text(dealer['gst_number']);
    location.prefill(user);
  }

  Future<void> save() async {
    if (name.text.trim().isEmpty || firmName.text.trim().isEmpty) {
      Get.snackbar(t('common.required'), t('profile.enter_name_firm'));
      return;
    }
    if (email.text.trim().isNotEmpty && !GetUtils.isEmail(email.text.trim())) {
      Get.snackbar(t('auth.invalid_email'), t('auth.enter_valid_email'));
      return;
    }
    final locationError = location.validate();
    if (locationError != null) {
      Get.snackbar(t('location.title'), locationError);
      return;
    }

    isSaving.value = true;
    try {
      await _api.updateProfile({
        'name': name.text.trim(),
        'email': email.text.trim().isEmpty ? null : email.text.trim(),
        'firm_name': firmName.text.trim(),
        'gst_number': gstNumber.text.trim().isEmpty ? null : gstNumber.text.trim().toUpperCase(),
        ...location.payload,
      });
      await _profile.loadProfile();
      Get.back<void>();
      Get.snackbar(t('profile.updated'), t('profile.updated_message'));
    } catch (error) {
      Get.snackbar(t('profile.update_failed'), error.toString());
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    firmName.dispose();
    gstNumber.dispose();
    super.onClose();
  }
}
