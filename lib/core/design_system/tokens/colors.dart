import 'package:flutter/material.dart';

/// Paleta do design system.
///
/// Os valores aqui são um ponto de partida neutro — substitui-os pelas cores
/// da marca do projeto. Nunca declares cores fora deste ficheiro.
class AppColors {
  const AppColors._();

  // Marca
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF0EA5E9);

  // Superfícies
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);

  // Neutros
  static const Color neutralBlack = Color(0xFF1C1D21);
  static const Color neutralGray = Color(0xFF8C98A5);
  static const Color border = Color(0xFFE2E8F0);

  // Texto
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  /// Texto escrito na cor da marca (links, ações inline).
  static const Color textOnPrimary = primary;

  // Estado
  static const Color success = Color(0xFF10B981);
  static const Color danger = Color(0xFFEF4444);
  static const Color alert = Color(0xFFF59E0B);

  /// Realce de campos de formulário com foco.
  static const Color inputFocusColor = Color(0xFF269AD4);

  // Modo escuro
  static const Color backgroundDark = Color(0xFF111318);
  static const Color surfaceDark = Color(0xFF1C1D21);
  static const Color textPrimaryDark = Color(0xFFF3F4F6);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color borderDark = Color(0xFF2E3138);
}
