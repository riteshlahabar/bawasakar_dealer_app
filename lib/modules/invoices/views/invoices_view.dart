import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/invoices_controller.dart';
import 'widgets/invoice_card.dart';
import 'widgets/invoice_search_field.dart';
import '../../../app/localization/t.dart';

class InvoicesView extends GetView<InvoicesController> {
  const InvoicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: Text(t('menu.invoices'))),
      body: Obx(() {
        if (controller.isLoading.value && controller.invoices.isEmpty) {
          return LoadingView(message: t('common.loading'));
        }
        if (controller.isEmpty) {
          return EmptyState(
            title: t('invoice.empty_title'),
            message: t('invoice.empty_message'),
            icon: Icons.receipt_long_outlined,
          );
        }

        final invoices = controller.visibleInvoices;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: Column(
            children: [
              InvoiceSearchField(onChanged: controller.onSearchChanged),
              Expanded(
                child: invoices.isEmpty
                    ? EmptyState(
                        title: t('invoice.no_match_title'),
                        message: t('invoice.no_match_message'),
                        icon: Icons.search_off_rounded,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: invoices.length,
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];

                          return InvoiceCard(
                            invoice: invoice,
                            isDownloading:
                                controller.downloadingId.value == invoice.id,
                            onOpen: () => Get.toNamed<void>(
                              AppRoutes.invoiceDetail,
                              arguments: invoice.id,
                            ),
                            onDownload: () => controller.download(invoice),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
