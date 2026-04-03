import 'package:flutter_test/flutter_test.dart';
import 'package:open_assurance/features/ambient/data/soundscapes.dart';

void main() {
  group('Soundscapes', () {
    test('has 8 sounds', () {
      expect(Soundscapes.all.length, 8);
    });

    test('all sounds have valid asset paths', () {
      for (final s in Soundscapes.all) {
        expect(s.assetPath, startsWith('assets/sounds/'));
        expect(s.name, isNotEmpty);
        expect(s.icon, isNotEmpty);
      }
    });

    test('getById returns correct sound', () {
      final rain = Soundscapes.getById('rain');
      expect(rain, isNotNull);
      expect(rain!.name, 'Rain');
    });

    test('getById returns null for unknown id', () {
      final unknown = Soundscapes.getById('nonexistent');
      expect(unknown, isNull);
    });
  });

  group('SoundPresets', () {
    test('has 4 presets', () {
      expect(Soundscapes.presets.length, 4);
    });

    test('all presets reference valid sound ids', () {
      final validIds = Soundscapes.all.map((s) => s.id).toSet();
      for (final preset in Soundscapes.presets) {
        for (final soundId in preset.soundIds) {
          expect(validIds.contains(soundId), true,
              reason: '${preset.name} references unknown sound: $soundId');
        }
      }
    });

    test('all presets have volumes for their sounds', () {
      for (final preset in Soundscapes.presets) {
        for (final soundId in preset.soundIds) {
          expect(preset.volumes.containsKey(soundId), true,
              reason: '${preset.name} missing volume for: $soundId');
        }
      }
    });

    test('sleep preset uses rain and night', () {
      final sleep = Soundscapes.presets.firstWhere((p) => p.id == 'sleep');
      expect(sleep.soundIds, contains('rain'));
      expect(sleep.soundIds, contains('night'));
    });
  });
}
