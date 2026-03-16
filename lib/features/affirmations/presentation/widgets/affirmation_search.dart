import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/haptic_service.dart';

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
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded, size: 64, color: AppColors.textTertiary),
            SizedBox(height: 16),
            Text('Search for affirmations...', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    // In a real app, we would have a search provider. 
    // For now, let's assume we filter the existing list if available or show a placeholder.
    return const Center(
      child: Text('Search results coming soon...'),
    );
  }
}
