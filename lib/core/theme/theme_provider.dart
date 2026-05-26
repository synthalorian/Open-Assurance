import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_config.dart';

/// Full theme state — which theme and which brightness
class ThemeState {
  final ThemeConfig config;
  final ThemeMode mode;

  const ThemeState({
    required this.config,
    this.mode = ThemeMode.dark,
  });

  ThemeState copyWith({ThemeConfig? config, ThemeMode? mode}) {
    return ThemeState(
      config: config ?? this.config,
      mode: mode ?? this.mode,
    );
  }

  /// Get the effective brightness for building theme data
  Brightness get brightness =>
      mode == ThemeMode.light ? Brightness.light : Brightness.dark;
}

final themeStateProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

/// Provides the current ThemePalette for screens that need direct color access
final currentPaletteProvider = Provider<ThemePalette>((ref) {
  return ref.watch(themeStateProvider).config.palette;
});

/// Provides the list of available theme configs
final allThemesProvider = Provider<List<ThemeConfig>>((ref) {
  return ThemeConfig.all;
});

class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeKey = 'theme_id';
  static const String _modeKey = 'theme_mode';

  ThemeNotifier() : super(const ThemeState(config: ThemeConfig.synthwave84)) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeId = prefs.getString(_themeKey) ?? 'synthwave84';
    final modeStr = prefs.getString(_modeKey);

    state = ThemeState(
      config: ThemeConfig.fromId(themeId),
      mode: modeStr != null
          ? ThemeMode.values.firstWhere(
              (m) => m.name == modeStr,
              orElse: () => ThemeMode.dark,
            )
          : ThemeMode.dark,
    );
  }

  Future<void> setTheme(ThemeConfig config) async {
    state = state.copyWith(config: config);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, config.id);
  }

  Future<void> setMode(ThemeMode mode) async {
    state = state.copyWith(mode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, mode.name);
  }

  Future<void> toggleMode() async {
    final newMode =
        state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setMode(newMode);
  }
}