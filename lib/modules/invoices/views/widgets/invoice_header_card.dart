import 'package:flutter/material.dart';

import '../../../../app/data/models/invoice_detail_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// The green invoice header: number, date, amount and linked order.
class InvoiceHeaderCard extends StatelessWidget {
  const InvoiceHeaderCard({super.key, required this.invoice});

  final InvoiceDetailModel invoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  invoice.invoiceNo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(t('invoice.invoice_date')),
                    Text(
                      invoice.invoiceDate.isEmpty ? '-' : invoice.invoiceDate,
                      style: _valueStyle,
                    ),
                    if (invoice.orderNo.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _label(t('orders.invoice')),
                      Text(invoice.orderNo, style: _valueStyle),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _label(t('invoice.total_amount')),
                  Text(
                    '₹${invoice.grandTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: .75),
            fontSize: 10,
            letterSpacing: .6,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  static const _valueStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 13.5,
  );
}
