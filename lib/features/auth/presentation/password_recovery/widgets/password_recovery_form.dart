import 'package:flutter/material.dart';
import 'package:app_template/features/auth/presentation/password_recovery/password_recovery_controller.dart';
import 'package:app_template/features/auth/presentation/signup/widgets/phone_field.dart';

class PasswordRecoveryForm extends StatelessWidget {
  final PasswordRecoveryController controller;

  const PasswordRecoveryForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PhoneField(
      controller: controller.phoneTextController,
      onCountryCodeChanged: (code) => controller.selectedDialCode = code,
    );
  }
}