import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/auth_form_fields.dart';
import 'auth_submit_button.dart';
import 'password_field.dart';
import '../../../../app/localization/t.dart';

/// Email + password login fields.
class EmailLoginForm extends StatelessWidget {
  const EmailLoginForm({
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
        TextField(
          controller: fields.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            labelText: t('auth.email_address'),
          ),
        ),
        const SizedBox(height: 14),
        PasswordField(controller: fields.passwordController, onSubmitted: onSubmit),
        const SizedBox(height: 24),
        Obx(
          () => AuthSubmitButton(
            label: t('common.login'),
            isLoading: isLoading.value,
            onPressed: onSubmit,
          ),
        ),
      ],
    );
  }
}
