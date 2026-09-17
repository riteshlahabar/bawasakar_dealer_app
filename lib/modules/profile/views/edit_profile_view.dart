import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/app_card.dart';
import '../../location/views/location_form_fields.dart';
import '../controllers/edit_profile_controller.dart';
import '../../../app/localization/t.dart';

/// Edit name, email and firm details. Mobile is the login identity, so it
/// is shown but cannot be changed; the photo is changed on the Account screen.
class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('menu.edit_profile'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: controller.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: t('address.name'), prefixIcon: Icon(Icons.person_outline_rounded)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: controller.mobile,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: t('auth.mobile'),
                    helperText: t('profile.mobile_locked'),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: t('account.email_optional'), prefixIcon: Icon(Icons.email_outlined)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.firmName,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: t('account.firm_name'), prefixIcon: Icon(Icons.store_outlined)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.gstNumber,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(labelText: t('account.gst_number'), prefixIcon: Icon(Icons.receipt_outlined)),
                ),
                const SizedBox(height: 12),
                LocationFormFields(controller: controller.location),
                const SizedBox(height: 20),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isSaving.value ? null : controller.save,
                    child: Text(controller.isSaving.value ? t('common.saving') : t('profile.save_changes')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
