import 'package:hive_flutter/hive_flutter.dart';
import '../../affirmations/data/models/affirmation.dart';

/// Repository for managing favorite affirmations
class FavoritesRepository {
  static final FavoritesRepository _instance = FavoritesRepository._internal();
  factory FavoritesRepository() => _instance;
  FavoritesRepository._internal();

  static const String _boxName = 'favorites';
  Box<String>? _box;

  /// Initialize the favorites box
  Future<void> initialize() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<String>(_boxName);
  }

  /// Get the box instance
  Box<String> get box {
    if (_box == null) {
      throw StateError('FavoritesRepository not initialized. Call initialize() first.');
    }
    return _box!;
  }

  /// Add a favorite
  Future<void> addFavorite(Affirmation affirmation) async {
    await box.put(affirmation.id, affirmation.text);
  }

  /// Remove a favorite
  Future<void> removeFavorite(String affirmationId) async {
    await box.delete(affirmationId);
  }

  /// Check if an affirmation is favorited
  bool isFavorite(String affirmationId) {
    return box.containsKey(affirmationId);
  }

  /// Get all favorite IDs
  List<String> getFavoriteIds() {
    return box.keys.cast<String>().toList();
  }

  /// Get all favorites with their text
  Map<String, String> getAllFavorites() {
    return box.toMap().cast<String, String>();
  }

  /// Get favorite count
  int get count => box.length;

  /// Clear all favorites
  Future<void> clearAll() async {
    await box.clear();
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(Affirmation affirmation) async {
    final isFav = isFavorite(affirmation.id);
    if (isFav) {
      await removeFavorite(affirmation.id);
      return false;
    } else {
      await addFavorite(affirmation);
      return true;
    }
  }
}
