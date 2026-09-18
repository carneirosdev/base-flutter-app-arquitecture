import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

class CircleBackButton extends StatelessWidget {
  const CircleBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: kit.AppColors.textSecondary,
          shape: BoxShape.circle,
          boxShadow: kit.AppShadows.card,
        ),
        child: const Icon(
          Icons.chevron_left,
          size: 24,
          color: kit.AppColors.background,
        ),
      ),
    );
  }
}
