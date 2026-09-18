import 'package:flutter/material.dart';

/// Sombras do design system.
class AppShadows {
  const AppShadows._();

  /// Elevação subtil para cards e tiles.
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 3),
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 2),
  ];

  /// Elevação para diálogos, sheets e menus flutuantes.
  static const List<BoxShadow> dialog = [
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 6),
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 2), blurRadius: 4),
  ];
}
