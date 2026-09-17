import 'package:flutter/material.dart';

import '../../../../app/data/models/invoice_detail_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_card.dart';
import '../../../../app/localization/t.dart';

/// Subtotal, GST, discount and the grand total.
class InvoiceTotalsCard extends StatelessWidget {
  const InvoiceTotalsCard({super.key, required this.invoice});

  final InvoiceDetailModel invoice;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('invoice.amount_details'),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _line(t('invoice.subtotal'), invoice.subtotal),
          _line(t('invoice.gst'), invoice.gstTotal),
          if (invoice.discountTotal > 0)
            _line(t('invoice.discount'), -invoice.discountTotal, isDiscount: true),
          const Divider(height: 18, color: AppColors.border),
          _line(t('invoice.grand_total'), invoice.grandTotal, isTotal: true),
        ],
      ),
    );
  }

  Widget _line(String label, double value,
      {bool isTotal = false, bool isDiscount = false}) {
    final color = isTotal
        ? AppColors.textPrimary
        : (isDiscount ? AppColors.success : AppColors.textSecondary);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 14 : 12.5,
                fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
                color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            '${value < 0 ? '- ' : ''}₹${value.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
