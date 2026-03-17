import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/affirmation_box.dart';
import '../../data/repositories/affirmation_repository.dart';
import '../../data/models/affirmation.dart';

// Providers
final affirmationBoxProvider = Provider<AffirmationBox>((ref) {
  return AffirmationBox();
});

final affirmationRepositoryProvider = Provider<AffirmationRepository>((ref) {
  final box = ref.watch(affirmationBoxProvider);
  return AffirmationRepository(box);
});

// State for daily affirmation
final dailyAffirmationProvider = StateNotifierProvider<DailyAffirmationNotifier, AsyncValue<Affirmation>>((ref) {
  final repository = ref.watch(affirmationRepositoryProvider);
  return DailyAffirmationNotifier(repository);
});

// State for random affirmation
final randomAffirmationProvider = StateNotifierProvider<RandomAffirmationNotifier, AsyncValue<Affirmation>>((ref) {
  final repository = ref.watch(affirmationRepositoryProvider);
  return RandomAffirmationNotifier(repository);
});

// State for category affirmations
final categoryAffirmationsProvider = FutureProvider.family<List<Affirmation>, String>((ref, category) async {
  final repository = ref.watch(affirmationRepositoryProvider);
  return repository.getAffirmationsByCategory(category);
});

// State for all categories
final allCategoriesProvider = Provider<List<String>>((ref) {
  final repository = ref.watch(affirmationRepositoryProvider);
  return repository.getAllCategories();
});

// Notifiers
class DailyAffirmationNotifier extends StateNotifier<AsyncValue<Affirmation>> {
  final AffirmationRepository _repository;

  DailyAffirmationNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDailyAffirmation();
  }

  void loadDailyAffirmation() {
    try {
      final affirmation = _repository.getDailyAffirmation();
      state = AsyncValue.data(affirmation);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void refreshRandom() {
    try {
      state = const AsyncValue.loading();
      final affirmation = _repository.getRandomAffirmation();
      state = AsyncValue.data(affirmation);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

class RandomAffirmationNotifier extends StateNotifier<AsyncValue<Affirmation>> {
  final AffirmationRepository _repository;

  RandomAffirmationNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadRandomAffirmation();
  }

  void loadRandomAffirmation({String? category}) {
    try {
      final affirmation = _repository.getRandomAffirmation(category: category);
      state = AsyncValue.data(affirmation);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void refresh() {
    state = const AsyncValue.loading();
    loadRandomAffirmation();
  }
}
