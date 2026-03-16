import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/mood_entry.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_selector.dart';
import '../widgets/mood_chart.dart';

class MoodScreen extends ConsumerWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLoggedToday = ref.watch(hasLoggedTodayProvider);
    final weekEntries = ref.watch(weekMoodEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Journal'),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Mood Selector Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: hasLoggedToday.when(
                data: (logged) => logged 
                    ? _buildAlreadyLoggedCard(context)
                    : const MoodSelector(),
                loading: () => const LoadingCard(height: 300),
                error: (e, _) => ErrorCard(message: e.toString()),
              ),
            ),
          ),

          // Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Week',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  weekEntries.when(
                    data: (entries) => MoodChart(entries: entries),
                    loading: () => const LoadingCard(height: 200),
                    error: (e, _) => ErrorCard(message: e.toString()),
                  ),
                ],
              ),
            ),
          ),

          // History Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
              child: Text(
                'Recent Entries',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          // History List
          weekEntries.when(
            data: (entries) {
              if (entries.isEmpty) {
                return const SliverToBoxAdapter(
                  child: EmptyState(
                    icon: '📜',
                    title: 'No entries yet',
                    subtitle: 'Start logging your mood to see your history.',
                  ),
                );
              }
              final sortedEntries = [...entries]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = sortedEntries[index];
                    return _buildHistoryItem(context, entry);
                  },
                  childCount: sortedEntries.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: LoadingCard(height: 100)),
            error: (e, _) => SliverToBoxAdapter(child: ErrorCard(message: e.toString())),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildAlreadyLoggedCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 48),
          const SizedBox(height: 16),
          Text(
            'Mood Logged for Today',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re doing a great job reflecting on your journey.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, MoodEntry entry) {
    final emoji = MoodLevels.emojis[entry.moodLevel] ?? '😶';
    final label = MoodLevels.labels[entry.moodLevel] ?? 'Unknown';
    final timeStr = DateFormat.jm().format(entry.timestamp);
    final dateStr = DateFormat.MMMd().format(entry.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$dateStr at $timeStr',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                  if (entry.note != null && entry.note!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      entry.note!,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
