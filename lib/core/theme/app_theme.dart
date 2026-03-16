import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Theme configuration for Open Assurance
/// Synthwave-inspired with neon accents
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.background : Colors.white;
    final surfaceColor = isDark ? AppColors.surface : Colors.grey[50]!;
    final cardColor = isDark ? AppColors.backgroundCard : Colors.white;
    final textPrimary = isDark ? AppColors.textPrimary : Colors.black87;
    final textSecondary = isDark ? AppColors.textSecondary : Colors.black54;
    final textTertiary = isDark ? AppColors.textTertiary : Colors.black38;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: AppColors.textPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        tertiary: AppColors.accent,
        surface: surfaceColor,
        onSurface: textPrimary,
        error: AppColors.error,
        onError: AppColors.textPrimary,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.comfortaa(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.comfortaa(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.comfortaa(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.comfortaa(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.comfortaa(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.comfortaa(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.comfortaa(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.comfortaa(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.comfortaa(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: GoogleFonts.comfortaa(
          fontSize: 16,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.comfortaa(
          fontSize: 14,
          color: textPrimary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.comfortaa(
          fontSize: 12,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.comfortaa(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelMedium: GoogleFonts.comfortaa(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.comfortaa(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textTertiary,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: cardColor,
        elevation: isDark ? 4 : 2,
        shadowColor: isDark ? AppColors.primary.withOpacity(0.2) : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor.withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.comfortaa(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(
          color: textPrimary,
        ),
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.comfortaa(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primaryLight, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.comfortaa(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: GoogleFonts.comfortaa(
            fontSize: 14,
            fontWeight: FontWeight.w600,
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
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: GoogleFonts.comfortaa(
          fontSize: 14,
          color: textTertiary,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: AppColors.primary,
        labelStyle: GoogleFonts.comfortaa(
          fontSize: 12,
          color: textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: textTertiary.withOpacity(0.2),
        thickness: 1,
        space: 32,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: surfaceColor,
        thumbColor: AppColors.primaryLight,
        overlayColor: AppColors.primary.withOpacity(0.2),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.5);
          }
          return surfaceColor;
        }),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: cardColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.backgroundElevated : Colors.grey[800],
        contentTextStyle: GoogleFonts.comfortaa(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
