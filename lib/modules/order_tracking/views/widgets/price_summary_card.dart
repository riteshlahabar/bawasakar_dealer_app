import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/models/order_detail_model.dart';
import '../../../../app/theme/app_colors.dart';
import 'tracking_section_card.dart';
import '../../../../app/localization/t.dart';

/// Subtotal, GST, discount and total, plus payment and delivery contact.
class PriceSummaryCard extends StatelessWidget {
  const PriceSummaryCard({super.key, required this.detail});

  final OrderDetailModel detail;

  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    final contact = [detail.contactName, detail.contactMobile].where((part) => part.isNotEmpty).join(' · ');

    return TrackingSectionCard(
      title: t('cart.price_details'),
      child: Column(
        children: [
          _amount(t('invoice.subtotal'), detail.subtotal),
          _amount(t('invoice.gst'), detail.gstTotal),
          if (detail.discountTotal > 0) _amount(t('invoice.discount'), -detail.discountTotal, color: AppColors.danger),
          const Divider(height: 22, color: AppColors.border),
          _amount(t('cart.total'), detail.grandTotal, bold: true),
          const SizedBox(height: 14),
          _info(t('checkout.payment_method'), detail.paymentMethodLabel),
          _info(t('tracking.payment_status'), detail.paymentStatusLabel),
          if (contact.isNotEmpty) _info(t('tracking.deliver_to'), contact),
          if (detail.notes.isNotEmpty) _info(t('common.notes'), detail.notes),
        ],
      ),
    );
  }

  Widget _amount(String label, double value, {bool bold = false, Color? color}) {
    final text = '${value < 0 ? '- ' : ''}₹${_money.format(value.abs())}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 14 : 12.5,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              color: bold ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            text,
            style: TextStyle(
              fontSize: bold ? 16 : 12.5,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
              color: color ?? (bold ? AppColors.primary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
