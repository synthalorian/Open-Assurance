import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/crisis_resources.dart';

class CrisisResourcesScreen extends StatelessWidget {
  const CrisisResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.crisisResources),
      ),
      body: CustomScrollView(
        slivers: [
          // Header message
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.error.withValues(alpha: 0.2),
                    AppColors.primary.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.error,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.youAreNotAlone,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.helpIsAvailable,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    CrisisResources.supportMessage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Emergency disclaimer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        CrisisResources.emergencyDisclaimer,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Emergency Hotlines
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.emergencyServices,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final resource = CrisisResources.emergencyHotlines[index];
                return _buildResourceCard(context, resource);
              },
              childCount: CrisisResources.emergencyHotlines.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Text/Chat Resources
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.textSupport,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final resource = CrisisResources.textChatResources[index];
                return _buildResourceCard(context, resource);
              },
              childCount: CrisisResources.textChatResources.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // International Resources
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.internationalResources,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final resource = CrisisResources.internationalResources[index];
                return _buildResourceCard(context, resource, isWebsite: true);
              },
              childCount: CrisisResources.internationalResources.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    CrisisResource resource, {
    bool isWebsite = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleTap(resource, isWebsite),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isWebsite
                          ? AppColors.info.withValues(alpha: 0.2)
                          : AppColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isWebsite ? Icons.language : Icons.phone_rounded,
                      color: isWebsite ? AppColors.info : AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resource.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resource.phone,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isWebsite ? AppColors.info : AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resource.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resource.country,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isWebsite ? Icons.open_in_new_rounded : Icons.call_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(CrisisResource resource, bool isWebsite) async {
    if (isWebsite) {
      final url = Uri.parse('https://${resource.phone}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else {
      final url = Uri.parse('tel:${resource.phone}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }
}
