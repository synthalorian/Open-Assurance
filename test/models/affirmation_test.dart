import 'package:flutter_test/flutter_test.dart';
import 'package:open_assurance/features/affirmations/data/models/affirmation.dart';
import 'package:open_assurance/features/affirmations/data/datasources/local_affirmations.dart';

void main() {
  group('Affirmation Model', () {
    test('creates with required fields', () {
      final a = Affirmation(
        id: 'test-1',
        text: 'You are enough',
        category: 'Self-Worth',
      );
      expect(a.id, 'test-1');
      expect(a.text, 'You are enough');
      expect(a.category, 'Self-Worth');
      expect(a.isCustom, false);
    });

    test('custom affirmation flag works', () {
      final a = Affirmation(
        id: 'custom-1',
        text: 'My custom affirmation',
        category: 'General',
        isCustom: true,
      );
      expect(a.isCustom, true);
    });
  });

  group('AffirmationCategories', () {
    test('has 10 categories', () {
      expect(AffirmationCategories.allCategories.length, 10);
    });

    test('includes core categories', () {
      expect(AffirmationCategories.allCategories, contains('Self-Worth'));
      expect(AffirmationCategories.allCategories, contains('Anxiety'));
      expect(AffirmationCategories.allCategories, contains('Motivation'));
      expect(AffirmationCategories.allCategories, contains('Gratitude'));
    });
  });

  group('LocalAffirmations', () {
    test('has 100+ built-in affirmations', () {
      expect(LocalAffirmations.allAffirmations.length, greaterThanOrEqualTo(100));
    });

    test('daily affirmation is deterministic for same date', () {
      final a1 = LocalAffirmations.getDailyAffirmation();
      final a2 = LocalAffirmations.getDailyAffirmation();
      expect(a1.id, a2.id);
    });

    test('random affirmation returns valid affirmation', () {
      final a = LocalAffirmations.getRandom();
      expect(a.text, isNotEmpty);
      expect(a.category, isNotEmpty);
    });

    test('getByCategory returns matching affirmations', () {
      final results = LocalAffirmations.getByCategory('Self-Worth');
      expect(results, isNotEmpty);
      for (final a in results) {
        expect(a.category, 'Self-Worth');
      }
    });
  });
}
