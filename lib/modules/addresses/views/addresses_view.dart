import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/app_card.dart';
import '../controllers/addresses_controller.dart';

class AddressesView extends GetView<AddressesController> {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Address')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              children: [
                TextField(controller: controller.name, decoration: const InputDecoration(labelText: 'Full Name')),
                const SizedBox(height: 12),
                TextField(controller: controller.mobile, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number')),
                const SizedBox(height: 12),
                TextField(controller: controller.addressLine, minLines: 2, maxLines: 3, decoration: const InputDecoration(labelText: 'Address')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(controller: controller.city, decoration: const InputDecoration(labelText: 'City'))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: controller.state, decoration: const InputDecoration(labelText: 'State'))),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(controller: controller.pincode, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Pincode')),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(onPressed: controller.isLoading.value ? null : controller.save, child: Text(controller.isLoading.value ? 'Saving...' : 'Save Address'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
