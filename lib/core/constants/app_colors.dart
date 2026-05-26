import 'package:flutter/material.dart';
import '../theme/theme_config.dart';

/// Synthwave-inspired color palette for Open Assurance
///
/// DEPRECATED: Prefer using the `currentPaletteProvider` from `theme_provider.dart`
/// for dynamic theming. This class now delegates to ThemeConfig.synthwave84 palette
/// for backward compatibility.
class AppColors {
  AppColors._();

  static final ThemePalette _default = ThemeConfig.synthwave84.palette;

  // Primary Colors
  static Color get primary => _default.primary;
  static Color get primaryLight => _default.primaryLight;
  static Color get primaryDark => _default.primaryDark;

  // Secondary Colors (Neon Accents)
  static Color get secondary => _default.secondary;
  static Color get secondaryLight => _default.secondaryLight;
  static Color get secondaryDark => _default.secondaryDark;

  // Accent Colors
  static Color get accent => _default.accent;
  static Color get accentLight => _default.accentLight;
  static Color get accentDark => const Color(0xFF00B8A3);

  // Warm Colors (from the icon)
  static const Color warmOrange = Color(0xFFFF9F1C);
  static const Color warmPink = Color(0xFFFF6B9D);
  static const Color warmPurple = Color(0xFFB185DB);

  // Background Colors
  static Color get background => _default.background;
  static Color get backgroundLight => _default.backgroundLight;
  static Color get backgroundCard => _default.card;
  static Color get backgroundElevated => _default.elevated;

  // Surface Colors
  static Color get surface => _default.surface;
  static Color get surfaceVariant => _default.surfaceVariant;

  // Text Colors
  static Color get textPrimary => _default.textPrimary;
  static Color get textSecondary => _default.textSecondary;
  static Color get textTertiary => _default.textTertiary;

  // Mood Colors
  static Color get moodHappy => _default.moodHappy;
  static Color get moodNeutral => _default.moodNeutral;
  static Color get moodSad => _default.moodSad;
  static Color get moodAnxious => _default.moodAnxious;
  static Color get moodTerrible => _default.moodTerrible;

  // Status Colors
  static Color get success => _default.success;
  static Color get warning => _default.warning;
  static Color get error => _default.error;
  static Color get info => _default.info;

  // Aliases for backward compatibility
  static Color get accentCyan => _default.accent;
  static Color get accentPink => _default.secondary;
  static Color get accentPurple => _default.primary;
  static Color get textMuted => _default.textTertiary;

  // Category colors
  static Map<String, Color> get categoryColors => _default.categoryColors;

  // Gradient Definitions
  static LinearGradient get primaryGradient => _default.primaryGradient;
  static LinearGradient get backgroundGradient => _default.backgroundGradient;
  static LinearGradient get cardGradient => _default.cardGradient;

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF240046),
      Color(0xFF3C096C),
      Color(0xFF7B2CBF),
      Color(0xFFFF006E),
      Color(0xFFFF9F1C),
    ],
  );

  // Glow Effects
  static List<BoxShadow> get neonGlow => [
        BoxShadow(
          color: _default.primary.withValues(alpha: 0.5),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> get accentGlow => [
        BoxShadow(
          color: _default.accent.withValues(alpha: 0.4),
          blurRadius: 15,
          spreadRadius: 1,
        ),
      ];
}