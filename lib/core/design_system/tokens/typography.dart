import 'package:flutter/material.dart';

/// Escala tipográfica do design system.
///
/// A família de letra é aplicada globalmente pelo `AppTheme`, por isso os
/// widgets herdam-na e **não devem** definir `fontFamily` manualmente.
/// [fontFamily] existe apenas para quem bundle a fonte no `pubspec.yaml`.
class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Inter';

  // Texto corrido
  static const double SMTextFontSize = 12.0;
  static const double MDTextFontSize = 14.0;
  static const double LGTextFontSize = 16.0;
  static const double XLTextFontSize = 18.0;

  // Títulos e display
  static const double XSDisplayFontSize = 20.0;
  static const double SMDisplayFontSize = 24.0;
  static const double MDDisplayFontSize = 30.0;
  static const double LGDisplayFontSize = 36.0;
  static const double XLDisplayFontSize = 48.0;

  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightBlack = FontWeight.w900;

  static const double lineHeightSmall = 1.5;
  static const double lineHeightMedium = 1.75;
  static const double lineHeightLarge = 2.0;

  /// Estilo de destaque com peso extra-bold simulado por contorno.
  ///
  /// Usa-o em headlines curtas; [strokeWidth] controla a espessura do
  /// contorno desenhado à volta do glifo.
  static TextStyle blackStyle({
    required Color color,
    required double fontSize,
    double? height,
    double strokeWidth = 0.4,
  }) {
    return TextStyle(
      fontWeight: fontWeightBlack,
      fontSize: fontSize,
      color: color,
      height: height,
      shadows: [
        Shadow(color: color, offset: Offset(strokeWidth, 0)),
        Shadow(color: color, offset: Offset(-strokeWidth, 0)),
        Shadow(color: color, offset: Offset(0, strokeWidth)),
        Shadow(color: color, offset: Offset(0, -strokeWidth)),
      ],
    );
  }
}
