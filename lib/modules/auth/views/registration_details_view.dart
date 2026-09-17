import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../location/views/location_form_fields.dart';
import '../controllers/registration_controller.dart';
import 'widgets/auth_info_note.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/auth_submit_button.dart';
import 'widgets/registration_steps.dart';
import 'widgets/verified_mobile_badge.dart';
import '../../../app/localization/t.dart';

/// Registration step 3: firm details for the verified mobile.
class RegistrationDetailsView extends GetView<RegistrationController> {
  const RegistrationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: t('auth.firm_details'),
      subtitle: t('auth.register_title'),
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RegistrationSteps(current: 2),
          const SizedBox(height: 22),
          VerifiedMobileBadge(mobile: controller.mobile),
          const SizedBox(height: 18),
          TextField(
            controller: controller.nameController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline_rounded),
              labelText: t('account.owner_name'),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.firmNameController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.storefront_outlined),
              labelText: t('auth.firm_shop_name'),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.gstController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            maxLength: 15,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.receipt_long_outlined),
              labelText: t('account.gst_number'),
              counterText: '',
            ),
          ),
          const SizedBox(height: 14),
          LocationFormFields(controller: controller.location),
          const SizedBox(height: 14),
          AuthInfoNote(
            icon: Icons.verified_user_outlined,
            text: t('auth.approval_note'),
          ),
          const SizedBox(height: 22),
          Obx(
            () => AuthSubmitButton(
              label: t('auth.submit_registration'),
              isLoading: controller.isLoading.value,
              onPressed: controller.submit,
            ),
          ),
        ],
      ),
    );
  }
}
