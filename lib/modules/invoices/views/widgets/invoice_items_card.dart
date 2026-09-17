import 'package:flutter/material.dart';

import '../../../../app/data/models/invoice_detail_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/app_card.dart';
import '../../../../app/localization/t.dart';

/// The billed lines of an invoice.
class InvoiceItemsCard extends StatelessWidget {
  const InvoiceItemsCard({super.key, required this.items});

  final List<InvoiceItemModel> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('invoice.items'),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const Divider(height: 18, color: AppColors.border),
            _row(items[index]),
          ],
        ],
      ),
    );
  }

  Widget _row(InvoiceItemModel item) {
    final subtitle = item.subtitle;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                '${_trim(item.quantity)} × ₹${item.unitPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '₹${item.lineTotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  static String _trim(double value) {
    final text = value.toStringAsFixed(3);
    final trimmed = text.replaceFirst(RegExp(r'\.?0+$'), '');
    return trimmed.isEmpty ? '0' : trimmed;
  }
}
