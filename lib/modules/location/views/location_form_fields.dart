import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/localization/t.dart';
import '../controllers/location_form_controller.dart';
import '../models/location_option.dart';

/// State, District, Taluka dropdowns (each filled after the one above it is
/// chosen), an "Other" taluka name box, then City/Village and Pincode.
class LocationFormFields extends StatelessWidget {
  const LocationFormFields({super.key, required this.controller});

  final LocationFormController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Obx(
          () => _dropdown(
            label: t('location.state'),
            icon: Icons.map_outlined,
            value: controller.stateCode.value,
            items: controller.states,
            loading: controller.isLoadingStates.value,
            onChanged: (code) => controller.selectState(code),
          ),
        ),
        const SizedBox(height: 14),
        Obx(
          () => _dropdown(
            label: t('location.district'),
            icon: Icons.location_city_outlined,
            value: controller.districtCode.value,
            items: controller.districts,
            loading: controller.isLoadingDistricts.value,
            onChanged: controller.stateCode.value == null ? null : (code) => controller.selectDistrict(code),
          ),
        ),
        const SizedBox(height: 14),
        Obx(
          () => _dropdown(
            label: t('location.taluka'),
            icon: Icons.holiday_village_outlined,
            value: controller.subdistrictCode.value,
            items: [
              ...controller.subdistricts,
              if (controller.districtCode.value != null)
                LocationOption(code: LocationFormController.otherTaluka, name: t('location.other_taluka')),
            ],
            loading: controller.isLoadingSubdistricts.value,
            onChanged: controller.districtCode.value == null ? null : controller.selectSubdistrict,
          ),
        ),
        Obx(
          () => controller.isOtherTaluka
              ? Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: TextField(
                    controller: controller.talukaName,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: t('location.taluka_name'),
                      prefixIcon: const Icon(Icons.edit_location_alt_outlined),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: controller.cityVillage,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: t('location.city_village'),
            prefixIcon: const Icon(Icons.home_work_outlined),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: controller.pincode,
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: t('location.pincode'),
            prefixIcon: const Icon(Icons.pin_drop_outlined),
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<LocationOption> items,
    required bool loading,
    required ValueChanged<String?>? onChanged,
  }) {
    final hasValue = value != null && items.any((item) => item.code == value);

    return DropdownButtonFormField<String>(
      key: ValueKey('$label-${items.length}-$value'),
      initialValue: hasValue ? value : null,
      isExpanded: true,
      menuMaxHeight: 420,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: loading
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : null,
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item.code,
                child: Text(item.name, overflow: TextOverflow.ellipsis),
              ))
          .toList(),
      onChanged: loading ? null : onChanged,
    );
  }
}
