import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/models/order_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Bottom sheet asking why the order is being cancelled.
class CancelOrderSheet extends StatefulWidget {
  const CancelOrderSheet({super.key, required this.order, required this.onSubmit});

  final OrderModel order;

  /// Returns true when the cancellation was accepted.
  final Future<bool> Function(String reason) onSubmit;

  static Future<void> show(OrderModel order, Future<bool> Function(String reason) onSubmit) {
    return Get.bottomSheet<void>(
      CancelOrderSheet(order: order, onSubmit: onSubmit),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
  }

  @override
  State<CancelOrderSheet> createState() => _CancelOrderSheetState();
}

class _CancelOrderSheetState extends State<CancelOrderSheet> {
  final _reason = TextEditingController();
  bool _busy = false;

  Future<void> _submit() async {
    final reason = _reason.text.trim();
    if (reason.isEmpty) {
      Get.snackbar(t('orders.cancel_order'), t('orders.tell_why_cancelling'));
      return;
    }

    setState(() => _busy = true);
    final accepted = await widget.onSubmit(reason);
    if (!mounted) return;
    setState(() => _busy = false);

    if (accepted) Get.back<void>();
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 16),
            Text('${t('orders.cancel_order')} ${widget.order.orderNo}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(t('orders.cancel_not_reversible'), style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
            const SizedBox(height: 14),
            TextField(
              controller: _reason,
              maxLines: 3,
              decoration: InputDecoration(labelText: t('orders.cancellation_reason')),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: _busy ? null : _submit,
              child: Text(_busy ? t('common.submitting') : t('orders.cancel_order')),
            ),
          ],
        ),
      ),
    );
  }
}
