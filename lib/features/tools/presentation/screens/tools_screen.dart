import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';

class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildToolCard(
            context,
            icon: '🫁',
            title: 'Breathing Exercises',
            description: 'Simple patterns to calm your mind and body.',
            color: AppColors.accent,
            onTap: () => context.go('/tools/breathing'),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
          const SizedBox(height: 16),
          _buildToolCard(
            context,
            icon: '🎵',
            title: 'Ambient Sounds',
            description: 'Mix sounds of nature to find your center.',
            color: AppColors.primary,
            onTap: () => context.go('/tools/ambient'),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: 0.1, end: 0),
          const SizedBox(height: 16),
          _buildToolCard(
            context,
            icon: '✨',
            title: 'Custom Affirmations',
            description: 'Create and save your own personal words of hope.',
            color: AppColors.secondary,
            onTap: () => context.go('/tools/generator'),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: 0.1, end: 0),
          const SizedBox(height: 16),
          _buildToolCard(
            context,
            icon: '🛡️',
            title: 'Crisis Resources',
            description: 'Immediate help is available whenever you need it.',
            color: AppColors.error,
            onTap: () => context.go('/tools/crisis'),
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideX(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
