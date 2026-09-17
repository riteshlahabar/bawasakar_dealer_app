import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/utils/profile_fields.dart';
import '../controllers/profile_controller.dart';
import 'widgets/profile_detail_section.dart';
import 'widgets/profile_header_card.dart';
import '../../../app/localization/t.dart';

/// Account page: the dealer's profile details and photo (menus live in the chips).
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.user;
      final dealer = ProfileFields.map(user['dealer_profile']);
      final salesman = ProfileFields.map(dealer['salesman']);
      final address = ProfileFields.defaultAddress(user['addresses']);
      final name = ProfileFields.text(user['name']).isNotEmpty ? ProfileFields.text(user['name']) : controller.name;
      final firm = controller.firmName;
      final mobile = ProfileFields.text(user['mobile']).isNotEmpty ? ProfileFields.text(user['mobile']) : controller.mobile;
      final email = ProfileFields.realEmail(ProfileFields.text(user['email']).isNotEmpty ? ProfileFields.text(user['email']) : controller.email);

      return RefreshIndicator(
        onRefresh: controller.loadProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            ProfileHeaderCard(
              photoUrl: controller.photoUrl,
              title: firm.isNotEmpty ? firm : name,
              subtitle: name + (mobile.isNotEmpty ? ' • $mobile' : ''),
              uploading: controller.isUploading.value,
              onPick: controller.changePhoto,
              placeholderIcon: Icons.storefront_rounded,
            ),
            if (controller.isLoading.value && user.isEmpty)
              const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
            const SizedBox(height: 14),
            ProfileDetailSection(title: t('account.profile_details'), details: [
              (icon: Icons.person_outline_rounded, label: t('address.name'), value: name),
              (icon: Icons.store_outlined, label: t('account.firm_name'), value: firm),
              (icon: Icons.badge_outlined, label: t('account.dealer_code'), value: ProfileFields.text(dealer['dealer_code'])),
              (icon: Icons.receipt_outlined, label: t('account.gst_number_plain'), value: ProfileFields.text(dealer['gst_number'])),
              (icon: Icons.phone_outlined, label: t('auth.mobile'), value: mobile),
              (icon: Icons.email_outlined, label: t('common.email'), value: email),
              (icon: Icons.support_agent_outlined, label: t('account.assigned_salesman'), value: ProfileFields.text(salesman['name'])),
            ]),
            const SizedBox(height: 14),
            ProfileDetailSection(title: t('address.delivery_address'), details: [
              (
                icon: Icons.location_on_outlined,
                label: address.isEmpty ? 'Address' : ProfileFields.text(address['name']),
                value: ProfileFields.addressLine(address),
              ),
            ]),
          ],
        ),
      );
    });
  }
}
