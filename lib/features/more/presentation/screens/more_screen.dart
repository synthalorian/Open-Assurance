import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../crisis/presentation/screens/crisis_resources_screen.dart';
import '../../../ambient/presentation/screens/ambient_sounds_screen.dart';
import '../../../generator/presentation/screens/generator_screen.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.more),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // App info card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Words of hope when you need them most',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppStrings.version} 1.0.0',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Menu items
          _buildMenuSection(context, 'Features', [
            _MenuItem(
              icon: Icons.auto_awesome,
              title: 'Affirmation Generator',
              subtitle: 'Create custom affirmations',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GeneratorScreen(),
                  ),
                );
              },
            ),
            _MenuItem(
              icon: Icons.music_note_rounded,
              title: AppStrings.ambientSounds,
              subtitle: 'Calm your mind with nature sounds',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AmbientSoundsScreen(),
                  ),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          _buildMenuSection(context, 'Support', [
            _MenuItem(
              icon: Icons.health_and_safety_rounded,
              title: AppStrings.crisisResources,
              subtitle: 'Help is available 24/7',
              color: AppColors.error,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CrisisResourcesScreen(),
                  ),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          _buildMenuSection(context, 'About', [
            _MenuItem(
              icon: Icons.code_rounded,
              title: AppStrings.openSource,
              subtitle: 'Free and open source (GPL v3)',
              onTap: () {
                // Open GitHub
              },
            ),
            _MenuItem(
              icon: Icons.privacy_tip_rounded,
              title: AppStrings.privacyPolicy,
              subtitle: 'Your privacy matters',
              onTap: () {
                // Show privacy policy
              },
            ),
            _MenuItem(
              icon: Icons.favorite_rounded,
              title: 'Credits',
              subtitle: 'Made with love for those who need it',
              onTap: () {
                _showCreditsDialog(context);
              },
            ),
          ]),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildMenuItem(context, item),
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 60,
                      color: AppColors.textTertiary.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (item.color ?? AppColors.primary).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  color: item.color ?? AppColors.primaryLight,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      item.subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Credits'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Open Assurance',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'A free, open-source app for mental wellness',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Text(
              'Built with Flutter and love',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Made for those who need words of hope',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Text(
              'You matter. 💜',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primaryLight,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
  });
}
