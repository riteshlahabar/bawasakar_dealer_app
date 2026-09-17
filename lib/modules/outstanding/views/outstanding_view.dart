import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/outstanding_controller.dart';
import 'widgets/credit_gauge.dart';
import '../../../app/localization/t.dart';

class OutstandingView extends GetView<OutstandingController> {
  const OutstandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('menu.outstanding'))),
      body: Obx(() {
        if (controller.isLoading.value && controller.credit.value == null) {
          return LoadingView(message: t('common.loading'));
        }

        final credit = controller.credit.value;

        if (credit == null) {
          return EmptyState(
            title: t('outstanding.unavailable'),
            message: controller.error.value.isEmpty
                ? t('outstanding.load_failed')
                : controller.error.value,
            icon: Icons.account_balance_wallet_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(child: CreditGauge(credit: credit)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: t('outstanding.unpaid_orders'),
                      value: credit.unpaidOrders.toString(),
                      icon: Icons.pending_actions_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      label: t('outstanding.last_payment'),
                      value: credit.lastPayment == null
                          ? '-'
                          : '₹${credit.lastPayment!.amount.toStringAsFixed(0)}',
                      icon: Icons.payments_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                t('outstanding.ledger'),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
              ),
              const SizedBox(height: 10),
              if (controller.ledger.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    t('outstanding.no_ledger'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                  ),
                )
              else
                ...controller.ledger.map(
                  (entry) => AppCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.entryType.replaceAll('_', ' ').toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                              if (entry.remarks.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(
                                  entry.remarks,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              entry.isDebit
                                  ? '+₹${entry.debit.toStringAsFixed(2)}'
                                  : '-₹${entry.credit.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: entry.isDebit ? AppColors.danger : AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Bal ₹${entry.balance.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
