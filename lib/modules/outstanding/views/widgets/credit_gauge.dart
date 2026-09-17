import 'package:flutter/material.dart';

import '../../../../app/data/models/credit_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Credit limit, used balance and remaining headroom as a single bar.
///
/// Its own widget so the outstanding screen stays a layout file and the same
/// gauge can be dropped onto the dashboard later.
class CreditGauge extends StatelessWidget {
  const CreditGauge({super.key, required this.credit});

  final CreditModel credit;

  @override
  Widget build(BuildContext context) {
    final barColor = credit.isOverLimit ? AppColors.danger : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('home.outstanding'),
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹${credit.outstandingBalance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: barColor,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  t('common.credit_limit'),
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹${credit.creditLimit.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: credit.utilisation,
            minHeight: 9,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              credit.isOverLimit
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_outline_rounded,
              size: 15,
              color: barColor,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                credit.isOverLimit
                    ? t('outstanding.over_limit')
                    : t('outstanding.still_available', {'amount': '₹${credit.availableCredit.toStringAsFixed(2)}'}),
                style: TextStyle(
                  color: barColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
