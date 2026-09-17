import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/invoice_detail_controller.dart';
import 'widgets/invoice_header_card.dart';
import 'widgets/invoice_items_card.dart';
import 'widgets/invoice_totals_card.dart';
import '../../../app/localization/t.dart';

class InvoiceDetailView extends GetView<InvoiceDetailController> {
  const InvoiceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text(t('invoice.title'))),
      body: Obx(() {
        if (controller.isLoading.value && controller.invoice.value == null) {
          return LoadingView(message: t('common.loading'));
        }

        final invoice = controller.invoice.value;

        if (invoice == null) {
          return EmptyState(
            title: t('invoice.unavailable'),
            message: controller.error.value.isEmpty
                ? t('invoice.empty_message')
                : controller.error.value,
            icon: Icons.receipt_long_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              InvoiceHeaderCard(invoice: invoice),
              if (invoice.hasItems) InvoiceItemsCard(items: invoice.items),
              InvoiceTotalsCard(invoice: invoice),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(
        () => SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: controller.isDownloading.value ? null : controller.download,
              icon: controller.isDownloading.value
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.download_rounded, size: 20),
              label: Text(
                controller.isDownloading.value
                    ? t('invoice.preparing')
                    : t('invoice.download'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
