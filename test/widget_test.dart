import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:open_assurance/app.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OpenAssuranceApp(),
      ),
    );

    // App should render a MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
