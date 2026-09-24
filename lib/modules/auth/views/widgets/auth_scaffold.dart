import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import 'auth_header.dart';

/// Shared layout for login, signup, OTP and registration: green header, a
/// white card overlapping it, an optional footer link and the company credit.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.showBack = false,
    this.showBranding = true,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final bool showBack;

  /// Passed straight to [AuthHeader]: login shows the artwork alone.
  final bool showBranding;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            AuthHeader(title: title, subtitle: subtitle, showBack: showBack, showBranding: showBranding),
            Container(
              transform: Matrix4.translationValues(0, -36, 0),
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: .10),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: child,
            ),
            if (footer != null) footer!,
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 4, 24, 28),
              child: Text(
                'Dr. Bawasakar Technology (Agro) Pvt. Ltd.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
