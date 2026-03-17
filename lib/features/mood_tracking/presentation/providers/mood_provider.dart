import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mood_repository.dart';
import '../../data/models/mood_entry.dart';

// Provider for mood repository
final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository();
});

// FutureProvider to ensure repository is initialized
final moodRepositoryInitProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(moodRepositoryProvider);
  await repository.initialize();
});

// Provider for all mood entries
final allMoodEntriesProvider = FutureProvider<List<MoodEntry>>((ref) async {
  await ref.watch(moodRepositoryInitProvider.future);
  final repository = ref.watch(moodRepositoryProvider);
  return repository.getAllEntries();
});

// Provider for today's mood entries
final todayMoodEntriesProvider = FutureProvider<List<MoodEntry>>((ref) async {
  await ref.watch(moodRepositoryInitProvider.future);
  final repository = ref.watch(moodRepositoryProvider);
  return repository.getTodayEntries();
});

// Provider for this week's mood entries
final weekMoodEntriesProvider = FutureProvider<List<MoodEntry>>((ref) async {
  await ref.watch(moodRepositoryInitProvider.future);
  final repository = ref.watch(moodRepositoryProvider);
  return repository.getEntriesForLastDays(7);
});

// State notifier for mood operations
final moodNotifierProvider = StateNotifierProvider<MoodNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return MoodNotifier(repository, ref);
});

// Provider to check if mood was logged today
final hasLoggedTodayProvider = FutureProvider<bool>((ref) async {
  await ref.watch(moodRepositoryInitProvider.future);
  final repository = ref.watch(moodRepositoryProvider);
  return repository.getTodayEntries().isNotEmpty;
});

// Notifier
class MoodNotifier extends StateNotifier<AsyncValue<void>> {
  final MoodRepository _repository;
  final Ref _ref;

  MoodNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> addMoodEntry(int moodLevel, {String? note}) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(moodRepositoryInitProvider.future);
      await _repository.addEntry(
        moodLevel: moodLevel,
        moodLabel: MoodLevels.getLabel(moodLevel),
        note: note,
      );
      state = const AsyncValue.data(null);
      // Refresh all dependent providers
      _ref.invalidate(hasLoggedTodayProvider);
      _ref.invalidate(weekMoodEntriesProvider);
      _ref.invalidate(todayMoodEntriesProvider);
      _ref.invalidate(allMoodEntriesProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMoodEntry(String id) async {
    try {
      await _ref.read(moodRepositoryInitProvider.future);
      await _repository.deleteEntry(id);
      // Refresh all dependent providers
      _ref.invalidate(hasLoggedTodayProvider);
      _ref.invalidate(weekMoodEntriesProvider);
      _ref.invalidate(todayMoodEntriesProvider);
      _ref.invalidate(allMoodEntriesProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
