import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/app_card.dart';
import '../controllers/addresses_controller.dart';
import '../../../app/localization/t.dart';

class AddressesView extends GetView<AddressesController> {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('address.add'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              children: [
                TextField(controller: controller.name, decoration: InputDecoration(labelText: t('address.full_name'))),
                const SizedBox(height: 12),
                TextField(controller: controller.mobile, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: t('address.mobile'))),
                const SizedBox(height: 12),
                TextField(controller: controller.addressLine, minLines: 2, maxLines: 3, decoration: InputDecoration(labelText: t('common.address'))),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(controller: controller.city, decoration: InputDecoration(labelText: t('common.city')))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: controller.state, decoration: InputDecoration(labelText: t('address.state')))),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(controller: controller.pincode, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: t('address.pincode'))),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(onPressed: controller.isLoading.value ? null : controller.save, child: Text(controller.isLoading.value ? t('common.saving') : t('address.save')))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
