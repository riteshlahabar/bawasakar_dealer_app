import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/services/address_selection_service.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../../app/localization/t.dart';

/// Bottom sheet to choose one of the saved delivery addresses or add a new one.
class AddressPickerSheet extends StatelessWidget {
  const AddressPickerSheet({super.key, required this.service});

  final AddressSelectionService service;

  static Future<void> show(AddressSelectionService service) {
    return Get.bottomSheet<void>(
      AddressPickerSheet(service: service),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
  }

  /// Opens the add-address screen, then refreshes the list.
  static Future<void> addNew(AddressSelectionService service) async {
    await Get.toNamed<void>(AppRoutes.addresses);
    await service.load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 14),
            Text(t('address.choose'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Flexible(
              child: Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  itemCount: service.addresses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final address = service.addresses[index];
                    final selected = service.selected.value?.id == address.id;

                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        service.select(address);
                        Get.back<void>();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.5 : 1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(address.name, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  Text(address.fullAddress, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  if (address.mobile.isNotEmpty)
                                    Text(address.mobile, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            if (address.isDefault)
                              Text(t('common.default'), style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Get.back<void>();
                addNew(service);
              },
              icon: const Icon(Icons.add_location_alt_outlined, size: 18),
              label: Text(t('address.add_new')),
            ),
          ],
        ),
      ),
    );
  }
}
