import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import '../../../app/data/services/invoice_download_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Downloads an invoice PDF and hands it to the device's PDF viewer, where the
/// user can print or share it.
///
/// Kept out of the controllers so both the list and the detail screen show the
/// same messages for the same outcome.
class InvoiceFileOpener {
  const InvoiceFileOpener(this._downloads);

  final InvoiceDownloadService _downloads;

  Future<void> openPdf(int invoiceId, {String? invoiceNo}) async {
    try {
      final file = await _downloads.download(invoiceId, invoiceNo: invoiceNo);
      final result = await OpenFilex.open(file.path, type: 'application/pdf');

      if (result.type == ResultType.done) {
        _notify(t('invoice.saved'), '${t('invoice.saved_as')}: ${file.uri.pathSegments.last}');
        return;
      }

      _notify(t('invoice.saved'), t('invoice.no_viewer'));
    } catch (failure) {
      _notify(t('invoice.download_failed'), _message(failure), isError: true);
    }
  }

  String _message(Object failure) {
    final text = failure.toString().replaceFirst('Exception: ', '');
    return text.isEmpty ? t('invoice.download_failed') : text;
  }

  void _notify(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: isError ? AppColors.danger : AppColors.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
