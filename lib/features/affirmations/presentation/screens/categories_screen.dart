import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/affirmation.dart';
import '../providers/affirmation_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../widgets/affirmation_card.dart';

class CategoriesScreen extends ConsumerWidget {
  final String? initialCategory;

  const CategoriesScreen({
    super.key,
    this.initialCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(allCategoriesProvider);
    final selectedCategory = initialCategory ?? categories.first;

    return DefaultTabController(
      length: categories.length,
      initialIndex: categories.indexOf(selectedCategory),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.allCategories),
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((category) {
              return Tab(
                text: '${AffirmationCategories.categoryIcons[category]} $category',
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.map((category) {
            return CategoryAffirmationsView(category: category);
          }).toList(),
        ),
      ),
    );
  }
}

class CategoryAffirmationsView extends ConsumerWidget {
  final String category;

  const CategoryAffirmationsView({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final affirmationsAsync = ref.watch(categoryAffirmationsProvider(category));

    return affirmationsAsync.when(
      data: (affirmations) {
        if (affirmations.isEmpty) {
          return const Center(
            child: Text('No affirmations found'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: affirmations.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AffirmationCard(
                affirmation: affirmations[index],
                onFavoriteToggle: (isFavorite) async {
                  final notifier = ref.read(favoritesProvider.notifier);
                  await notifier.toggleFavorite(affirmations[index]);
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const Center(
        child: Text('Failed to load affirmations'),
      ),
    );
  }
}
