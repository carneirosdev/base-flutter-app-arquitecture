import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

class DarkCircleCloseButton extends StatelessWidget {
  const DarkCircleCloseButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: kit.AppColors.neutralBlack,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: kit.AppColors.white, size: 18),
      ),
    );
  }
}
