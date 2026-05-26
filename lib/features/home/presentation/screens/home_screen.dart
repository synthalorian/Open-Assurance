import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../affirmations/presentation/providers/affirmation_provider.dart';
import '../../../affirmations/presentation/widgets/affirmation_card.dart';
import '../../../affirmations/presentation/widgets/affirmation_search.dart';
import '../providers/streak_provider.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_actions.dart';
import '../widgets/streak_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(streakProvider.notifier).checkIn();
    });
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: AffirmationSearchDelegate(ref),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyAffirmation = ref.watch(dailyAffirmationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search affirmations',
            onPressed: _openSearch,
          ),
          IconButton(
            icon: const Icon(Icons.category_rounded),
            tooltip: 'Browse categories',
            onPressed: () => context.go('/categories'),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: const GreetingHeader()
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.1, end: 0),
          ),
          SliverToBoxAdapter(
            child: const StreakIndicator()
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: dailyAffirmation
                  .when(
                    data: (affirmation) => AffirmationCard(
                      affirmation: affirmation,
                    ),
                    loading: () => const LoadingCard(height: 280),
                    error: (e, _) => ErrorCard(message: e.toString()),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
            ),
          ),

          SliverToBoxAdapter(
            child: const QuickActions()
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}