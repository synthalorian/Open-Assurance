import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/notification_service.dart';

final reminderProvider = StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  return ReminderNotifier();
});

class ReminderState {
  final bool isEnabled;
  final int hour;
  final int minute;

  ReminderState({
    this.isEnabled = false,
    this.hour = 8,
    this.minute = 0,
  });

  ReminderState copyWith({
    bool? isEnabled,
    int? hour,
    int? minute,
  }) {
    return ReminderState(
      isEnabled: isEnabled ?? this.isEnabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}

class ReminderNotifier extends StateNotifier<ReminderState> {
  static const String _enabledKey = 'reminder_enabled';
  static const String _hourKey = 'reminder_hour';
  static const String _minuteKey = 'reminder_minute';
  static const int _notificationId = 100;

  ReminderNotifier() : super(ReminderState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = ReminderState(
      isEnabled: prefs.getBool(_enabledKey) ?? false,
      hour: prefs.getInt(_hourKey) ?? 8,
      minute: prefs.getInt(_minuteKey) ?? 0,
    );
  }

  Future<void> setEnabled(bool enabled) async {
    if (enabled) {
      final success = await NotificationService().requestPermissions();
      if (!success) return;
      await _schedule();
    } else {
      await NotificationService().cancelNotification(_notificationId);
    }

    state = state.copyWith(isEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
  }

  Future<void> setTime(int hour, int minute) async {
    state = state.copyWith(hour: hour, minute: minute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);

    if (state.isEnabled) {
      await _schedule();
    }
  }

  Future<void> _schedule() async {
    await NotificationService().scheduleDailyNotification(
      id: _notificationId,
      title: 'Open Assurance',
      body: 'Take a moment for your daily affirmation. 💜',
      hour: state.hour,
      minute: state.minute,
    );
  }
}
