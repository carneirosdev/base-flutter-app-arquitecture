import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/signup/widgets/country_codes.dart';

class CountryButton extends StatelessWidget {
  const CountryButton({super.key, required this.country, required this.onTap});

  final CountryCode country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              country.flag,
              style: const TextStyle(fontSize: kit.AppTypography.XLTextFontSize),
            ),
            const SizedBox(width: 6),
            Text(
              country.dialCode,
              style: const TextStyle(
                fontSize: kit.AppTypography.MDTextFontSize,
                fontWeight: kit.AppTypography.fontWeightMedium,
                color: kit.AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: kit.AppColors.neutralGray,
            ),
          ],
        ),
      ),
    );
  }
}
