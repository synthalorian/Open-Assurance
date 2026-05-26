import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple boolean provider for onboarding completion status
/// Used by the router to determine initial route
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  static const String _key = 'onboarding_complete';

  OnboardingNotifier() : super(false) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    state = true;
  }
}

/// User preferences from onboarding
class UserPreferences {
  final String name;
  final List<String> preferredCategories;
  final bool remindersEnabled;
  final int reminderHour;
  final int reminderMinute;

  const UserPreferences({
    this.name = '',
    this.preferredCategories = const [],
    this.remindersEnabled = false,
    this.reminderHour = 8,
    this.reminderMinute = 0,
  });

  UserPreferences copyWith({
    String? name,
    List<String>? preferredCategories,
    bool? remindersEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return UserPreferences(
      name: name ?? this.name,
      preferredCategories: preferredCategories ?? this.preferredCategories,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }
}

final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier();
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  static const String _nameKey = 'user_name';
  static const String _categoriesKey = 'preferred_categories';
  static const String _remindersKey = 'onboarding_reminders';

  UserPreferencesNotifier() : super(const UserPreferences()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = UserPreferences(
      name: prefs.getString(_nameKey) ?? '',
      preferredCategories: prefs.getStringList(_categoriesKey) ?? [],
      remindersEnabled: prefs.getBool(_remindersKey) ?? false,
    );
  }

  Future<void> setName(String name) async {
    state = state.copyWith(name: name);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  Future<void> setPreferredCategories(List<String> categories) async {
    state = state.copyWith(preferredCategories: categories);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_categoriesKey, categories);
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    state = state.copyWith(remindersEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_remindersKey, enabled);
  }
}