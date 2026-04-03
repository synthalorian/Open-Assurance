import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'models/mood_entry.dart';

/// Repository for managing mood entries
class MoodRepository {
  static final MoodRepository _instance = MoodRepository._internal();
  factory MoodRepository() => _instance;
  MoodRepository._internal();

  static const String _boxName = 'mood_entries';
  Box<MoodEntry>? _box;
  final _uuid = const Uuid();

  /// Initialize the repository
  Future<void> initialize() async {
    if (_box != null && _box!.isOpen) return;
    // Register adapter if not already registered
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MoodEntryAdapter());
    }
    _box = await Hive.openBox<MoodEntry>(_boxName);
  }

  /// Get the box instance
  Box<MoodEntry> get box {
    if (_box == null) {
      throw StateError('MoodRepository not initialized. Call initialize() first.');
    }
    return _box!;
  }

  /// Add a mood entry
  Future<MoodEntry> addEntry({
    required int moodLevel,
    required String moodLabel,
    String? note,
    List<String>? tags,
  }) async {
    final entry = MoodEntry(
      id: _uuid.v4(),
      moodLevel: moodLevel,
      moodLabel: moodLabel,
      timestamp: DateTime.now(),
      note: note,
      tags: tags,
    );
    await box.put(entry.id, entry);
    return entry;
  }

  /// Update a mood entry
  Future<void> updateEntry(MoodEntry entry) async {
    await box.put(entry.id, entry);
  }

  /// Delete a mood entry
  Future<void> deleteEntry(String id) async {
    await box.delete(id);
  }

  /// Get all mood entries
  List<MoodEntry> getAllEntries() {
    return box.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get entries for a specific date range
  List<MoodEntry> getEntriesForDateRange(DateTime start, DateTime end) {
    return box.values
        .where((entry) =>
            entry.timestamp.isAfter(start) && entry.timestamp.isBefore(end))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get today's entries
  List<MoodEntry> getTodayEntries() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getEntriesForDateRange(startOfDay, endOfDay);
  }

  /// Get entries for the last N days
  List<MoodEntry> getEntriesForLastDays(int days) {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day - days);
    return getEntriesForDateRange(startDate, now);
  }

  /// Get average mood for a date range
  double? getAverageMood(DateTime start, DateTime end) {
    final entries = getEntriesForDateRange(start, end);
    if (entries.isEmpty) return null;
    return entries.map((e) => e.moodLevel).reduce((a, b) => a + b) /
        entries.length;
  }

  /// Get average mood for today
  double? getTodayAverageMood() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getAverageMood(startOfDay, endOfDay);
  }

  /// Get average mood for the last N days
  double? getAverageMoodForLastDays(int days) {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day - days);
    return getAverageMood(startDate, now);
  }

  /// Get mood statistics
  MoodStatistics getStatistics(DateTime start, DateTime end) {
    final entries = getEntriesForDateRange(start, end);
    if (entries.isEmpty) {
      return MoodStatistics.empty();
    }

    final values = entries.map((e) => e.moodLevel).toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    final count = entries.length;

    // Count by mood value
    final countByMood = <int, int>{};
    for (var i = 1; i <= 5; i++) {
      countByMood[i] = values.where((v) => v == i).length;
    }

    // Get most common mood
    int mostCommonMood = 3;
    int maxCount = 0;
    countByMood.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonMood = mood;
      }
    });

    return MoodStatistics(
      averageMood: average,
      totalEntries: count,
      countByMood: countByMood,
      mostCommonMood: mostCommonMood,
      entries: entries,
    );
  }

  /// Clear all entries
  Future<void> clearAll() async {
    await box.clear();
  }

  /// Get entry count
  int get count => box.length;
}

/// Statistics for mood data
class MoodStatistics {
  final double averageMood;
  final int totalEntries;
  final Map<int, int> countByMood;
  final int mostCommonMood;
  final List<MoodEntry> entries;

  MoodStatistics({
    required this.averageMood,
    required this.totalEntries,
    required this.countByMood,
    required this.mostCommonMood,
    required this.entries,
  });

  factory MoodStatistics.empty() {
    return MoodStatistics(
      averageMood: 0,
      totalEntries: 0,
      countByMood: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      mostCommonMood: 3,
      entries: [],
    );
  }
}
