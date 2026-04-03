import 'package:hive/hive.dart';

/// Hive box for storing affirmation-related data
class AffirmationBox {
  static const String boxName = 'affirmations';
  late Box<dynamic> _box;

  Future<void> init() async {
    _box = await Hive.openBox(boxName);
  }

  // Daily affirmation tracking
  String? getLastDailyAffirmationId() {
    return _box.get('last_daily_affirmation_id') as String?;
  }

  Future<void> setLastDailyAffirmationId(String id) async {
    await _box.put('last_daily_affirmation_id', id);
    await _box.put('last_daily_affirmation_date', DateTime.now().toIso8601String());
  }

  DateTime? getLastDailyAffirmationDate() {
    final dateStr = _box.get('last_daily_affirmation_date') as String?;
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  // Daily streak tracking
  int getStreakCount() {
    return _box.get('streak_count', defaultValue: 0) as int;
  }

  Future<void> incrementStreak() async {
    final current = getStreakCount();
    await _box.put('streak_count', current + 1);
    await _box.put('last_streak_date', DateTime.now().toIso8601String());
  }

  Future<void> resetStreak() async {
    await _box.put('streak_count', 0);
  }

  // Usage stats
  int getTotalViews() {
    return _box.get('total_views', defaultValue: 0) as int;
  }

  Future<void> incrementViews() async {
    final current = getTotalViews();
    await _box.put('total_views', current + 1);
  }

  Future<void> close() async {
    await _box.close();
  }
}
