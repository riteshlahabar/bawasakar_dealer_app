import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Pill-shaped − qty + control; shows a trash icon when quantity is 1.
class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final atOne = quantity <= 1;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: .4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(atOne ? Icons.delete_outline_rounded : Icons.remove_rounded, onDecrease, color: atOne ? AppColors.danger : AppColors.primary),
          SizedBox(
            width: 34,
            child: Text('$quantity', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          ),
          _button(Icons.add_rounded, onIncrease, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _button(IconData icon, VoidCallback onTap, {required Color color}) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(width: 36, height: 36, child: Icon(icon, size: 18, color: color)),
    );
  }
}
