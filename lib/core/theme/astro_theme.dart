import 'package:flutter/material.dart';

/// Defines the custom colors for AstroBuddy, including the deep cosmos palette
/// and the astronomy-critical Monochromatic Red-Light theme.
class AstroColors {
  AstroColors._();

  // === Deep Cosmos Palette (Default Dark Mode) ===
  static const Color cosmosBg = Color(0xFF070B14);
  static const Color cosmosSurface = Color(0xFF0F172A);
  static const Color cosmosSurfaceElevated = Color(0xFF1E293B);
  static const Color cosmosCardBorder = Color(0xFF334155);

  // Stellar Accents
  static const Color starlightCyan = Color(0xFF38BDF8);
  static const Color stellarGold = Color(0xFFFBBF24);
  static const Color nebulaPurple = Color(0xFFA855F7);
  static const Color auroralEmerald = Color(0xFF34D399);
  static const Color superRed = Color(0xFFF87171);

  // Text colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // === Astronomy Night Vision / Red-Light Palette ===
  // Preserves human rhodopsin (dark adaptation) at night observation sites
  static const Color redLightBg = Color(0xFF000000);
  static const Color redLightSurface = Color(0xFF160303);
  static const Color redLightSurfaceElevated = Color(0xFF280707);
  static const Color redLightBorder = Color(0xFF5A1010);
  static const Color redLightPrimary = Color(0xFFFF2A2A);
  static const Color redLightSecondary = Color(0xFFB91C1C);
  static const Color redLightText = Color(0xFFFF6B6B);
  static const Color redLightTextMuted = Color(0xFF8B2525);
}

/// Helper extension or class to access current theme state & colors easily
class AstroTheme {
  AstroTheme._();

  /// Standard Deep Cosmos Theme
  static ThemeData get deepCosmosTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AstroColors.cosmosBg,
      colorScheme: const ColorScheme.dark(
        primary: AstroColors.starlightCyan,
        secondary: AstroColors.nebulaPurple,
        tertiary: AstroColors.stellarGold,
        surface: AstroColors.cosmosSurface,
        onSurface: AstroColors.textPrimary,
        error: AstroColors.superRed,
      ),
      cardTheme: CardThemeData(
        color: AstroColors.cosmosSurface.withValues(alpha: 0.85),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AstroColors.cosmosCardBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AstroColors.cosmosBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AstroColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: AstroColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AstroColors.cosmosSurface,
        selectedItemColor: AstroColors.starlightCyan,
        unselectedItemColor: AstroColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  /// Astronomy Red-Light Theme for Field Observation
  static ThemeData get redLightObservationTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AstroColors.redLightBg,
      colorScheme: const ColorScheme.dark(
        primary: AstroColors.redLightPrimary,
        secondary: AstroColors.redLightSecondary,
        tertiary: AstroColors.redLightPrimary,
        surface: AstroColors.redLightSurface,
        onSurface: AstroColors.redLightText,
        error: AstroColors.redLightPrimary,
      ),
      cardTheme: CardThemeData(
        color: AstroColors.redLightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AstroColors.redLightBorder, width: 1.2),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AstroColors.redLightBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AstroColors.redLightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: AstroColors.redLightPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AstroColors.redLightBg,
        selectedItemColor: AstroColors.redLightPrimary,
        unselectedItemColor: AstroColors.redLightTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
