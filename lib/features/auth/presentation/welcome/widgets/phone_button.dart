import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

class PhoneButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PhoneButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kit.AppSpacing.lg),
      child: kit.AppButton(label: 'Entrar', onPressed: onPressed),
    );
  }
}
