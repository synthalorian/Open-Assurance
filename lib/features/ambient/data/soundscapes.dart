/// Available ambient sounds
class Soundscapes {
  static const List<Soundscape> all = [
    Soundscape(
      id: 'rain',
      name: 'Rain',
      description: 'Gentle rainfall',
      icon: '🌧️',
      assetPath: 'assets/sounds/rain.mp3',
    ),
    Soundscape(
      id: 'waves',
      name: 'Ocean Waves',
      description: 'Calm sea waves',
      icon: '🌊',
      assetPath: 'assets/sounds/waves.mp3',
    ),
    Soundscape(
      id: 'forest',
      name: 'Forest',
      description: 'Birds and rustling leaves',
      icon: '🌲',
      assetPath: 'assets/sounds/forest.mp3',
    ),
    Soundscape(
      id: 'wind',
      name: 'Wind',
      description: 'Soft breeze',
      icon: '💨',
      assetPath: 'assets/sounds/wind.mp3',
    ),
    Soundscape(
      id: 'fire',
      name: 'Fireplace',
      description: 'Crackling fire',
      icon: '🔥',
      assetPath: 'assets/sounds/fire.mp3',
    ),
    Soundscape(
      id: 'stream',
      name: 'Stream',
      description: 'Flowing water',
      icon: '💧',
      assetPath: 'assets/sounds/stream.mp3',
    ),
    Soundscape(
      id: 'night',
      name: 'Night',
      description: 'Crickets and owls',
      icon: '🌙',
      assetPath: 'assets/sounds/night.mp3',
    ),
    Soundscape(
      id: 'thunder',
      name: 'Thunderstorm',
      description: 'Distant thunder',
      icon: '⛈️',
      assetPath: 'assets/sounds/thunder.mp3',
    ),
  ];

  static Soundscape? getById(String id) {
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Soundscape model
class Soundscape {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String assetPath;

  const Soundscape({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.assetPath,
  });
}
