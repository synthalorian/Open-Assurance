import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../settings/presentation/providers/reminder_provider.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _nameController = TextEditingController();
  final Set<String> _selectedCategories = {};
  bool _remindersEnabled = false;

  static const List<Map<String, String>> _categories = [
    {'key': 'Self-Worth', 'icon': '💎', 'label': 'Self-Worth'},
    {'key': 'Anxiety', 'icon': '🫂', 'label': 'Anxiety'},
    {'key': 'Motivation', 'icon': '🚀', 'label': 'Motivation'},
    {'key': 'Grief', 'icon': '💔', 'label': 'Grief'},
    {'key': 'Stress Relief', 'icon': '🧘', 'label': 'Stress Relief'},
    {'key': 'Relationships', 'icon': '💞', 'label': 'Relationships'},
    {'key': 'Healing', 'icon': '🌱', 'label': 'Healing'},
    {'key': 'Confidence', 'icon': '💪', 'label': 'Confidence'},
    {'key': 'Gratitude', 'icon': '🙏', 'label': 'Gratitude'},
    {'key': 'General', 'icon': '💜', 'label': 'General'},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    // Save preferences
    if (_nameController.text.isNotEmpty) {
      await ref.read(userPreferencesProvider.notifier).setName(_nameController.text);
    }
    if (_selectedCategories.isNotEmpty) {
      await ref.read(userPreferencesProvider.notifier).setPreferredCategories(
        _selectedCategories.toList(),
      );
    }
    if (_remindersEnabled) {
      await ref.read(reminderProvider.notifier).setEnabled(true);
    }

    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (context.mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top progress indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: List.generate(3, (index) {
                  final isActive = index <= _currentPage;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: 300.ms,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isActive ? palette.primaryLight : palette.textTertiary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text('Skip'),
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildWelcomePage(context),
                  _buildCategoriesPage(context),
                  _buildReminderPage(context),
                ],
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: 300.ms,
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      child: Text(_currentPage == 2 ? 'Get Started' : 'Continue'),
                    ),
                  ),
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Back'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💜', style: TextStyle(fontSize: 80))
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 40),
          Text(
            'Welcome to\nOpen Assurance',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 12),
          Text(
            'Words of hope when you need them most.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 40),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'What should we call you? (optional)',
              prefixIcon: const Icon(Icons.person_rounded),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            ),
            textCapitalization: TextCapitalization.words,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Text(
            'Your name is only stored on this device.',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildCategoriesPage(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📝', style: TextStyle(fontSize: 60))
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            'What do you need help with?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            'Select all that apply',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategories.contains(cat['key']);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedCategories.remove(cat['key']);
                      } else {
                        _selectedCategories.add(cat['key']!);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: 200.ms,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? palette.primary.withValues(alpha: 0.2)
                          : palette.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? palette.primaryLight : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat['icon']!, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          cat['label']!,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? palette.primaryLight : null,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔔', style: TextStyle(fontSize: 60))
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            'Daily Reminders',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            'Get a gentle nudge to take a moment for yourself.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Morning'),
                  subtitle: const Text('8:00 AM'),
                  value: _remindersEnabled,
                  onChanged: (v) => setState(() => _remindersEnabled = v),
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(),
                ListTile(
                  title: const Text('You can change this anytime'),
                  subtitle: const Text('In Settings → Reminders'),
                  leading: const Icon(Icons.settings_rounded, size: 20),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Text(
            'We\'ll send you a daily affirmation at your preferred time.',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}