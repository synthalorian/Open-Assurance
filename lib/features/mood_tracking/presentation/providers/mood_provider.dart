import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mood_repository.dart';
import '../../data/models/mood_entry.dart';

// Provider for mood repository
final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository();
});

// Provider for all mood entries
final allMoodEntriesProvider = FutureProvider<List<MoodEntry>>((ref) async {
  final repository = ref.watch(moodRepositoryProvider);
  await repository.initialize();
  return repository.getAllEntries();
});

// Provider for today's mood entries
final todayMoodEntriesProvider = FutureProvider<List<MoodEntry>>((ref) async {
  final repository = ref.watch(moodRepositoryProvider);
  await repository.initialize();
  return repository.getTodayEntries();
});

// Provider for this week's mood entries
final weekMoodEntriesProvider = FutureProvider<List<MoodEntry>>((ref) async {
  final repository = ref.watch(moodRepositoryProvider);
  await repository.initialize();
  return repository.getEntriesForLastDays(7);
});

// State notifier for mood operations
final moodNotifierProvider = StateNotifierProvider<MoodNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return MoodNotifier(repository);
});

// Provider to check if mood was logged today
final hasLoggedTodayProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(moodRepositoryProvider);
  await repository.initialize();
  return repository.getTodayEntries().isNotEmpty;
});

// Notifier
class MoodNotifier extends StateNotifier<AsyncValue<void>> {
  final MoodRepository _repository;

  MoodNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> addMoodEntry(int moodLevel, {String? note}) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addEntry(
        moodLevel: moodLevel,
        moodLabel: MoodLevels.getLabel(moodLevel),
        note: note,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMoodEntry(String id) async {
    try {
      await _repository.deleteEntry(id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
