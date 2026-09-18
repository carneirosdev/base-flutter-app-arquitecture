import 'package:app_template/core/design_system/tokens/colors.dart';
import 'package:app_template/core/design_system/tokens/radius.dart';
import 'package:app_template/core/design_system/tokens/spacing.dart';
import 'package:app_template/core/design_system/tokens/typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema global da aplicação, derivado dos tokens do design system.
///
/// É a única fonte de estilo: os widgets herdam daqui e não definem temas
/// inline. Para mudar a identidade visual do projeto, mexe nos tokens.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final background =
        isDark ? AppColors.backgroundDark : AppColors.background;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final border = isDark ? AppColors.borderDark : AppColors.border;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
      ).copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: surface,
        error: AppColors.danger,
        onPrimary: AppColors.white,
        onSurface: textPrimary,
        outline: border,
      ),
      textTheme: _textTheme(textPrimary, textSecondary),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      iconTheme: IconThemeData(color: textPrimary),
      dividerTheme: DividerThemeData(color: border, thickness: 1),
      inputDecorationTheme: _inputDecorationTheme(
        surface: surface,
        border: border,
        hint: textSecondary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.radius30),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radius4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        side: BorderSide(color: border),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          fontSize: AppTypography.SMTextFontSize,
          color: textSecondary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radius30),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontSize: AppTypography.XLDisplayFontSize,
        fontWeight: AppTypography.fontWeightBold,
        color: primary,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: AppTypography.MDDisplayFontSize,
        fontWeight: AppTypography.fontWeightBold,
        color: primary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: AppTypography.XSDisplayFontSize,
        fontWeight: AppTypography.fontWeightMedium,
        color: primary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: AppTypography.LGTextFontSize,
        height: AppTypography.lineHeightSmall,
        color: primary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: AppTypography.MDTextFontSize,
        height: AppTypography.lineHeightSmall,
        color: primary,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: AppTypography.SMTextFontSize,
        color: secondary,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({
    required Color surface,
    required Color border,
    required Color hint,
  }) {
    OutlineInputBorder outline(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radius12),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      hintStyle: TextStyle(
        fontSize: AppTypography.LGTextFontSize,
        color: hint,
      ),
      enabledBorder: outline(border, 1),
      focusedBorder: outline(AppColors.inputFocusColor, 2),
      errorBorder: outline(AppColors.danger, 1),
      focusedErrorBorder: outline(AppColors.danger, 2),
    );
  }
}
