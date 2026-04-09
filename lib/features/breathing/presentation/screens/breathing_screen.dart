import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../data/breathing_patterns.dart';
import '../providers/breathing_provider.dart';

class BreathingScreen extends ConsumerWidget {
  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(breathingProvider);
    final patterns = ref.watch(breathingPatternsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathe'),
      ),
      body: state.isRunning
          ? _buildActiveExercise(context, ref, state)
          : _buildPatternSelector(context, ref, patterns),
    );
  }

  Widget _buildPatternSelector(
    BuildContext context,
    WidgetRef ref,
    List<BreathingPattern> patterns,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: patterns.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take a Moment',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a breathing pattern to center your mind and body.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }
        
        final pattern = patterns[index - 1];
        return _buildPatternCard(context, ref, pattern);
      },
    );
  }

  Widget _buildPatternCard(
    BuildContext context,
    WidgetRef ref,
    BreathingPattern pattern,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(hapticServiceProvider).selection();
            ref.read(breathingProvider.notifier).selectPattern(pattern);
            ref.read(breathingProvider.notifier).start();
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color(pattern.color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(pattern.icon, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pattern.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pattern.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveExercise(
    BuildContext context,
    WidgetRef ref,
    BreathingState state,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.pattern.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Cycle ${state.currentCycle} of ${state.pattern.cycles}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  ref.read(hapticServiceProvider).medium();
                  ref.read(breathingProvider.notifier).stop();
                },
              ),
            ],
          ),
        ),
        const Spacer(),
        _buildBreathingCircle(context, ref, state),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Text(
                state.instruction,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '${state.secondsRemaining} seconds',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildBreathingCircle(
    BuildContext context,
    WidgetRef ref,
    BreathingState state,
  ) {
    final isExpanding = state.phase == BreathingPhase.inhale;
    final isHolding = state.phase == BreathingPhase.hold || state.phase == BreathingPhase.secondHold;
    final isShrinking = state.phase == BreathingPhase.exhale;
    
    // Pulse animation logic
    double scale = 1.0;
    if (isExpanding) {
      scale = 1.0 + (state.progress * 0.8);
    } else if (isShrinking) {
      scale = 1.8 - (state.progress * 0.8);
    } else if (isHolding && state.phase == BreathingPhase.hold) {
      scale = 1.8;
    } else if (isHolding && state.phase == BreathingPhase.secondHold) {
      scale = 1.0;
    }

    return Center(
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        onEnd: () {
           // Provide haptic feedback at the end of each phase
           if (state.secondsRemaining == 0) {
             ref.read(hapticServiceProvider).light();
           }
        },
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(state.pattern.color).withValues(alpha: 0.2),
            border: Border.all(
              color: Color(state.pattern.color),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(state.pattern.color).withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              state.phase == BreathingPhase.inhale
                  ? Icons.expand_rounded
                  : state.phase == BreathingPhase.exhale
                      ? Icons.compress_rounded
                      : Icons.pause_rounded,
              color: Color(state.pattern.color),
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
