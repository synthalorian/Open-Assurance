import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for managing home screen widgets
/// Note: Widget functionality is currently disabled to fix home screen display issues
class WidgetService {
  static final WidgetService _instance = WidgetService._internal();
  factory WidgetService() => _instance;
  WidgetService._internal();

  /// Update the home screen widget with a new affirmation (no-op)
  Future<void> updateAffirmation(String text, {String? category}) async {
    try {
      // No-op
    } catch (_) {}
  }

  /// Set up widget callback for when user taps the widget (no-op)
  Future<void> initializeCallback() async {
    try {
      // No-op
    } catch (_) {}
  }

  /// Get the current widget data (no-op)
  Future<String?> getAffirmationText() async {
    return null;
  }

  /// Clear widget data (no-op)
  Future<void> clearWidget() async {
    try {
      // No-op
    } catch (_) {}
  }
}

/// Provider for widget service
final widgetServiceProvider = Provider<WidgetService>((ref) {
  return WidgetService();
});
