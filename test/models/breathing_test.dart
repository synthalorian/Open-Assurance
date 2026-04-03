import 'package:flutter_test/flutter_test.dart';
import 'package:open_assurance/features/breathing/data/breathing_patterns.dart';

void main() {
  group('BreathingPatterns', () {
    test('has 6 patterns', () {
      expect(BreathingPatterns.all.length, 6);
    });

    test('all patterns have positive timings', () {
      for (final p in BreathingPatterns.all) {
        expect(p.inhaleSeconds, greaterThan(0));
        expect(p.exhaleSeconds, greaterThan(0));
        expect(p.cycles, greaterThan(0));
        expect(p.name, isNotEmpty);
      }
    });

    test('box breathing is 4-4-4-4', () {
      final box = BreathingPatterns.all.firstWhere((p) => p.id == 'box');
      expect(box.inhaleSeconds, 4);
      expect(box.holdSeconds, 4);
      expect(box.exhaleSeconds, 4);
      expect(box.holdAfterExhaleSeconds, 4);
    });

    test('4-7-8 pattern has correct timings', () {
      final pattern = BreathingPatterns.all.firstWhere((p) => p.id == '478');
      expect(pattern.inhaleSeconds, 4);
      expect(pattern.holdSeconds, 7);
      expect(pattern.exhaleSeconds, 8);
    });
  });
}
