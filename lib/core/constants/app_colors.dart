import 'package:flutter/material.dart';

/// Synthwave-inspired color palette for Open Assurance
/// Deep purples, neon pinks, and cyan accents
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF9D4EDD);
  static const Color primaryLight = Color(0xFFC77DFF);
  static const Color primaryDark = Color(0xFF5A189A);
  
  // Secondary Colors (Neon Accents)
  static const Color secondary = Color(0xFFFF006E);
  static const Color secondaryLight = Color(0xFFFF4D9E);
  static const Color secondaryDark = Color(0xFFB8004C);
  
  // Accent Colors
  static const Color accent = Color(0xFF00F5D4);
  static const Color accentLight = Color(0xFF7BFFF0);
  static const Color accentDark = Color(0xFF00B8A3);
  
  // Warm Colors (from the icon)
  static const Color warmOrange = Color(0xFFFF9F1C);
  static const Color warmPink = Color(0xFFFF6B9D);
  static const Color warmPurple = Color(0xFFB185DB);
  
  // Background Colors
  static const Color background = Color(0xFF0D0221);
  static const Color backgroundLight = Color(0xFF1A0B2E);
  static const Color backgroundCard = Color(0xFF240046);
  static const Color backgroundElevated = Color(0xFF3C096C);
  
  // Surface Colors
  static const Color surface = Color(0xFF10002B);
  static const Color surfaceVariant = Color(0xFF1B1035);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF8F9FA);
  static const Color textSecondary = Color(0xFFADB5BD);
  static const Color textTertiary = Color(0xFF6C757D);
  
  // Mood Colors
  static const Color moodHappy = Color(0xFF4ADE80);
  static const Color moodNeutral = Color(0xFFFBBF24);
  static const Color moodSad = Color(0xFF60A5FA);
  static const Color moodAnxious = Color(0xFFA78BFA);
  static const Color moodTerrible = Color(0xFFF87171);
  
  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Aliases for backward compatibility
  static const Color accentCyan = Color(0xFF00F5D4);
  static const Color accentPink = Color(0xFFFF006E);
  static const Color accentPurple = Color(0xFF9D4EDD);
  static const Color surfaceLight = Color(0xFF1B1035);
  static const Color textMuted = Color(0xFF6C757D);
  
  // Category colors
  static const Map<String, Color> categoryColors = {
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
  };
  
  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, backgroundLight],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundCard, backgroundElevated],
  );
  
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
      color: primary.withValues(alpha: 0.5),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
  
  static List<BoxShadow> get accentGlow => [
    BoxShadow(
      color: accent.withValues(alpha: 0.4),
      blurRadius: 15,
      spreadRadius: 1,
    ),
  ];
}
