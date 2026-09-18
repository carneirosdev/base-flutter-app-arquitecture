import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

class CircleCloseButton extends StatelessWidget {
  const CircleCloseButton({super.key, required this.onTap});

  final VoidCallback onTap;

  static const _background = Color(0xFFFDE7E7);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: _background,
          shape: BoxShape.circle,
          boxShadow: kit.AppShadows.card,
        ),
        child: const Icon(Icons.close, size: 22, color: kit.AppColors.danger),
      ),
    );
  }
}
