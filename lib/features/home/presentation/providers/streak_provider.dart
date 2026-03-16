import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final streakProvider = StateNotifierProvider<StreakNotifier, StreakState>((ref) {
  return StreakNotifier();
});

class StreakState {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCheckIn;
  final Set<String> checkedDays;

  StreakState({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCheckIn,
    Set<String>? checkedDays,
  }) : checkedDays = checkedDays ?? {};

  StreakState copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCheckIn,
    Set<String>? checkedDays,
  }) {
    return StreakState(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      checkedDays: checkedDays ?? this.checkedDays,
    );
  }

  bool get hasCheckedInToday {
    final today = StreakNotifier.getDateString(DateTime.now());
    return checkedDays.contains(today);
  }
}

class StreakNotifier extends StateNotifier<StreakState> {
  static const String _streakKey = 'streak_data';
  static const String _longestKey = 'longest_streak';
  static const String _lastCheckInKey = 'last_check_in';
  static const String _checkedDaysKey = 'checked_days';

  StreakNotifier() : super(StreakState()) {
    _loadStreak();
  }

  static String getDateString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final streak = prefs.getInt(_streakKey) ?? 0;
    final longest = prefs.getInt(_longestKey) ?? 0;
    final lastCheckInStr = prefs.getString(_lastCheckInKey);
    final checkedDaysList = prefs.getStringList(_checkedDaysKey) ?? [];

    state = StreakState(
      currentStreak: streak,
      longestStreak: longest,
      lastCheckIn: lastCheckInStr != null ? DateTime.parse(lastCheckInStr) : null,
      checkedDays: checkedDaysList.toSet(),
    );
  }

  Future<void> checkIn() async {
    final now = DateTime.now();
    final today = getDateString(now);

    if (state.hasCheckedInToday) return;

    int newStreak = state.currentStreak;
    
    // Check if streak should continue or reset
    if (state.lastCheckIn != null) {
      final lastCheckIn = state.lastCheckIn!;
      final difference = DateTime(now.year, now.month, now.day)
          .difference(DateTime(lastCheckIn.year, lastCheckIn.month, lastCheckIn.day))
          .inDays;
      
      if (difference == 1) {
        newStreak++;
      } else if (difference > 1) {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    final newLongest = newStreak > state.longestStreak ? newStreak : state.longestStreak;
    final newCheckedDays = Set<String>.from(state.checkedDays)..add(today);

    state = state.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongest,
      lastCheckIn: now,
      checkedDays: newCheckedDays,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, newStreak);
    await prefs.setInt(_longestKey, newLongest);
    await prefs.setString(_lastCheckInKey, now.toIso8601String());
    await prefs.setStringList(_checkedDaysKey, newCheckedDays.toList());
  }
}
