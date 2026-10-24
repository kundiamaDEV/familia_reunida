import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // ============================================================
  // CORES OFICIAIS — FAMÍLIA REUNIDA
  // Extraídas da identidade visual da logo
  // ============================================================

  /// Azul-marinho institucional.
  /// Cor principal da marca.
  static const Color primary = Color(0xFF1F396C);

  /// Azul-marinho mais escuro.
  /// Usado para estados pressed, headers escuros e contraste.
  static const Color primaryDark = Color(0xFF162A50);

  /// Azul-marinho mais claro.
  /// Usado em fundos suaves e elementos secundários.
  static const Color primaryLight = Color(0xFF49658F);

  /// Azul ciano da identidade.
  /// Excelente para botões secundários, links e elementos interactivos.
  static const Color secondary = Color(0xFF00ADEF);

  /// Variação clara do ciano.
  static const Color secondaryLight = Color(0xFF66CCF3);

  /// Amarelo oficial da logo.
  /// Deve ser utilizado principalmente para destaques.
  static const Color accent = Color(0xFFFCD450);

  /// Amarelo mais suave para backgrounds e estados seleccionados.
  static const Color accentLight = Color(0xFFFFE89A);

  // ============================================================
  // FUNDOS
  // ============================================================

  /// Fundo geral da aplicação.
  static const Color background = Color(0xFFF7F9FC);

  /// Fundo de cards, diálogos e superfícies.
  static const Color surface = Color(0xFFFFFFFF);

  /// Fundo azul muito suave.
  static const Color primarySurface = Color(0xFFEAF0F8);

  /// Fundo ciano muito suave.
  static const Color secondarySurface = Color(0xFFE6F7FD);

  /// Fundo amarelo muito suave.
  static const Color accentSurface = Color(0xFFFFF8DC);

  // ============================================================
  // TEXTOS
  // ============================================================

  /// Texto principal.
  static const Color textPrimary = Color(0xFF172033);

  /// Texto secundário.
  static const Color textSecondary = Color(0xFF667085);

  /// Texto desactivado.
  static const Color textDisabled = Color(0xFF98A2B3);

  /// Texto sobre fundos escuros/coloridos.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Texto sobre o ciano.
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  /// Texto sobre amarelo.
  static const Color textOnAccent = Color(0xFF172033);

  // ============================================================
  // CORES BASE
  // ============================================================

  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF000000);

  // ============================================================
  // ESTADOS
  // ============================================================

  static const Color success = Color(0xFF2E7D32);

  static const Color successLight = Color(0xFFE8F5E9);

  static const Color error = Color(0xFFBA1A1A);

  static const Color errorLight = Color(0xFFFFEBEE);

  static const Color warning = Color(0xFFE6A700);

  static const Color warningLight = Color(0xFFFFF4CC);

  static const Color info = Color(0xFF00ADEF);

  static const Color infoLight = Color(0xFFE6F7FD);

  // ============================================================
  // BORDAS
  // ============================================================

  static const Color border = Color(0xFFD9E0EA);

  static const Color borderLight = Color(0xFFE9EDF3);

  // ============================================================
  // DIVISORES
  // ============================================================

  static const Color divider = Color(0xFFE4E8EF);
}
