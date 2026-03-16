import 'package:audioplayers/audioplayers.dart';

/// Optimized service for mixing multiple ambient sounds simultaneously
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final Map<String, AudioPlayer> _players = {};
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    // Set global context to allow mixing and background playback
    await AudioPlayer.global.setAudioContext(
      const AudioContext(
        android: AudioContextAndroid(
          audioMode: AndroidAudioMode.normal,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: [
            AVAudioSessionOptions.mixWithOthers,
            AVAudioSessionOptions.defaultToSpeaker,
          ],
        ),
      ),
    );
    _initialized = true;
  }

  Future<void> play(String fileName, {double volume = 0.5}) async {
    if (!_players.containsKey(fileName)) {
      final player = AudioPlayer();
      _players[fileName] = player;
      
      await player.setSource(AssetSource('sounds/$fileName'));
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(volume);
      await player.resume();
    } else {
      final player = _players[fileName]!;
      if (player.state != PlayerState.playing) {
        await player.setVolume(volume);
        await player.resume();
      }
    }
  }

  Future<void> pause(String fileName) async {
    if (_players.containsKey(fileName)) {
      await _players[fileName]!.pause();
    }
  }

  Future<void> stop(String fileName) async {
    if (_players.containsKey(fileName)) {
      final player = _players[fileName]!;
      await player.stop();
      await player.dispose();
      _players.remove(fileName);
    }
  }

  Future<void> stopAll() async {
    for (final player in _players.values) {
      await player.stop();
      await player.dispose();
    }
    _players.clear();
  }

  Future<void> setVolume(String fileName, double volume) async {
    if (_players.containsKey(fileName)) {
      await _players[fileName]!.setVolume(volume);
    }
  }

  PlayerState getState(String fileName) {
    if (_players.containsKey(fileName)) {
      return _players[fileName]!.state;
    }
    return PlayerState.stopped;
  }

  Future<void> dispose() async {
    await stopAll();
  }
}

class AmbientSounds {
  static const List<AmbientSound> allSounds = [
    AmbientSound(fileName: 'rain.mp3', displayName: 'Rain', icon: '🌧️'),
    AmbientSound(fileName: 'waves.mp3', displayName: 'Waves', icon: '🌊'),
    AmbientSound(fileName: 'forest.mp3', displayName: 'Forest', icon: '🌲'),
    AmbientSound(fileName: 'wind.mp3', displayName: 'Wind', icon: '🍃'),
    AmbientSound(fileName: 'fire.mp3', displayName: 'Fire', icon: '🔥'),
    AmbientSound(fileName: 'stream.mp3', displayName: 'Stream', icon: '💧'),
    AmbientSound(fileName: 'night.mp3', displayName: 'Night', icon: '🌙'),
    AmbientSound(fileName: 'thunder.mp3', displayName: 'Thunder', icon: '⚡'),
  ];
}

class AmbientSound {
  final String fileName;
  final String displayName;
  final String icon;

  const AmbientSound({
    required this.fileName,
    required this.displayName,
    required this.icon,
  });
}
