import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/localization/t.dart';
import '../models/location_option.dart';
import '../services/location_api_service.dart';

/// State -> District -> Taluka cascade plus City/Village and Pincode.
///
/// Used by registration and edit profile; `payload` is posted with the form
/// and matches the server's location fields.
class LocationFormController extends GetxController {
  LocationFormController(this._api);

  /// Taluka value meaning "not in the list, typed by hand".
  static const String otherTaluka = 'other';

  final LocationApiService _api;

  final states = <LocationOption>[].obs;
  final districts = <LocationOption>[].obs;
  final subdistricts = <LocationOption>[].obs;

  final stateCode = RxnString();
  final districtCode = RxnString();
  final subdistrictCode = RxnString();

  final isLoadingStates = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingSubdistricts = false.obs;

  final talukaName = TextEditingController();
  final cityVillage = TextEditingController();
  final pincode = TextEditingController();

  bool get isOtherTaluka => subdistrictCode.value == otherTaluka;

  @override
  void onInit() {
    super.onInit();
    loadStates();
  }

  Future<void> loadStates() async {
    isLoadingStates.value = true;
    try {
      states.assignAll(await _api.states());
    } catch (_) {
      Get.snackbar(t('location.title'), t('location.load_failed'));
    } finally {
      isLoadingStates.value = false;
    }
  }

  Future<void> selectState(String? code, {String? thenDistrict, String? thenTaluka}) async {
    stateCode.value = code;
    districtCode.value = null;
    subdistrictCode.value = null;
    districts.clear();
    subdistricts.clear();

    if (code == null || code.isEmpty) return;

    isLoadingDistricts.value = true;
    try {
      districts.assignAll(await _api.districts(code));
    } catch (_) {
      Get.snackbar(t('location.title'), t('location.load_failed'));
    } finally {
      isLoadingDistricts.value = false;
    }

    if (thenDistrict != null && districts.any((item) => item.code == thenDistrict)) {
      await selectDistrict(thenDistrict, thenTaluka: thenTaluka);
    }
  }

  Future<void> selectDistrict(String? code, {String? thenTaluka}) async {
    districtCode.value = code;
    subdistrictCode.value = null;
    subdistricts.clear();

    if (code == null || code.isEmpty) return;

    isLoadingSubdistricts.value = true;
    try {
      subdistricts.assignAll(await _api.subdistricts(code));
    } catch (_) {
      Get.snackbar(t('location.title'), t('location.load_failed'));
    } finally {
      isLoadingSubdistricts.value = false;
    }

    if (thenTaluka == otherTaluka || subdistricts.any((item) => item.code == thenTaluka)) {
      subdistrictCode.value = thenTaluka;
    }
  }

  void selectSubdistrict(String? code) => subdistrictCode.value = code;

  /// Fills the form from a user record returned by the profile endpoint.
  Future<void> prefill(Map<String, dynamic> user) async {
    String text(String key) => user[key]?.toString().trim() ?? '';

    cityVillage.text = text('city_village');
    pincode.text = text('pincode');
    talukaName.text = text('subdistrict_name');

    final state = text('state_code');
    if (state.isEmpty) return;

    if (states.isEmpty) await loadStates();

    final taluka = text('subdistrict_code').isNotEmpty
        ? text('subdistrict_code')
        : (talukaName.text.isNotEmpty ? otherTaluka : null);

    await selectState(state, thenDistrict: text('district_code'), thenTaluka: taluka);
  }

  /// Translated message for the first missing or invalid field, or null.
  String? validate() {
    if ((stateCode.value ?? '').isEmpty) return t('location.select_state');
    if ((districtCode.value ?? '').isEmpty) return t('location.select_district');
    if ((subdistrictCode.value ?? '').isEmpty) return t('location.select_taluka');
    if (isOtherTaluka && talukaName.text.trim().isEmpty) return t('location.enter_taluka');
    if (cityVillage.text.trim().length < 2) return t('location.enter_city');
    if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(pincode.text.trim())) return t('location.invalid_pincode');
    return null;
  }

  /// Shows the first problem as a snackbar; true when the location is complete.
  bool ensureValid() {
    final error = validate();
    if (error != null) {
      Get.snackbar(t('location.title'), error);
    }
    return error == null;
  }

  Map<String, dynamic> get payload => {
        'state_code': stateCode.value,
        'district_code': districtCode.value,
        'subdistrict_code': subdistrictCode.value,
        if (isOtherTaluka) 'subdistrict_name': talukaName.text.trim(),
        'city_village': cityVillage.text.trim(),
        'pincode': pincode.text.trim(),
      };

  @override
  void onClose() {
    talukaName.dispose();
    cityVillage.dispose();
    pincode.dispose();
    super.onClose();
  }
}
