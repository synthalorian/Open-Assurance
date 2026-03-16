import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/reminder_provider.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final reminderState = ref.watch(reminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader(context, 'Appearance'),
          SettingsTile(
            icon: Icons.palette_rounded,
            title: 'Theme',
            subtitle: themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) => ref.read(themeModeProvider.notifier).setTheme(
                    value ? ThemeMode.dark : ThemeMode.light,
                  ),
            ),
            onTap: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Reminders'),
          SettingsTile(
            icon: Icons.notifications_rounded,
            title: 'Daily Affirmation',
            subtitle: reminderState.isEnabled 
                ? 'Reminder set for ${reminderState.hour.toString().padLeft(2, '0')}:${reminderState.minute.toString().padLeft(2, '0')}'
                : 'Remind me to take a moment for myself',
            trailing: Switch(
              value: reminderState.isEnabled,
              onChanged: (value) => ref.read(reminderProvider.notifier).setEnabled(value),
            ),
            onTap: () => _showTimePicker(context, ref, reminderState),
          ),
          
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Support'),
          SettingsTile(
            icon: Icons.coffee_rounded,
            title: 'Buy Me a Coffee',
            subtitle: 'Support the development of this app',
            iconColor: Colors.orange,
            onTap: () => _launchUrl('https://www.buymeacoffee.com/synthalorian'),
          ),

          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Data'),
          SettingsTile(
            icon: Icons.backup_rounded,
            title: 'Backup & Export',
            subtitle: 'Save your affirmations and mood history',
            onTap: () => _showComingSoon(context),
          ),
          SettingsTile(
            icon: Icons.restore_rounded,
            title: 'Restore',
            subtitle: 'Import previously saved data',
            onTap: () => _showComingSoon(context),
          ),
          
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'About'),
          SettingsTile(
            icon: Icons.code_rounded,
            title: 'Open Source',
            subtitle: 'View the code on GitHub',
            onTap: () => _launchUrl('https://github.com/synthalorian/Open-Assurance'),
          ),
          SettingsTile(
            icon: Icons.privacy_tip_rounded,
            title: 'Privacy Policy',
            subtitle: 'Your privacy matters',
            onTap: () => _showPrivacy(context),
          ),
          SettingsTile(
            icon: Icons.favorite_rounded,
            title: 'Credits',
            subtitle: 'Made with love for those who need it',
            onTap: () => _showCreditsDialog(context),
          ),
          
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Open Assurance v1.0.0',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'You matter. 💜',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primaryLight,
                  ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showTimePicker(BuildContext context, WidgetRef ref, ReminderState reminderState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: reminderState.hour, minute: reminderState.minute),
    );
    if (picked != null) {
      ref.read(reminderProvider.notifier).setTime(picked.hour, picked.minute);
      if (!reminderState.isEnabled) {
        ref.read(reminderProvider.notifier).setEnabled(true);
      }
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon in a future update!')),
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Open Assurance',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.primary.withOpacity(0.1),
        ),
        child: const Center(child: Text('💜', style: TextStyle(fontSize: 32))),
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Privacy Matters',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Open Assurance is designed with your privacy in mind:',
              ),
              SizedBox(height: 12),
              Text('• All data stays on your device'),
              Text('• No accounts or sign-ups required'),
              Text('• No analytics or tracking'),
              Text('• No internet connection needed'),
              Text('• Your data is yours alone'),
              SizedBox(height: 16),
              Text(
                'This app was created to help people, not to profit from their data.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Credits'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Open Assurance',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Text('A free, open-source app for mental wellness'),
            const SizedBox(height: 20),
            const Text('Built with:'),
            const SizedBox(height: 8),
            const Text('• Flutter & Dart'),
            const Text('• Riverpod for state management'),
            const Text('• Hive for local storage'),
            const SizedBox(height: 20),
            const Text('Made for those who need words of hope'),
            const SizedBox(height: 8),
            Text(
              'You matter. 💜',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primaryLight,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
