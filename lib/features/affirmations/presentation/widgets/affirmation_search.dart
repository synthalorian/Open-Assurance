import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../../affirmations/data/models/affirmation.dart';
import '../../../affirmations/data/repositories/affirmation_repository.dart';
import '../../../affirmations/data/datasources/affirmation_box.dart';
import '../../../affirmations/presentation/widgets/affirmation_card.dart';

// Provider for search
final searchResultsProvider = FutureProvider.family<List<Affirmation>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final box = AffirmationBox();
  final repository = AffirmationRepository(box);
  return repository.searchAffirmations(query);
});

class AffirmationSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  AffirmationSearchDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () {
          query = '';
          ref.read(hapticServiceProvider).light();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () {
        close(context, null);
        ref.read(hapticServiceProvider).light();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_rounded, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'Search for affirmations...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try "confidence", "peace", or "love"',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    final results = ref.watch(searchResultsProvider(query));

    return results.when(
      data: (affirmations) {
        if (affirmations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sentiment_dissatisfied_rounded, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text(
                  'No affirmations found',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different search term',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: affirmations.length,
          itemBuilder: (context, index) {
            final affirmation = affirmations[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AffirmationCard(affirmation: affirmation),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error searching: $e',
          style: const TextStyle(color: AppColors.error),
        ),
      ),
    );
  }
}
