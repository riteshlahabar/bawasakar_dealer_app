import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../theme/app_colors.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  final String? imageUrl;
  final String? assetPath;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = _resolveImageUrl(imageUrl);
    final asset = assetPath?.trim() ?? '';

    if (url.isNotEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = width ?? constraints.maxWidth;
          final pixelRatio = MediaQuery.devicePixelRatioOf(context);

          // Decode near display size instead of the full uploaded photo.
          final decodeWidth = boxWidth.isFinite && boxWidth > 0
              ? (boxWidth * pixelRatio * 1.5).round().clamp(64, 1200)
              : null;

          return CachedNetworkImage(
            imageUrl: url,
            height: height,
            width: width,
            fit: fit,
            memCacheWidth: decodeWidth,
            // Saved downscaled on the phone, so later opens skip the download.
            // 1200 keeps wide hero banners sharp on large phones.
            maxWidthDiskCache: 1200,
            fadeInDuration: const Duration(milliseconds: 150),
            placeholder: (context, _) => Container(
              height: height,
              width: width,
              color: AppColors.primarySoft,
            ),
            errorWidget: (context, _, __) =>
                asset.isNotEmpty ? _asset(asset) : _placeholder(),
          );
        },
      );
    }

    if (asset.isNotEmpty) {
      return _asset(asset);
    }

    return _placeholder();
  }

  String _resolveImageUrl(String? source) {
    var value = source?.trim() ?? '';

    if (value.isEmpty ||
        value.toLowerCase() == 'null') {
      return '';
    }

    value = value.replaceAll('\\', '/');

    final apiUri =
        Uri.tryParse(ApiConfig.baseUrl);

    if (apiUri == null ||
        !apiUri.hasScheme ||
        apiUri.host.isEmpty) {
      return value;
    }

    final origin =
        '${apiUri.scheme}://${apiUri.authority}';

    final imageUri = Uri.tryParse(value);

    if (imageUri != null &&
        imageUri.hasScheme &&
        imageUri.host.isNotEmpty) {
      final localHost =
          imageUri.host == 'localhost' ||
          imageUri.host == '127.0.0.1' ||
          imageUri.host == '10.0.2.2';

      if (localHost) {
        return _replaceOrigin(
          origin,
          imageUri,
        );
      }

      if (imageUri.host == apiUri.host &&
          apiUri.scheme == 'https' &&
          imageUri.scheme == 'http') {
        return _replaceOrigin(
          origin,
          imageUri,
        );
      }

      return value;
    }

    final path = value.startsWith('/')
        ? value
        : '/$value';

    return '$origin$path';
  }

  String _replaceOrigin(
    String origin,
    Uri uri,
  ) {
    final buffer = StringBuffer(origin);

    if (!uri.path.startsWith('/')) {
      buffer.write('/');
    }

    buffer.write(uri.path);

    if (uri.hasQuery) {
      buffer.write('?${uri.query}');
    }

    return buffer.toString();
  }

  Widget _asset(String path) {
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) =>
          _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.eco,
        color: AppColors.primary,
        size: 32,
      ),
    );
  }
}