import 'package:flutter/material.dart';

/// Complete color palette for a theme
class ThemePalette {
  final Color background;
  final Color backgroundLight;
  final Color surface;
  final Color surfaceVariant;
  final Color card;
  final Color elevated;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;
  final Color accent;
  final Color accentLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Mood colors
  final Color moodHappy;
  final Color moodNeutral;
  final Color moodSad;
  final Color moodAnxious;
  final Color moodTerrible;

  // Category colors
  final Map<String, Color> categoryColors;

  // Light mode override (if null, inverts automatically)
  final Color? lightBackground;
  final Color? lightSurface;
  final Color? lightCard;

  const ThemePalette({
    required this.background,
    required this.backgroundLight,
    required this.surface,
    required this.surfaceVariant,
    required this.card,
    required this.elevated,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryDark,
    required this.accent,
    required this.accentLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    this.moodHappy = const Color(0xFF4ADE80),
    this.moodNeutral = const Color(0xFFFBBF24),
    this.moodSad = const Color(0xFF60A5FA),
    this.moodAnxious = const Color(0xFFA78BFA),
    this.moodTerrible = const Color(0xFFF87171),
    this.categoryColors = const {
      'Self-Worth': Color(0xFF9D4EDD),
      'Anxiety': Color(0xFF00F5D4),
      'Motivation': Color(0xFFFF006E),
      'Grief': Color(0xFFB185DB),
      'Stress Relief': Color(0xFF60A5FA),
      'Relationships': Color(0xFFFF6B9D),
      'Healing': Color(0xFF4ADE80),
      'Confidence': Color(0xFFFBBF24),
      'Gratitude': Color(0xFF7BFFF0),
      'General': Color(0xFFADB5BD),
    },
    this.lightBackground,
    this.lightSurface,
    this.lightCard,
  });

  /// Gradient definitions
  LinearGradient get primaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, secondary],
      );

  LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [background, backgroundLight],
      );

  LinearGradient get cardGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [card, elevated],
      );

  LinearGradient get sunsetGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          elevated,
          primaryDark,
          primary,
          secondary,
          warning,
        ],
      );

  List<BoxShadow> neonGlow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.5),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];
}

/// Theme configuration — wraps a palette and metadata
class ThemeConfig {
  final String id;
  final String displayName;
  final String description;
  final ThemePalette palette;
  final IconData icon;

  const ThemeConfig({
    required this.id,
    required this.displayName,
    required this.description,
    required this.palette,
    required this.icon,
  });

  /// All available themes
  static const List<ThemeConfig> all = [
    synthwave84,
    midnightCalm,
    roseDawn,
    forestZen,
    classic,
  ];

  static ThemeConfig fromId(String id) {
    return all.firstWhere(
      (t) => t.id == id,
      orElse: () => synthwave84,
    );
  }

  // ─── Synthwave '84 ─────────────────────────────────────────────
  static const synthwave84 = ThemeConfig(
    id: 'synthwave84',
    displayName: "Synthwave '84",
    description: 'Deep purples, neon pinks, and yellow glows — inspired by retro wave.',
    icon: Icons.sunny,
    palette: ThemePalette(
      // Backgrounds — deep space purples
      background: Color(0xFF0D0221),
      backgroundLight: Color(0xFF1A0B2E),
      surface: Color(0xFF10002B),
      surfaceVariant: Color(0xFF1B1035),
      card: Color(0xFF240037),
      elevated: Color(0xFF3C096C),

      // Accents — electric
      primary: Color(0xFF8F00FF),
      primaryLight: Color(0xFFC77DFF),
      primaryDark: Color(0xFF5A189A),
      secondary: Color(0xFFFF00FF),
      secondaryLight: Color(0xFFFF4D9E),
      secondaryDark: Color(0xFFB8004C),
      accent: Color(0xFF00FFFF),
      accentLight: Color(0xFF7BFFF0),

      // Text
      textPrimary: Color(0xFFF8F9FA),
      textSecondary: Color(0xFFADB5BD),
      textTertiary: Color(0xFF6C757D),

      // Status
      success: Color(0xFF00FF41),
      warning: Color(0xFFFFFF66),
      error: Color(0xFFFF0040),
      info: Color(0xFF3B82F6),

      // Category overrides for the synthwave palette
      categoryColors: {
        'Self-Worth': Color(0xFF8F00FF),
        'Anxiety': Color(0xFF00FFFF),
        'Motivation': Color(0xFFFF00FF),
        'Grief': Color(0xFFC77DFF),
        'Stress Relief': Color(0xFF60A5FA),
        'Relationships': Color(0xFFFF6B9D),
        'Healing': Color(0xFF00FF41),
        'Confidence': Color(0xFFFFFF66),
        'Gratitude': Color(0xFF7BFFF0),
        'General': Color(0xFFADB5BD),
      },

      // Light mode overrides
      lightBackground: Color(0xFFF8F9FA),
      lightSurface: Color(0xFFF1F3F5),
      lightCard: Color(0xFFFFFFFF),
    ),
  );

