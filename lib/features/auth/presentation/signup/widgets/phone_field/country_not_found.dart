import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;

class CountryNotFound extends StatelessWidget {
  const CountryNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.public_off_rounded,
              size: 56,
              color: kit.AppColors.neutralGray,
            ),
            SizedBox(height: 16),
            Text(
              'País não encontrado',
              style: TextStyle(
                fontSize: kit.AppTypography.LGTextFontSize,
                fontWeight: kit.AppTypography.fontWeightBold,
                color: kit.AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Para usar um indicativo personalizado,\npesquisa no formato +244',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: kit.AppTypography.MDTextFontSize,
                color: kit.AppColors.neutralGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
