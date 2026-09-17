import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';

/// Large centred 6 digit OTP input; calls [onCompleted] once 6 digits are typed.
class OtpCodeField extends StatelessWidget {
  const OtpCodeField({super.key, required this.controller, required this.onCompleted});

  final TextEditingController controller;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    const digitStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: 14);

    return TextField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 6,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: digitStyle,
      onChanged: (value) {
        if (value.length == 6) {
          onCompleted();
        }
      },
      decoration: InputDecoration(
        hintText: '------',
        hintStyle: digitStyle.copyWith(color: AppColors.border),
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
