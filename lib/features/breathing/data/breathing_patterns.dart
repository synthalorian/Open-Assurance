/// Breathing phases
enum BreathingPhase {
  inhale,
  hold,
  exhale,
  secondHold,
}

/// Extension for BreathingPhase
extension BreathingPhaseExtension on BreathingPhase {
  String get label {
    switch (this) {
      case BreathingPhase.inhale:
        return 'Inhale';
      case BreathingPhase.hold:
      case BreathingPhase.secondHold:
        return 'Hold';
      case BreathingPhase.exhale:
        return 'Exhale';
    }
  }
  
  String get instruction {
    switch (this) {
      case BreathingPhase.inhale:
        return 'Breathe in slowly';
      case BreathingPhase.hold:
      case BreathingPhase.secondHold:
        return 'Hold your breath';
      case BreathingPhase.exhale:
        return 'Breathe out slowly';
    }
  }
}

/// Available breathing patterns
class BreathingPatterns {
  static const List<BreathingPattern> all = [
    BreathingPattern(
      id: 'box',
      name: 'Box Breathing',
      description: 'Equal breath for focus and calm',
      inhaleSeconds: 4,
      holdSeconds: 4,
      exhaleSeconds: 4,
      holdAfterExhaleSeconds: 4,
      cycles: 4,
      icon: '⬜',
      color: 0xFF06B6D4,
    ),
    BreathingPattern(
      id: '478',
      name: '4-7-8 Relaxation',
      description: 'Deep relaxation for sleep',
      inhaleSeconds: 4,
      holdSeconds: 7,
      exhaleSeconds: 8,
      cycles: 4,
      icon: '🌙',
      color: 0xFFA855F7,
    ),
    BreathingPattern(
      id: 'calm',
      name: 'Calm Breathing',
      description: 'Gentle rhythm for stress relief',
      inhaleSeconds: 4,
      holdSeconds: 2,
      exhaleSeconds: 6,
      cycles: 5,
      icon: '🌊',
      color: 0xFF10B981,
    ),
    BreathingPattern(
      id: 'energizing',
      name: 'Energizing',
      description: 'Quick breaths for energy',
      inhaleSeconds: 2,
      holdSeconds: 0,
      exhaleSeconds: 2,
      cycles: 10,
      icon: '⚡',
      color: 0xFFF59E0B,
    ),
    BreathingPattern(
      id: 'relaxing',
      name: 'Deep Relaxation',
      description: 'Slow breaths for deep calm',
      inhaleSeconds: 6,
      holdSeconds: 4,
      exhaleSeconds: 8,
      cycles: 3,
      icon: '🌸',
      color: 0xFFEC4899,
    ),
    BreathingPattern(
      id: 'balanced',
      name: 'Balanced Breath',
      description: 'Equal inhale and exhale',
      inhaleSeconds: 5,
      holdSeconds: 0,
      exhaleSeconds: 5,
      cycles: 6,
      icon: '☯️',
      color: 0xFF6366F1,
    ),
  ];

  static BreathingPattern? getById(String id) {
    try {
      return all.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Breathing pattern model
class BreathingPattern {
  final String id;
  final String name;
  final String description;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int holdAfterExhaleSeconds;
  final int cycles;
  final String icon;
  final int color;

  const BreathingPattern({
    required this.id,
    required this.name,
    required this.description,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    this.holdAfterExhaleSeconds = 0,
    required this.cycles,
    required this.icon,
    required this.color,
  });

  int get totalSecondsPerCycle =>
      inhaleSeconds + holdSeconds + exhaleSeconds + holdAfterExhaleSeconds;

  int get totalSeconds => totalSecondsPerCycle * cycles;

  /// Alias for holdAfterExhaleSeconds for compatibility
  int? get secondHoldSeconds =>
      holdAfterExhaleSeconds > 0 ? holdAfterExhaleSeconds : null;
      
  /// Category for the pattern (derived from name)
  String get category => 'Breathing';
}
