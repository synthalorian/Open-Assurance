import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/favorites_repository.dart';
import '../../../affirmations/data/models/affirmation.dart';

/// State for favorites
class FavoritesState {
  final Set<String> favoriteIds;
  final Map<String, String> favoriteTexts;
  final bool isLoading;

  FavoritesState({
    Set<String>? favoriteIds,
    Map<String, String>? favoriteTexts,
    this.isLoading = false,
  })  : favoriteIds = favoriteIds ?? {},
        favoriteTexts = favoriteTexts ?? {};

  FavoritesState copyWith({
    Set<String>? favoriteIds,
    Map<String, String>? favoriteTexts,
    bool? isLoading,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoriteTexts: favoriteTexts ?? this.favoriteTexts,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool isFavorite(String affirmationId) {
    return favoriteIds.contains(affirmationId);
  }

  /// Alias for compatibility
  FavoritesState? get valueOrNull => isLoading ? null : this;

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
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    state = state.copyWith(isLoading: true);
    try {
      final favorites = _repository.getAllFavorites();
      state = FavoritesState(
        favoriteIds: favorites.keys.toSet(),
        favoriteTexts: favorites,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> toggleFavorite(Affirmation affirmation) async {
    final isFav = state.isFavorite(affirmation.id);

    if (isFav) {
      await _repository.removeFavorite(affirmation.id);
      final newIds = Set<String>.from(state.favoriteIds)..remove(affirmation.id);
      final newTexts = Map<String, String>.from(state.favoriteTexts)
        ..remove(affirmation.id);
      state = state.copyWith(
        favoriteIds: newIds,
        favoriteTexts: newTexts,
      );
      return false;
    } else {
      await _repository.addFavorite(affirmation);
      final newIds = Set<String>.from(state.favoriteIds)..add(affirmation.id);
      final newTexts = Map<String, String>.from(state.favoriteTexts)
        ..[affirmation.id] = affirmation.text;
      state = state.copyWith(
        favoriteIds: newIds,
        favoriteTexts: newTexts,
      );
      return true;
    }
  }

  Future<void> addFavorite(Affirmation affirmation) async {
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
    await _repository.clearAll();
    state = FavoritesState();
  }

  void refresh() {
    _loadFavorites();
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
