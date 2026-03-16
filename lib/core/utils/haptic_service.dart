import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for haptic feedback
final hapticServiceProvider = Provider((ref) => HapticService());

class HapticService {
  void light() => HapticFeedback.lightImpact();
  void medium() => HapticFeedback.mediumImpact();
  void heavy() => HapticFeedback.heavyImpact();
  void selection() => HapticFeedback.selectionClick();
  void success() => HapticFeedback.vibrate();
}