  // ─── Midnight Calm ─────────────────────────────────────────────
  static const midnightCalm = ThemeConfig(
    id: 'midnight',
    displayName: 'Midnight Calm',
    description: 'Deep ocean blues and teals for peaceful reflection.',
    icon: Icons.nights_stay_rounded,
    palette: ThemePalette(
      background: Color(0xFF0A1628),
      backgroundLight: Color(0xFF0F1F35),
      surface: Color(0xFF0D1B2A),
      surfaceVariant: Color(0xFF1B2838),
      card: Color(0xFF1B2D45),
      elevated: Color(0xFF243B53),

      primary: Color(0xFF48A9FE),
      primaryLight: Color(0xFF8EC8FF),
      primaryDark: Color(0xFF2B6CB0),
      secondary: Color(0xFF00B4D8),
      secondaryLight: Color(0xFF48CAE4),
      secondaryDark: Color(0xFF0096C7),
      accent: Color(0xFF64FFDA),
      accentLight: Color(0xFFA7FFEB),

      textPrimary: Color(0xFFE2E8F0),
      textSecondary: Color(0xFF94A3B8),
      textTertiary: Color(0xFF64748B),

      success: Color(0xFF4ADE80),
      warning: Color(0xFFFBBF24),
      error: Color(0xFFF87171),
      info: Color(0xFF60A5FA),

      lightBackground: Color(0xFFF0F9FF),
      lightSurface: Color(0xFFE0F2FE),
      lightCard: Color(0xFFFFFFFF),
    ),
  );

  // ─── Rose Dawn ────────────────────────────────────────────────
  static const roseDawn = ThemeConfig(
    id: 'rosedawn',
    displayName: 'Rose Dawn',
    description: 'Warm rose petals and soft cream — gentle and nurturing.',
    icon: Icons.flare_rounded,
    palette: ThemePalette(
      background: Color(0xFF1A0F14),
      backgroundLight: Color(0xFF2A1A20),
      surface: Color(0xFF1F1419),
      surfaceVariant: Color(0xFF2A1F24),
      card: Color(0xFF2E1F25),
      elevated: Color(0xFF3D2A32),

      primary: Color(0xFFE8436E),
      primaryLight: Color(0xFFFF7BA3),
      primaryDark: Color(0xFFC2254F),
      secondary: Color(0xFFD4A373),
      secondaryLight: Color(0xFFEFC9A3),
      secondaryDark: Color(0xFFB5835A),
      accent: Color(0xFFF8EDE3),
      accentLight: Color(0xFFFFF8F0),

      textPrimary: Color(0xFFF8F0F2),
      textSecondary: Color(0xFFD4C4C8),
      textTertiary: Color(0xFFA8989C),

      success: Color(0xFF7DD181),
      warning: Color(0xFFF4A261),
      error: Color(0xFFE76F51),
      info: Color(0xFF9DB4C0),

      moodHappy: Color(0xFF7DD181),
      moodNeutral: Color(0xFFF4A261),
      moodSad: Color(0xFF9DB4C0),
      moodAnxious: Color(0xFFD4A373),
      moodTerrible: Color(0xFFE76F51),

      lightBackground: Color(0xFFFFF5F7),
      lightSurface: Color(0xFFFFE8EE),
      lightCard: Color(0xFFFFFFFF),
    ),
  );

