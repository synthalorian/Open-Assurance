import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/sharing_service.dart';
import '../../data/models/affirmation.dart';
import '../providers/affirmation_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import 'categories_screen.dart';

class DailyAffirmationScreen extends ConsumerWidget {
  const DailyAffirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAffirmation = ref.watch(dailyAffirmationProvider);
    final randomAffirmation = ref.watch(randomAffirmationProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/app_icon.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.appName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            AppStrings.appTagline,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Daily Affirmation Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: dailyAffirmation.when(
                  data: (affirmation) => _buildAffirmationCard(context, ref, affirmation, isDaily: true),
                  loading: () => _buildLoadingCard(),
                  error: (_, __) => _buildErrorCard(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Categories Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(),
                          ),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Category Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final categories = [
                      (AffirmationCategories.selfWorth, AffirmationCategories.categoryIcons[AffirmationCategories.selfWorth]!),
                      (AffirmationCategories.anxiety, AffirmationCategories.categoryIcons[AffirmationCategories.anxiety]!),
                      (AffirmationCategories.motivation, AffirmationCategories.categoryIcons[AffirmationCategories.motivation]!),
                      (AffirmationCategories.healing, AffirmationCategories.categoryIcons[AffirmationCategories.healing]!),
                      (AffirmationCategories.gratitude, AffirmationCategories.categoryIcons[AffirmationCategories.gratitude]!),
                    ];
                    final (category, icon) = categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ActionChip(
                        avatar: Text(icon),
                        label: Text(category),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoriesScreen(initialCategory: category),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Random Affirmation Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'For You',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () {
                        ref.read(randomAffirmationProvider.notifier).refresh();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      color: AppColors.primaryLight,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Random Affirmation Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: randomAffirmation.when(
                  data: (affirmation) => _buildAffirmationCard(context, ref, affirmation),
                  loading: () => _buildLoadingCard(),
                  error: (_, __) => _buildErrorCard(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildAffirmationCard(
    BuildContext context,
    WidgetRef ref,
    Affirmation affirmation, {
    bool isDaily = false,
  }) {
    final isFavorite = ref.watch(favoritesProvider).isFavorite(affirmation.id);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.neonGlow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AffirmationCategories.categoryIcons[affirmation.category] ??
                                  '✨',
                            ),
                            const SizedBox(width: 6),
                            Text(
                              affirmation.category,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.primaryLight,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (isDaily) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Daily',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.accent,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Affirmation text
                  Text(
                    affirmation.text,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      _buildActionButton(
                        icon: isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavorite ? AppColors.secondary : null,
                        onTap: () async {
                          final notifier = ref.read(favoritesProvider.notifier);
                          final added = await notifier.toggleFavorite(affirmation);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  added
                                      ? AppStrings.savedToFavorites
                                      : AppStrings.removedFromFavorites,
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        icon: Icons.share_rounded,
                        onTap: () {
                          SharingService().shareAffirmation(
                            affirmation.text,
                            author: affirmation.author,
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        icon: Icons.copy_rounded,
                        onTap: () {
                          SharingService().copyToClipboard(affirmation.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(AppStrings.affirmationCopied),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color ?? AppColors.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Text('Something went wrong'),
      ),
    );
  }
}
