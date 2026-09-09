import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.firmName.isNotEmpty ? controller.firmName : controller.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(controller.name + (controller.mobile.isNotEmpty ? ' • ${controller.mobile}' : ''), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _MenuTile(icon: Icons.account_balance_wallet_outlined, title: 'Outstanding & Credit', subtitle: 'Credit limit, balance and ledger', onTap: () => Get.toNamed(AppRoutes.outstanding)),
        _MenuTile(icon: Icons.payments_outlined, title: 'Payments', subtitle: 'Your payment history', onTap: () => Get.toNamed(AppRoutes.payments)),
        _MenuTile(icon: Icons.receipt_long_outlined, title: 'Invoices', subtitle: 'Invoices raised against your orders', onTap: () => Get.toNamed(AppRoutes.invoices)),
        _MenuTile(icon: Icons.assignment_return_outlined, title: 'Returns', subtitle: 'Track your return requests', onTap: () => Get.toNamed(AppRoutes.returns)),
        _MenuTile(icon: Icons.insert_chart_outlined, title: 'Reports', subtitle: 'Purchase and product-wise reports', onTap: () => Get.toNamed(AppRoutes.reports)),
        _MenuTile(icon: Icons.notifications_none_rounded, title: 'Notifications', subtitle: 'Approvals, dispatches and notices', onTap: () => Get.toNamed(AppRoutes.notifications)),
        _MenuTile(icon: Icons.support_agent_rounded, title: 'Support Ticket', subtitle: 'Need help with dealer orders?', onTap: () => Get.toNamed(AppRoutes.support)),
        _MenuTile(icon: Icons.language_rounded, title: 'Language', subtitle: 'English / Marathi / Hindi', onTap: () {}),
        _MenuTile(icon: Icons.logout_rounded, title: 'Logout', subtitle: 'Sign out from dealer app', onTap: controller.logout, danger: true),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, required this.subtitle, required this.onTap, this.danger = false});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: danger ? AppColors.danger.withValues(alpha: .1) : AppColors.primarySoft, child: Icon(icon, color: danger ? AppColors.danger : AppColors.primary)),
        title: Text(title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: danger ? AppColors.danger : AppColors.textPrimary)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
