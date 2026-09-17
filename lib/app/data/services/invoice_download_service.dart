import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/api_config.dart';
import '../../core/error/api_exception.dart';
import 'auth_storage.dart';
import '../../localization/t.dart';

/// Downloads the server-rendered invoice PDF and saves it on the device.
///
/// It bypasses [ApiClient] deliberately: that transport decodes every response
/// as JSON, and this endpoint returns binary. The saved file lives in the app's
/// documents directory, which needs no storage permission on either platform.
class InvoiceDownloadService {
  InvoiceDownloadService(this._storage);

  final AuthStorage _storage;

  Future<File> download(int invoiceId, {String? invoiceNo}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.invoicePdf(invoiceId)}');
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: ApiConfig.timeoutSeconds);

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/pdf');

      final token = _storage.token;
      if (token != null && token.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      }

      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        throw ApiException(
          response.statusCode == HttpStatus.notFound
              ? t('invoice.not_found')
              : t('invoice.could_not_download'),
          response.statusCode,
          const <String, dynamic>{},
        );
      }

      final bytes = await consolidateHttpClientResponseBytes(response);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${_fileName(invoiceId, invoiceNo)}');

      return file.writeAsBytes(bytes, flush: true);
    } on SocketException {
      throw ApiException(t('common.no_internet'), 0, const <String, dynamic>{});
    } finally {
      client.close();
    }
  }

  String _fileName(int invoiceId, String? invoiceNo) {
    final raw = (invoiceNo == null || invoiceNo.isEmpty) ? 'invoice-$invoiceId' : invoiceNo;
    final safe = raw.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '-');

    return '$safe.pdf';
  }
}
