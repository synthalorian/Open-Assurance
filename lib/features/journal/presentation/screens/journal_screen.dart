import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../mood_tracking/presentation/providers/mood_provider.dart';
import '../../../mood_tracking/presentation/widgets/mood_selector.dart';
import '../../../mood_tracking/presentation/widgets/mood_chart.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../affirmations/presentation/widgets/affirmation_card.dart';
import '../../../affirmations/data/models/affirmation.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLoggedToday = ref.watch(hasLoggedTodayProvider);
    final weekEntries = ref.watch(weekMoodEntriesProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Mood Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Reflection',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  hasLoggedToday.when(
                    data: (logged) => logged
                        ? _buildAlreadyLoggedCard(context)
                        : const MoodSelector(),
                    loading: () => const LoadingCard(height: 300),
                    error: (e, _) => ErrorCard(message: e.toString()),
                  ),
                ],
              ),
            ),
          ),

          // Chart Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Emotional Trends',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/journal/mood'),
                        child: const Text('Full History'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  weekEntries.when(
                    data: (entries) => MoodChart(entries: entries),
                    loading: () => const LoadingCard(height: 220),
                    error: (e, _) => ErrorCard(message: e.toString()),
                  ),
                ],
              ),
            ),
          ),

          // Favorites Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved Affirmations',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/journal/favorites'),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          if (favorites.isLoading)
            const SliverToBoxAdapter(child: LoadingCard(height: 150))
          else if (favorites.favoriteIds.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: EmptyState(
                  icon: '💜',
                  title: 'No saved words yet',
                  subtitle: 'Save affirmations that resonate with you to see them here.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final id = favorites.favoriteIdList[index];
                    final text = favorites.getFavoriteText(id) ?? '';
                    // Need to construct a temporary affirmation object for the card
                    final affirmation = Affirmation(
                      id: id,
                      text: text,
                      category: 'Saved',
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AffirmationCard(affirmation: affirmation),
                    );
                  },
                  childCount: favorites.count > 3 ? 3 : favorites.count,
                ),
              ),
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
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: AppColors.success, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reflection complete!',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'You\'ve already checked in today.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
