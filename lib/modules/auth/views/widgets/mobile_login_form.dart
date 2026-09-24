import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/auth_form_fields.dart';
import 'auth_submit_button.dart';
import 'mobile_number_field.dart';
import '../../../../app/localization/t.dart';

/// Mobile OTP login — registered dealers sign in with their mobile number only.
class MobileLoginForm extends StatelessWidget {
  const MobileLoginForm({
    super.key,
    required this.fields,
    required this.isLoading,
    required this.onSubmit,
  });

  final AuthFormFields fields;
  final RxBool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MobileNumberField(controller: fields.mobileController, onSubmitted: onSubmit),
        const SizedBox(height: 20),
        Obx(
          () => AuthSubmitButton(
            label: t('auth.send_otp'),
            isLoading: isLoading.value,
            onPressed: onSubmit,
          ),
        ),
      ],
    );
  }
}
