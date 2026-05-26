import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'router/app_router.dart';

class OpenAssuranceApp extends ConsumerWidget {
  const OpenAssuranceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeStateProvider);
    final router = ref.watch(routerProvider);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            themeState.mode == ThemeMode.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: themeState.mode == ThemeMode.dark
            ? const Color(0xFF0D0221)
            : Colors.white,
        systemNavigationBarIconBrightness:
            themeState.mode == ThemeMode.dark ? Brightness.light : Brightness.dark,
      ),
    );

    return MaterialApp.router(
      title: 'Open Assurance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(themeState.config, Brightness.light),
      darkTheme: AppTheme.build(themeState.config, Brightness.dark),
      themeMode: themeState.mode,
      routerConfig: router,
    );
  }
}