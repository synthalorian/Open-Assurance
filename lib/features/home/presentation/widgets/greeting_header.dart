import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../presentation/providers/streak_provider.dart';

class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    final userPrefs = ref.watch(userPreferencesProvider);
    final streak = ref.watch(streakProvider);
    final hour = DateTime.now().hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    final name = userPrefs.name.isNotEmpty ? userPrefs.name : 'dear friend';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$greeting, $name',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (streak.currentStreak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: palette.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: palette.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🔥', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(width: 4),
                      Text(
                        '${streak.currentStreak}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: palette.warning,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Take a moment for yourself today.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}