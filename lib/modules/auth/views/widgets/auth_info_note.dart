import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Small icon + hint line used under auth form fields.
class AuthInfoNote extends StatelessWidget {
  const AuthInfoNote({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
          ),
        ),
      ],
    );
  }
}
