import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'features/affirmations/data/models/affirmation.dart';
import 'features/mood_tracking/data/models/mood_entry.dart';
import 'features/favorites/data/favorites_repository.dart';
import 'core/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(AffirmationAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(MoodEntryAdapter());
  }

  // Initialize repositories
  await FavoritesRepository().initialize();

  // Initialize notifications
  await NotificationService().initialize();
  await NotificationService().requestPermissions();

  runApp(
    const ProviderScope(
      child: OpenAssuranceApp(),
    ),
  );
}
