import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/services/address_selection_service.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/address_picker_sheet.dart';
import '../../../../app/localization/t.dart';

/// "Deliver to Ramesh – Pune 411001 · Change" strip at the top of the cart.
class CartDeliverToStrip extends StatelessWidget {
  const CartDeliverToStrip({super.key, required this.service});

  final AddressSelectionService service;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final address = service.selected.value;

      return Material(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => address == null ? AddressPickerSheet.addNew(service) : AddressPickerSheet.show(service),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address == null ? t('address.add_delivery') : t('address.deliver_to_label', {'address': address.shortLabel}),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  address == null ? t('address.add_short') : t('cart.change'),
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
