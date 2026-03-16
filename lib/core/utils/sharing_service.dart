import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

/// Service for sharing content
class SharingService {
  static final SharingService _instance = SharingService._internal();
  factory SharingService() => _instance;
  SharingService._internal();

  /// Share text content
  Future<void> shareText(String text, {String? subject}) async {
    await Share.share(
      text,
      subject: subject,
    );
  }

  /// Share an affirmation with attribution
  Future<void> shareAffirmation(String affirmation, {String? author}) async {
    final buffer = StringBuffer();
    buffer.writeln('✨ $affirmation ✨');
    buffer.writeln();
    if (author != null && author.isNotEmpty) {
      buffer.writeln('— $author');
      buffer.writeln();
    }
    buffer.writeln('Shared from Open Assurance 💜');
    
    await Share.share(
      buffer.toString(),
      subject: 'Words of encouragement',
    );
  }

  /// Copy text to clipboard
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Share the app
  Future<void> shareApp() async {
    const String shareText = '''
🌟 Open Assurance - Words of hope when you need them most

A free, open-source app for mental wellness and daily affirmations.

Download today and find comfort in words that matter.

#OpenAssurance #MentalHealth #FreeApp
''';
    
    await Share.share(
      shareText,
      subject: 'Check out Open Assurance',
    );
  }
}
