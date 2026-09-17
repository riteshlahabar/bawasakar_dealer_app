import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app/data/models/order_detail_model.dart';
import '../../../../app/data/models/tracking_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/localization/t.dart';

/// Six icon tiles, two per row: tracking code, courier, package, from,
/// destination and last update — same details as the website.
class TrackingInfoGrid extends StatelessWidget {
  const TrackingInfoGrid({super.key, required this.tracking, this.detail});

  final OrderTrackingModel tracking;
  final OrderDetailModel? detail;

  static const warehouse = 'Dr. Bawaskar Technology Warehouse';
  static const deliveryDesk = 'Bawaskar Delivery Desk';
  static final _money = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    final courier = tracking.courier;
    final order = detail;
    final trackingNo = courier?.trackingNo ?? '';
    final courierName = courier?.name ?? '';

    final tiles = [
      _Tile(
        Icons.qr_code_2_rounded,
        t('tracking.code'),
        trackingNo.isNotEmpty ? trackingNo : ((order?.dispatchNo ?? '').isNotEmpty ? order!.dispatchNo : tracking.orderNo),
        highlight: true,
      ),
      _Tile(
        Icons.local_shipping_outlined,
        t('tracking.courier'),
        courierName.isNotEmpty ? courierName : deliveryDesk,
        hint: (courier?.hasLink ?? false) ? t('tracking.tap_copy') : null,
        onTap: (courier?.hasLink ?? false) ? () => _copyLink(courier!.trackingUrl!) : null,
      ),
      _Tile(
        Icons.inventory_2_outlined,
        t('tracking.package'),
        order == null
            ? '₹${_money.format(tracking.total)}'
            : t('tracking.package_summary', {'n': '${order.items.length}', 'amount': '₹${_money.format(order.grandTotal)}'}),
      ),
      _Tile(Icons.warehouse_outlined, t('tracking.from'), warehouse),
      _Tile(
        Icons.location_on_outlined,
        t('tracking.destination'),
        (order?.address ?? '').isNotEmpty ? order!.address : t('address.not_available'),
      ),
      _Tile(Icons.update_rounded, t('tracking.last_update'), tracking.lastDoneStage?.dateTimeLabel ?? t('common.pending')),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 10) / 2;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final tile in tiles) SizedBox(width: width, child: _tileCard(tile)),
          ],
        );
      },
    );
  }

  Future<void> _copyLink(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    Get.snackbar(t('common.copied'), t('tracking.link_copied'), snackPosition: SnackPosition.BOTTOM);
  }

  Widget _tileCard(_Tile tile) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: tile.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(10)),
                child: Icon(tile.icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(height: 10),
              Text(tile.label, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(
                tile.value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: tile.highlight ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              if (tile.hint != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(tile.hint!, style: const TextStyle(fontSize: 9.5, color: AppColors.primary)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tile {
  const _Tile(this.icon, this.label, this.value, {this.highlight = false, this.hint, this.onTap});

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;
  final String? hint;
  final VoidCallback? onTap;
}
