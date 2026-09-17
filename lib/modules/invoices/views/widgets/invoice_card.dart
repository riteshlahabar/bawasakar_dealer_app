import 'package:flutter/material.dart';

import '../../../../app/data/models/invoice_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_card.dart';
import '../../../../app/localization/t.dart';

/// One invoice row: number, linked order, date, amount and a download action.
class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onOpen,
    required this.onDownload,
    this.isDownloading = false,
  });

  final InvoiceModel invoice;
  final VoidCallback onOpen;
  final VoidCallback onDownload;
  final bool isDownloading;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt_long_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.invoiceNo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      invoice.orderNo.isEmpty
                          ? invoice.invoiceDate
                          : '${invoice.orderNo}  •  ${invoice.invoiceDate}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${invoice.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.border),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onOpen,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: Text(t('common.view')),
                  style: _actionStyle,
                ),
              ),
              Container(width: 1, height: 20, color: AppColors.border),
              Expanded(
                child: TextButton.icon(
                  onPressed: isDownloading ? null : onDownload,
                  icon: isDownloading
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.primary),
                        )
                      : const Icon(Icons.download_rounded, size: 18),
                  label: Text(isDownloading ? t('invoice.preparing') : t('invoice.download')),
                  style: _actionStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static final ButtonStyle _actionStyle = TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
  );
}
