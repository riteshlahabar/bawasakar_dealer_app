import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../localization/t.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  /// Defaults to the translated "Loading...".
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 12),
          Text(message ?? t('common.loading'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
