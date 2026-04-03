import 'dart:math';
import '../../data/models/affirmation.dart';
import '../../data/datasources/local_affirmations.dart';
import '../datasources/affirmation_box.dart';

/// Repository for managing affirmations
class AffirmationRepository {
  // ignore: unused_field
  final AffirmationBox _affirmationBox;

  AffirmationRepository(this._affirmationBox);

  /// Get all built-in affirmations
  List<Affirmation> getAllBuiltInAffirmations() {
    return LocalAffirmations.allAffirmations;
  }

  /// Get affirmations by category
  List<Affirmation> getAffirmationsByCategory(String category) {
    return LocalAffirmations.getByCategory(category);
  }

  /// Get random affirmation
  Affirmation getRandomAffirmation({String? category}) {
    if (category != null && category != AffirmationCategories.general) {
      final categoryAffirmations = getAffirmationsByCategory(category);
      if (categoryAffirmations.isNotEmpty) {
        return categoryAffirmations[Random().nextInt(categoryAffirmations.length)];
      }
    }
    return LocalAffirmations.getRandom();
  }

  /// Get daily affirmation
  Affirmation getDailyAffirmation() {
    return LocalAffirmations.getDailyAffirmation();
  }

  /// Get all categories
  List<String> getAllCategories() {
    return AffirmationCategories.allCategories;
  }

  /// Get affirmation by ID
  Affirmation? getAffirmationById(String id) {
    try {
      return LocalAffirmations.allAffirmations.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Search affirmations
  List<Affirmation> searchAffirmations(String query) {
    final lowercaseQuery = query.toLowerCase();
    return LocalAffirmations.allAffirmations
        .where((a) =>
            a.text.toLowerCase().contains(lowercaseQuery) ||
            a.category.toLowerCase().contains(lowercaseQuery) ||
            a.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
        .toList();
  }
}
