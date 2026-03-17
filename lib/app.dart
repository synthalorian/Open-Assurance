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
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: themeMode == ThemeMode.dark 
            ? const Color(0xFF10002B) 
            : Colors.white,
        systemNavigationBarIconBrightness: themeMode == ThemeMode.dark 
            ? Brightness.light 
            : Brightness.dark,
      ),
    );

    return MaterialApp.router(
      title: 'Open Assurance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
