import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/reset_password/reset_password_controller.dart';

class ResetPasswordForm extends StatelessWidget {
  final ResetPasswordController controller;

  const ResetPasswordForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kit.AppPasswordField(
          label: 'Nova palavra-passe',
          hint: 'Escreva a nova palavra-passe',
          controller: controller.newPasswordController,
        ),
        const SizedBox(height: kit.AppSpacing.md),
        kit.AppPasswordField(
          label: 'Confirmar palavra-passe',
          hint: 'Confirme a nova palavra-passe',
          controller: controller.confirmPasswordController,
        ),
      ],
    );
  }
}