  // ─── Forest Zen ───────────────────────────────────────────────
  static const forestZen = ThemeConfig(
    id: 'forest',
    displayName: 'Forest Zen',
    description: 'Deep moss greens and earthy browns — grounded and serene.',
    icon: Icons.forest_rounded,
    palette: ThemePalette(
      background: Color(0xFF0D1A12),
      backgroundLight: Color(0xFF16291D),
      surface: Color(0xFF111D15),
      surfaceVariant: Color(0xFF1A2D20),
      card: Color(0xFF1A2E20),
      elevated: Color(0xFF264331),

      primary: Color(0xFF4CAF50),
      primaryLight: Color(0xFF81C784),
      primaryDark: Color(0xFF388E3C),
      secondary: Color(0xFF8D6E63),
      secondaryLight: Color(0xFFA1887F),
      secondaryDark: Color(0xFF5D4037),
      accent: Color(0xFFA5D6A7),
      accentLight: Color(0xFFC8E6C9),

      textPrimary: Color(0xFFE8EDE9),
      textSecondary: Color(0xFFA8B8AC),
      textTertiary: Color(0xFF78907C),

      success: Color(0xFF66BB6A),
      warning: Color(0xFFFFCA28),
      error: Color(0xFFEF5350),
      info: Color(0xFF42A5F5),

      moodHappy: Color(0xFF66BB6A),
      moodNeutral: Color(0xFFFFCA28),
      moodSad: Color(0xFF90A4AE),
      moodAnxious: Color(0xFFA1887F),
      moodTerrible: Color(0xFFEF5350),

      categoryColors: {
        'Self-Worth': Color(0xFF4CAF50),
        'Anxiety': Color(0xFFA5D6A7),
        'Motivation': Color(0xFF8D6E63),
        'Grief': Color(0xFF90A4AE),
        'Stress Relief': Color(0xFF66BB6A),
        'Relationships': Color(0xFF81C784),
        'Healing': Color(0xFFA5D6A7),
        'Confidence': Color(0xFFFFCA28),
        'Gratitude': Color(0xFFC8E6C9),
        'General': Color(0xFFA8B8AC),
      },

      lightBackground: Color(0xFFF1F8E9),
      lightSurface: Color(0xFFE8F5E9),
      lightCard: Color(0xFFFFFFFF),
    ),
  );

  // ─── Classic ──────────────────────────────────────────────────
  static const classic = ThemeConfig(
    id: 'classic',
    displayName: 'Classic',
    description: 'Clean whites and greys — simple, familiar, and accessible.',
    icon: Icons.light_mode_rounded,
    palette: ThemePalette(
      background: Color(0xFF121212),
      backgroundLight: Color(0xFF1E1E1E),
      surface: Color(0xFF1E1E1E),
      surfaceVariant: Color(0xFF2C2C2C),
      card: Color(0xFF2C2C2C),
      elevated: Color(0xFF383838),

      primary: Color(0xFF9C27B0),
      primaryLight: Color(0xFFCE93D8),
      primaryDark: Color(0xFF7B1FA2),
      secondary: Color(0xFFE91E63),
      secondaryLight: Color(0xFFF48FB1),
      secondaryDark: Color(0xFFC2185B),
      accent: Color(0xFF00BCD4),
      accentLight: Color(0xFF4DD0E1),

      textPrimary: Color(0xFFE0E0E0),
      textSecondary: Color(0xFF9E9E9E),
      textTertiary: Color(0xFF757575),

      success: Color(0xFF4CAF50),
      warning: Color(0xFFFF9800),
      error: Color(0xFFF44336),
      info: Color(0xFF2196F3),

      lightBackground: Color(0xFFFAFAFA),
      lightSurface: Color(0xFFF5F5F5),
      lightCard: Color(0xFFFFFFFF),
    ),
  );
}