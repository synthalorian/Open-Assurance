import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/favorites_repository.dart';
import '../../../affirmations/data/models/affirmation.dart';

/// State for favorites
class FavoritesState {
  final Set<String> favoriteIds;
  final Map<String, String> favoriteTexts;
  final bool isLoading;
  final bool isInitialized;

  FavoritesState({
    Set<String>? favoriteIds,
    Map<String, String>? favoriteTexts,
    this.isLoading = false,
    this.isInitialized = false,
  })  : favoriteIds = favoriteIds ?? {},
        favoriteTexts = favoriteTexts ?? {};

  FavoritesState copyWith({
    Set<String>? favoriteIds,
    Map<String, String>? favoriteTexts,
    bool? isLoading,
    bool? isInitialized,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoriteTexts: favoriteTexts ?? this.favoriteTexts,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  bool isFavorite(String affirmationId) {
    return favoriteIds.contains(affirmationId);
  }

  String? getFavoriteText(String affirmationId) {
    return favoriteTexts[affirmationId];
  }

  int get count => favoriteIds.length;

  List<String> get favoriteIdList => favoriteIds.toList();
}

/// Notifier for managing favorites
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super(FavoritesState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.initialize();
      final favorites = _repository.getAllFavorites();
      state = state.copyWith(
        favoriteIds: favorites.keys.toSet(),
        favoriteTexts: favorites,
        isLoading: false,
        isInitialized: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isInitialized: false);
    }
  }

  Future<bool> toggleFavorite(Affirmation affirmation) async {
    if (!state.isInitialized) await _init();
    
    final isFav = state.isFavorite(affirmation.id);

    if (isFav) {
      await removeFavorite(affirmation.id);
      return false;
    } else {
      await addFavorite(affirmation);
      return true;
    }
  }

  Future<void> addFavorite(Affirmation affirmation) async {
    if (!state.isInitialized) await _init();
    if (!state.isFavorite(affirmation.id)) {
      await _repository.addFavorite(affirmation);
      final newIds = Set<String>.from(state.favoriteIds)..add(affirmation.id);
      final newTexts = Map<String, String>.from(state.favoriteTexts)
        ..[affirmation.id] = affirmation.text;
      state = state.copyWith(
        favoriteIds: newIds,
        favoriteTexts: newTexts,
      );
    }
  }

  Future<void> removeFavorite(String affirmationId) async {
    if (!state.isInitialized) await _init();
    if (state.isFavorite(affirmationId)) {
      await _repository.removeFavorite(affirmationId);
      final newIds = Set<String>.from(state.favoriteIds)..remove(affirmationId);
      final newTexts = Map<String, String>.from(state.favoriteTexts)
        ..remove(affirmationId);
      state = state.copyWith(
        favoriteIds: newIds,
        favoriteTexts: newTexts,
      );
    }
  }

  Future<void> clearAll() async {
    if (!state.isInitialized) await _init();
    await _repository.clearAll();
    state = FavoritesState(isInitialized: true);
  }

  void refresh() {
    _init();
  }
}

/// Provider for favorites repository
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

/// Provider for favorites state
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(ref.watch(favoritesRepositoryProvider));
});

/// Provider to check if a specific affirmation is favorited
final isFavoriteProvider = Provider.family<bool, String>((ref, affirmationId) {
  return ref.watch(favoritesProvider).isFavorite(affirmationId);
});

/// Provider for favorite count
final favoriteCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).count;
});
