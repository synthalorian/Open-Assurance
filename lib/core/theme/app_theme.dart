import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_config.dart';

/// Theme configuration for Open Assurance
/// Builds complete Material3 ThemeData from a ThemeConfig palette
class AppTheme {
  AppTheme._();

  static ThemeData build(ThemeConfig config, Brightness brightness) {
    final palette = config.palette;
    final isDark = brightness == Brightness.dark;

    final backgroundColor =
        isDark ? palette.background : (palette.lightBackground ?? const Color(0xFFF8F9FA));
    final surfaceColor =
        isDark ? palette.surface : (palette.lightSurface ?? Colors.grey[50]!);
    final cardColor =
        isDark ? palette.card : (palette.lightCard ?? Colors.white);
    final textPrimary = isDark ? palette.textPrimary : const Color(0xFF1A1A2E);
    final textSecondary = isDark ? palette.textSecondary : const Color(0xFF495057);
    final textTertiary = isDark ? palette.textTertiary : const Color(0xFF868E96);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: palette.primary,
        onPrimary: palette.textPrimary,
        secondary: palette.secondary,
        onSecondary: palette.textPrimary,
        tertiary: palette.accent,
        surface: surfaceColor,
        onSurface: textPrimary,
        error: palette.error,
        onError: palette.textPrimary,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.comfortaa(
          fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary,
        ),
        displayMedium: GoogleFonts.comfortaa(
          fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary,
        ),
        displaySmall: GoogleFonts.comfortaa(
          fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary,
        ),
        headlineLarge: GoogleFonts.comfortaa(
          fontSize: 28, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        headlineMedium: GoogleFonts.comfortaa(
          fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        headlineSmall: GoogleFonts.comfortaa(
          fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        titleLarge: GoogleFonts.comfortaa(
          fontSize: 20, fontWeight: FontWeight.w500, color: textPrimary,
        ),
        titleMedium: GoogleFonts.comfortaa(
          fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary,
        ),
        titleSmall: GoogleFonts.comfortaa(
          fontSize: 14, fontWeight: FontWeight.w500, color: textSecondary,
        ),
        bodyLarge: GoogleFonts.comfortaa(
          fontSize: 16, color: textPrimary, height: 1.5,
        ),
        bodyMedium: GoogleFonts.comfortaa(
          fontSize: 14, color: textPrimary, height: 1.5,
        ),
        bodySmall: GoogleFonts.comfortaa(
          fontSize: 12, color: textSecondary,
        ),
        labelLarge: GoogleFonts.comfortaa(
          fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        labelMedium: GoogleFonts.comfortaa(
          fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary,
        ),
        labelSmall: GoogleFonts.comfortaa(
          fontSize: 11, fontWeight: FontWeight.w500, color: textTertiary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: isDark ? 4 : 2,
        shadowColor: isDark
            ? palette.primary.withValues(alpha: 0.2)
            : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor.withValues(alpha: 0.9),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.comfortaa(
          fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: palette.primaryLight,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.secondary,
        foregroundColor: palette.textPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.textPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.comfortaa(
            fontSize: 16, fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primaryLight,
          side: BorderSide(color: palette.primaryLight, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.comfortaa(
            fontSize: 16, fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accent,
          textStyle: GoogleFonts.comfortaa(
            fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.error, width: 2),
        ),
        hintStyle: GoogleFonts.comfortaa(
          fontSize: 14, color: textTertiary,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: palette.primary,
        labelStyle: GoogleFonts.comfortaa(fontSize: 12, color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: textTertiary.withValues(alpha: 0.2),
        thickness: 1,
        space: 32,
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: textPrimary, size: 24),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: palette.primary,
        inactiveTrackColor: surfaceColor,
        thumbColor: palette.primaryLight,
        overlayColor: palette.primary.withValues(alpha: 0.2),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.primaryLight;
          return textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.primary.withValues(alpha: 0.5);
          }
          return surfaceColor;
        }),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? palette.elevated : Colors.grey[800],
        contentTextStyle: GoogleFonts.comfortaa(
          fontSize: 14, color: palette.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
        linearTrackColor: palette.surfaceVariant,
      ),
    );
  }
}