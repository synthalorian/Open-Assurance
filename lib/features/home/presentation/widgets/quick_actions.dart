import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../../affirmations/presentation/providers/affirmation_provider.dart';

class QuickActions extends ConsumerWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAction(
                context,
                icon: Icons.air_rounded,
                label: 'Breathe',
                color: AppColors.accent,
                onTap: () {
                  ref.read(hapticServiceProvider).light();
                  context.go('/tools/breathing');
                },
              ),
              const SizedBox(width: 12),
              _buildAction(
                context,
                icon: Icons.sentiment_satisfied_rounded,
                label: 'Mood',
                color: AppColors.primary,
                onTap: () {
                  ref.read(hapticServiceProvider).light();
                  context.go('/journal/mood');
                },
              ),
              const SizedBox(width: 12),
              _buildAction(
                context,
                icon: Icons.auto_awesome_rounded,
                label: 'Random',
                color: AppColors.secondary,
                onTap: () {
                  ref.read(hapticServiceProvider).light();
                  // Refresh the daily affirmation to get a new random one
                  ref.read(dailyAffirmationProvider.notifier).refreshRandom();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
