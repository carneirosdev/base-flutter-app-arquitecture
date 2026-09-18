import 'package:flutter/material.dart';
import 'package:app_template/core/design_system/design_system.dart' as kit;
import 'package:app_template/features/auth/presentation/signup/widgets/country_codes.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({
    super.key,
    required this.country,
    required this.onTap,
    this.isCustom = false,
  });

  final CountryCode country;
  final VoidCallback onTap;
  final bool isCustom;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        country.flag,
        style: const TextStyle(fontSize: kit.AppTypography.XLTextFontSize),
      ),
      title: Text(
        country.name,
        style: TextStyle(
          fontSize: kit.AppTypography.LGTextFontSize,
          fontWeight: isCustom
              ? kit.AppTypography.fontWeightBold
              : kit.AppTypography.fontWeightMedium,
          color: kit.AppColors.textPrimary,
        ),
      ),
      trailing: Text(
        country.dialCode,
        style: TextStyle(
          fontSize: kit.AppTypography.MDTextFontSize,
          fontWeight: kit.AppTypography.fontWeightMedium,
          color: isCustom
              ? kit.AppColors.inputFocusColor
              : kit.AppColors.neutralGray,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kit.AppRadius.radius12),
      ),
    );
  }
}
