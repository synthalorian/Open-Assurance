import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/breathing_patterns.dart';

/// State for breathing exercise
class BreathingState {
  final BreathingPattern pattern;
  final BreathingPhase phase;
  final int currentCycle;
  final int secondsRemaining;
  final bool isRunning;
  final bool isPaused;
  final double progress; // 0.0 to 1.0 for current phase

  BreathingState({
    required this.pattern,
    this.phase = BreathingPhase.inhale,
    this.currentCycle = 1,
    this.secondsRemaining = 4,
    this.isRunning = false,
    this.isPaused = false,
    this.progress = 0.0,
  });

  BreathingState copyWith({
    BreathingPattern? pattern,
    BreathingPhase? phase,
    int? currentCycle,
    int? secondsRemaining,
    bool? isRunning,
    bool? isPaused,
    double? progress,
  }) {
    return BreathingState(
      pattern: pattern ?? this.pattern,
      phase: phase ?? this.phase,
      currentCycle: currentCycle ?? this.currentCycle,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      progress: progress ?? this.progress,
    );
  }

  int get totalCycles => pattern.cycles;
  bool get isComplete => currentCycle > totalCycles;
  
  /// Alias for isRunning
  bool get isActive => isRunning;
  
  /// Alias for phase
  BreathingPhase get currentPhase => phase;
  
  /// Elapsed seconds in current phase (calculated)
  int get elapsedSecondsInPhase => phaseDuration - secondsRemaining;

  int get phaseDuration {
    switch (phase) {
      case BreathingPhase.inhale:
        return pattern.inhaleSeconds;
      case BreathingPhase.hold:
        return pattern.holdSeconds;
      case BreathingPhase.exhale:
        return pattern.exhaleSeconds;
      case BreathingPhase.secondHold:
        return pattern.holdAfterExhaleSeconds;
    }
  }

  String get instruction {
    switch (phase) {
      case BreathingPhase.inhale:
        return 'Breathe In';
      case BreathingPhase.hold:
      case BreathingPhase.secondHold:
        return 'Hold';
      case BreathingPhase.exhale:
        return 'Breathe Out';
    }
  }
}

/// Notifier for managing breathing exercise
class BreathingNotifier extends StateNotifier<BreathingState> {
  Timer? _timer;

  BreathingNotifier()
      : super(BreathingState(pattern: BreathingPatterns.all.first));

  void selectPattern(BreathingPattern pattern) {
    _stopTimer();
    state = BreathingState(
      pattern: pattern,
      secondsRemaining: pattern.inhaleSeconds,
    );
  }

  /// Alias for start with pattern selection
  void startExercise(String patternName, {int cycles = 5}) {
    final pattern = BreathingPatterns.all.firstWhere(
      (p) => p.name == patternName,
      orElse: () => BreathingPatterns.all.first,
    );
    selectPattern(pattern);
    start();
  }

  void start() {
    if (state.isRunning && !state.isPaused) return;

    if (state.isPaused) {
      // Resume
      state = state.copyWith(isPaused: false);
    } else {
      // Fresh start
      state = BreathingState(
        pattern: state.pattern,
        secondsRemaining: state.pattern.inhaleSeconds,
        isRunning: true,
      );
    }

    _startTimer();
  }

  void pause() {
    if (!state.isRunning || state.isPaused) return;
    _stopTimer();
    state = state.copyWith(isPaused: true);
  }

  void stop() {
    _stopTimer();
    state = BreathingState(
      pattern: state.pattern,
      secondsRemaining: state.pattern.inhaleSeconds,
    );
  }

  void reset() {
    _stopTimer();
    state = BreathingState(
      pattern: state.pattern,
      secondsRemaining: state.pattern.inhaleSeconds,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _tick() {
    if (!state.isRunning || state.isPaused) return;

    final newSeconds = state.secondsRemaining - 1;
    final progress = 1.0 - (newSeconds / state.phaseDuration);

    if (newSeconds <= 0) {
      // Move to next phase or cycle
      _nextPhase();
    } else {
      state = state.copyWith(
        secondsRemaining: newSeconds,
        progress: progress,
      );
    }
  }

  /// Public alias for _tick
  void tick() => _tick();

  /// Alias for stop
  void stopExercise() => stop();

  /// Get current phase progress (0.0 to 1.0)
  double getPhaseProgress() {
    return state.progress;
  }

  void _nextPhase() {
    BreathingPhase nextPhase;
    int nextDuration;
    int nextCycle = state.currentCycle;

    switch (state.phase) {
      case BreathingPhase.inhale:
        if (state.pattern.holdSeconds > 0) {
          nextPhase = BreathingPhase.hold;
          nextDuration = state.pattern.holdSeconds;
        } else {
          nextPhase = BreathingPhase.exhale;
          nextDuration = state.pattern.exhaleSeconds;
        }
        break;
      case BreathingPhase.hold:
        nextPhase = BreathingPhase.exhale;
        nextDuration = state.pattern.exhaleSeconds;
        break;
      case BreathingPhase.exhale:
        if (state.pattern.holdAfterExhaleSeconds > 0) {
          nextPhase = BreathingPhase.secondHold;
          nextDuration = state.pattern.holdAfterExhaleSeconds;
        } else {
          // Next cycle
          nextCycle++;
          if (nextCycle > state.pattern.cycles) {
            // Exercise complete
            _stopTimer();
            state = state.copyWith(isRunning: false);
            return;
          }
          nextPhase = BreathingPhase.inhale;
          nextDuration = state.pattern.inhaleSeconds;
        }
        break;
      case BreathingPhase.secondHold:
        // Next cycle after second hold
        nextCycle++;
        if (nextCycle > state.pattern.cycles) {
          _stopTimer();
          state = state.copyWith(isRunning: false);
          return;
        }
        nextPhase = BreathingPhase.inhale;
        nextDuration = state.pattern.inhaleSeconds;
        break;
    }

    // Check if we just finished exhale (no hold after) and should go to next cycle
    if (state.phase == BreathingPhase.exhale &&
        state.pattern.holdAfterExhaleSeconds == 0) {
      nextCycle++;
      if (nextCycle > state.pattern.cycles) {
        _stopTimer();
        state = state.copyWith(isRunning: false);
        return;
      }
      nextPhase = BreathingPhase.inhale;
      nextDuration = state.pattern.inhaleSeconds;
    }

    state = state.copyWith(
      phase: nextPhase,
      secondsRemaining: nextDuration,
      currentCycle: nextCycle,
      progress: 0.0,
    );
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

/// Provider for breathing state
final breathingProvider =
    StateNotifierProvider<BreathingNotifier, BreathingState>((ref) {
  return BreathingNotifier();
});

/// Alias for compatibility - use this in UI
final activeBreathingProvider =
    StateNotifierProvider<BreathingNotifier, BreathingState>((ref) {
  return ref.read(breathingProvider.notifier);
});

/// Provider for available patterns
final breathingPatternsProvider = Provider<List<BreathingPattern>>((ref) {
  return BreathingPatterns.all;
});
