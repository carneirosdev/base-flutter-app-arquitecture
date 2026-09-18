import 'package:app_template/core/design_system/tokens/colors.dart';
import 'package:app_template/core/design_system/tokens/radius.dart';
import 'package:app_template/core/design_system/tokens/spacing.dart';
import 'package:app_template/core/design_system/tokens/typography.dart';
import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outline, ghost }

enum ButtonSize { sm, md, lg }

/// Botão principal do design system.
///
/// Cobre as quatro variantes de ênfase e trata sozinho os estados de
/// desativado (`onPressed == null`) e de carregamento ([isLoading]).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.lg,
    this.leadingIcon,
    this.trailingIcon,
    this.isFullWidth = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isFullWidth;
  final bool isLoading;

  bool get _isDisabled => onPressed == null || isLoading;

  double get _height => switch (size) {
        ButtonSize.sm => 40.0,
        ButtonSize.md => 48.0,
        ButtonSize.lg => 56.0,
      };

  double get _fontSize => switch (size) {
        ButtonSize.sm => AppTypography.MDTextFontSize,
        ButtonSize.md => AppTypography.LGTextFontSize,
        ButtonSize.lg => AppTypography.XSDisplayFontSize,
      };

  Color get _backgroundColor => switch (variant) {
        ButtonVariant.primary => AppColors.primary,
        ButtonVariant.secondary => AppColors.secondary,
        ButtonVariant.outline || ButtonVariant.ghost => Colors.transparent,
      };

  Color get _foregroundColor => switch (variant) {
        ButtonVariant.primary || ButtonVariant.secondary => AppColors.white,
        ButtonVariant.outline => AppColors.neutralBlack,
        ButtonVariant.ghost => AppColors.primary,
      };

  BorderSide get _border => variant == ButtonVariant.outline
      ? const BorderSide(color: AppColors.border)
      : BorderSide.none;

  @override
  Widget build(BuildContext context) {
    final foregroundColor =
        _isDisabled ? AppColors.neutralGray : _foregroundColor;

    return Opacity(
      opacity: _isDisabled ? 0.6 : 1,
      child: SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: _height,
        child: ElevatedButton(
          onPressed: _isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _backgroundColor,
            foregroundColor: foregroundColor,
            disabledBackgroundColor: _backgroundColor,
            disabledForegroundColor: foregroundColor,
            elevation: 0,
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius30),
              side: _border,
            ),
          ),
          child: _buildContent(foregroundColor),
        ),
      ),
    );
  }

  Widget _buildContent(Color foregroundColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: AppTypography.fontWeightMedium,
              color: foregroundColor,
            ),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          trailingIcon!,
        ],
      ],
    );
  }
}
