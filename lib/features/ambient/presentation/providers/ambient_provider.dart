import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/audio_service.dart';
import '../../data/soundscapes.dart';

final ambientProvider = StateNotifierProvider<AmbientNotifier, Map<String, double>>((ref) {
  return AmbientNotifier();
});

class AmbientNotifier extends StateNotifier<Map<String, double>> {
  final AudioService _audioService = AudioService();

  AmbientNotifier() : super({}) {
    _init();
  }

  Future<void> _init() async {
    await _audioService.initialize();
  }

  Future<void> toggleSound(String assetPath) async {
    if (state.containsKey(assetPath)) {
      await _audioService.stop(assetPath);
      final newState = Map<String, double>.from(state)..remove(assetPath);
      state = newState;
    } else {
      const initialVolume = 0.5;
      await _audioService.play(assetPath, volume: initialVolume);
      final newState = Map<String, double>.from(state)..[assetPath] = initialVolume;
      state = newState;
    }
  }

  Future<void> updateVolume(String assetPath, double volume) async {
    if (state.containsKey(assetPath)) {
      await _audioService.setVolume(assetPath, volume);
      final newState = Map<String, double>.from(state)..[assetPath] = volume;
      state = newState;
    }
  }

  /// Scale all active sound volumes by a master factor (0.0–1.0)
  Future<void> setMasterVolume(double masterVolume) async {
    for (final entry in state.entries) {
      await _audioService.setVolume(entry.key, entry.value * masterVolume);
    }
  }

  Future<void> stopAll() async {
    await _audioService.stopAll();
    state = {};
  }

  Future<void> loadPreset(SoundPreset preset) async {
    // Stop everything first
    await stopAll();

    // Start each sound in the preset with its configured volume
    final newState = <String, double>{};
    for (final soundId in preset.soundIds) {
      final sound = Soundscapes.getById(soundId);
      if (sound != null) {
        final volume = preset.volumes[soundId] ?? 0.5;
        await _audioService.play(sound.assetPath, volume: volume);
        newState[sound.assetPath] = volume;
      }
    }
    state = newState;
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}