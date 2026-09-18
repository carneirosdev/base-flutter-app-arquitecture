import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

/// Frase de destaque do ecrã de boas-vindas.
///
/// Substitui o texto pelo claim do novo projeto.
class WelcomeTagline extends StatelessWidget {
  const WelcomeTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kit.AppSpacing.xl),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'BEM-VINDO',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: kit.AppTypography.blackStyle(
            color: kit.AppColors.textPrimary,
            fontSize: kit.AppTypography.MDDisplayFontSize,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
