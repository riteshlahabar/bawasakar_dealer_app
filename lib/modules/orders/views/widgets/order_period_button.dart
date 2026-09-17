import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../utils/order_filter.dart';
import '../../../../app/localization/t.dart';

/// Calendar button that picks the Order History time period.
class OrderPeriodButton extends StatelessWidget {
  const OrderPeriodButton({super.key, required this.period});

  final Rx<OrderPeriod> period;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = period.value != OrderPeriod.all;

      return PopupMenuButton<OrderPeriod>(
        tooltip: t('orders.time_period'),
        initialValue: period.value,
        onSelected: (value) => period.value = value,
        itemBuilder: (_) => [
          for (final option in OrderPeriod.values) PopupMenuItem(value: option, child: Text(option.title)),
        ],
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: active ? AppColors.primary : AppColors.border),
          ),
          child: Icon(Icons.calendar_month_outlined, color: active ? AppColors.primary : AppColors.textSecondary),
        ),
      );
    });
  }
}
