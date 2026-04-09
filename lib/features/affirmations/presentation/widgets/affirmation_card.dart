import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/sharing_service.dart';
import '../../../../core/utils/haptic_service.dart';
import '../../data/models/affirmation.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class AffirmationCard extends ConsumerWidget {
  final Affirmation affirmation;
  final Function(bool isFavorite)? onFavoriteToggle;

  const AffirmationCard({
    super.key,
    required this.affirmation,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).isFavorite(affirmation.id);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              affirmation.category,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.primaryLight,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    affirmation.text,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                  ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1, end: 0),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildIconButton(
                        context,
                        icon: isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavorite ? AppColors.secondary : AppColors.textSecondary,
                        onTap: () async {
                          ref.read(hapticServiceProvider).medium();
                          if (onFavoriteToggle != null) {
                            await onFavoriteToggle!(!isFavorite);
                          } else {
                            await ref.read(favoritesProvider.notifier).toggleFavorite(affirmation);
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildIconButton(
                        context,
                        icon: Icons.share_rounded,
                        onTap: () {
                          ref.read(hapticServiceProvider).light();
                          SharingService().shareAffirmation(
                            affirmation.text,
                            author: affirmation.author,
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildIconButton(
                        context,
                        icon: Icons.copy_rounded,
                        onTap: () {
                          ref.read(hapticServiceProvider).light();
                          SharingService().copyToClipboard(affirmation.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to clipboard'),
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
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildIconButton(
    BuildContext context, {
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
}
