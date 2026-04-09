import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../affirmations/data/models/affirmation.dart';
import '../providers/favorites_provider.dart';
import '../../../../core/utils/sharing_service.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final favorites = favoritesState.favoriteIdList.map((id) => 
      Affirmation(
        id: id,
        text: favoritesState.favoriteTexts[id] ?? '',
        category: AffirmationCategories.general,
      )
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myFavorites),
      ),
      body: favoritesState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : favorites.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final affirmation = favorites[index];
                return _buildFavoriteCard(context, ref, affirmation);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 40,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.noFavoritesYet,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.addSomeFavorites,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    WidgetRef ref,
    Affirmation affirmation,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Dismissible(
        key: Key(affirmation.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.delete_rounded,
            color: AppColors.error,
          ),
        ),
        onDismissed: (direction) async {
          await ref.read(favoritesProvider.notifier).removeFavorite(affirmation.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.removedFromFavorites),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AffirmationCategories.categoryIcons[affirmation.category] ?? '✨',
                        ),
                        const SizedBox(width: 4),
                        Text(
                          affirmation.category,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.primaryLight,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.secondary,
                    ),
                    onPressed: () async {
                      await ref.read(favoritesProvider.notifier).removeFavorite(affirmation.id);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                affirmation.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildSmallButton(
                    icon: Icons.share_rounded,
                    onTap: () {
                      SharingService().shareAffirmation(affirmation.text);
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildSmallButton(
                    icon: Icons.copy_rounded,
                    onTap: () {
                      SharingService().copyToClipboard(affirmation.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ),
      ),
    );
  }
}
