import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/payments_controller.dart';

class PaymentsView extends GetView<PaymentsController> {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: Obx(() {
        if (controller.isLoading.value && controller.payments.isEmpty) {
          return const LoadingView(message: 'Loading payments...');
        }
        if (controller.isEmpty) {
          return const EmptyState(
            title: 'No payments yet',
            message: 'Payments you make against invoices will appear here.',
            icon: Icons.payments_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: _Total(
                        label: 'Paid',
                        value: controller.paidTotal.value,
                        color: AppColors.success,
                      ),
                    ),
                    Container(width: 1, height: 34, color: AppColors.border),
                    Expanded(
                      child: _Total(
                        label: 'Pending',
                        value: controller.pendingTotal.value,
                        color: AppColors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ...controller.payments.map(
                (payment) => AppCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 19,
                        backgroundColor: AppColors.primarySoft,
                        child: const Icon(Icons.receipt_outlined,
                            color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment.paymentNo,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${payment.mode.toUpperCase()}'
                              '${payment.orderNo.isEmpty ? '' : ' • ${payment.orderNo}'}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${payment.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13.5,
                        ),
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

class _Total extends StatelessWidget {
  const _Total({required this.label, required this.value, required this.color});

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '₹${value.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
        ),
      ],
    );
  }
}
