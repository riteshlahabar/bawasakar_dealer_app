import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// "Prompt? Action" link row shown below an auth card.
class AuthFooter extends StatelessWidget {
  const AuthFooter({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prompt, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        TextButton(
          onPressed: onTap,
          child: Text(action, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
