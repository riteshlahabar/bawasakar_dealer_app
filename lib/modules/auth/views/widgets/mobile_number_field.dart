import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/localization/t.dart';

/// 10 digit Indian mobile number input with a +91 prefix.
class MobileNumberField extends StatelessWidget {
  const MobileNumberField({super.key, required this.controller, this.onSubmitted});

  final TextEditingController controller;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      maxLength: 10,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSubmitted: (_) => onSubmitted?.call(),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone_iphone_rounded),
        prefixText: '+91  ',
        labelText: t('address.mobile'),
        counterText: '',
      ),
    );
  }
}
