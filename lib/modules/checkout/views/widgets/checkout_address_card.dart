import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/services/address_selection_service.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/address_picker_sheet.dart';
import '../../../../app/localization/t.dart';

/// Chosen delivery address with a Change (or Add) action.
class CheckoutAddressCard extends StatelessWidget {
  const CheckoutAddressCard({super.key, required this.service});

  final AddressSelectionService service;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final address = service.selected.value;

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.location_on_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: address == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('checkout.no_address'), style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                        Text(t('checkout.no_address_hint'), style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('cart.deliver_to'), style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        Text(
                          [address.name, address.mobile].where((part) => part.isNotEmpty).join(' · '),
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(address.fullAddress, maxLines: 3, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
            ),
            TextButton(
              onPressed: () => address == null ? AddressPickerSheet.addNew(service) : AddressPickerSheet.show(service),
              child: Text(address == null ? t('address.add_short') : t('cart.change')),
            ),
          ],
        ),
      );
    });
  }
}
