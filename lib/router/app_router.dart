import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/journal/presentation/screens/journal_screen.dart';
import '../features/tools/presentation/screens/tools_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/breathing/presentation/screens/breathing_screen.dart';
import '../features/ambient/presentation/screens/ambient_sounds_screen.dart';
import '../features/generator/presentation/screens/generator_screen.dart';
import '../features/crisis/presentation/screens/crisis_resources_screen.dart';
import '../features/mood_tracking/presentation/screens/mood_screen.dart';
import '../features/favorites/presentation/screens/favorites_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/journal',
          builder: (context, state) => const JournalScreen(),
          routes: [
            GoRoute(
              path: 'mood',
              builder: (context, state) => const MoodScreen(),
            ),
            GoRoute(
              path: 'favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/tools',
          builder: (context, state) => const ToolsScreen(),
          routes: [
            GoRoute(
              path: 'breathing',
              builder: (context, state) => const BreathingScreen(),
            ),
            GoRoute(
              path: 'ambient',
              builder: (context, state) => const AmbientSoundsScreen(),
            ),
            GoRoute(
              path: 'generator',
              builder: (context, state) => const GeneratorScreen(),
            ),
            GoRoute(
              path: 'crisis',
              builder: (context, state) => const CrisisResourcesScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFC77DFF),
        unselectedItemColor: const Color(0xFFADB5BD),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology_rounded), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/') return 0;
    if (location.startsWith('/journal')) return 1;
    if (location.startsWith('/tools')) return 2;
    if (location == '/settings') return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/'); break;
      case 1: context.go('/journal'); break;
      case 2: context.go('/tools'); break;
      case 3: context.go('/settings'); break;
    }
  }
}
