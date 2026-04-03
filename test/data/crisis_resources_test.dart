import 'package:flutter_test/flutter_test.dart';
import 'package:open_assurance/core/constants/crisis_resources.dart';

void main() {
  group('CrisisResources', () {
    test('has emergency hotlines', () {
      expect(CrisisResources.emergencyHotlines, isNotEmpty);
    });

    test('hotlines have names and phone numbers', () {
      for (final h in CrisisResources.emergencyHotlines) {
        expect(h.name, isNotEmpty);
        expect(h.phone, isNotEmpty);
      }
    });

    test('includes US 988 lifeline', () {
      final us = CrisisResources.emergencyHotlines
          .where((h) => h.phone.contains('988'));
      expect(us, isNotEmpty);
    });

    test('has disclaimer text', () {
      expect(CrisisResources.emergencyDisclaimer, isNotEmpty);
    });
  });
}
