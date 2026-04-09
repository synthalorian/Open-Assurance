import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:open_assurance/app.dart';

void main() {
  setUp(() {
    // Disable animations in tests to prevent pending timer issues
    Animate.restartOnHotReload = false;
  });

  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OpenAssuranceApp(),
      ),
    );

    // Let animations settle (with timeout to avoid infinite pump)
    await tester.pump(const Duration(seconds: 1));

    // App should render a MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
