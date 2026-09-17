import 'package:flutter/material.dart';

import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';

/// Three-step progress indicator: Mobile → Verify OTP → Firm Details.
class RegistrationSteps extends StatelessWidget {
  const RegistrationSteps({super.key, required this.current});

  /// 0-based index of the active step.
  final int current;

  /// Translation keys, resolved when drawn.
  static const _labels = ['auth.mobile', 'auth.verify_otp', 'auth.firm_details'];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _labels.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(top: 13),
                color: i <= current ? AppColors.primary : AppColors.border,
              ),
            ),
          _step(i),
        ],
      ],
    );
  }

  Widget _step(int index) {
    final done = index < current;
    final reached = index <= current;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: reached ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: reached ? AppColors.primary : AppColors.border, width: 1.5),
          ),
          child: done
              ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: reached ? Colors.white : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          t(_labels[index]),
          style: TextStyle(
            color: reached ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: index == current ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
