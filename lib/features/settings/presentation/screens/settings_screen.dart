import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
    final themeState = ref.watch(themeStateProvider);
    final reminderState = ref.watch(reminderProvider);
    final allThemes = ref.watch(allThemesProvider);
    final palette = ref.watch(currentPaletteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ─── Theme Selector ─────────────────────────────
          _buildSectionHeader(context, 'Theme'),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allThemes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final theme = allThemes[index];
                final isActive = theme.id == themeState.config.id;
                final tPalette = theme.palette;

                return GestureDetector(
                  onTap: () => ref.read(themeStateProvider.notifier).setTheme(theme),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    width: 90,
                    decoration: BoxDecoration(
                      color: tPalette.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? tPalette.primaryLight : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: tPalette.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(theme.icon, color: tPalette.primary, size: 28),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            theme.displayName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? tPalette.primaryLight : tPalette.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ─── Appearance ────────────────────────────────
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Appearance'),
          SettingsTile(
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            subtitle: themeState.mode == ThemeMode.dark ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: themeState.mode == ThemeMode.dark,
              onChanged: (value) => ref.read(themeStateProvider.notifier).setMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  ),
            ),
            onTap: () => ref.read(themeStateProvider.notifier).toggleMode(),
          ),

          // ─── Reminders ─────────────────────────────────
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

          // Quick time presets
          if (reminderState.isEnabled) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTimePreset(context, ref, '🌅 Morning', 8, 0),
                const SizedBox(width: 12),
                _buildTimePreset(context, ref, '🌙 Evening', 20, 0),
                const SizedBox(width: 12),
                _buildTimePreset(context, ref, '☀️ Midday', 12, 0),
              ],
            ),
          ],

          // ─── Support ───────────────────────────────────
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Support'),
          SettingsTile(
            icon: Icons.coffee_rounded,
            title: 'Buy Me a Coffee',
            subtitle: 'Support the development of this app',
            iconColor: Colors.orange,
            onTap: () => _launchUrl('https://www.buymeacoffee.com/synthalorian'),
          ),

          // ─── Data ──────────────────────────────────────
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

          // ─── Danger Zone ───────────────────────────────
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Danger Zone'),
          SettingsTile(
            icon: Icons.delete_forever_rounded,
            title: 'Reset All Data',
            subtitle: 'Clear favorites, mood entries, and settings',
            iconColor: palette.error,
            onTap: () => _showResetDialog(context, ref),
          ),

          // ─── About ─────────────────────────────────────
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

          // ─── Footer ────────────────────────────────────
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Open Assurance v1.1.0',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: palette.textTertiary,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'You matter. 💜',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.primaryLight,
                  ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTimePreset(
    BuildContext context,
    WidgetRef ref,
    String label,
    int hour,
    int minute,
  ) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => ref.read(reminderProvider.notifier).setTime(hour, minute),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showTimePicker(
      BuildContext context, WidgetRef ref, ReminderState reminderState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: reminderState.hour, minute: reminderState.minute),
    );
    if (picked != null) {
      ref.read(reminderProvider.notifier).setTime(picked.hour, picked.minute);
      if (!reminderState.isEnabled) {
        ref.read(reminderProvider.notifier).setEnabled(true);
      }
    }
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset All Data'),
        content: const Text(
          'This will permanently delete all your favorites, mood entries, '
          'and custom affirmations. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Hive.deleteFromDisk();
              await Hive.initFlutter();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data has been reset')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon in a future update!')),
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
              Text('Your Privacy Matters',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Open Assurance is designed with your privacy in mind:'),
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
            Text('Open Assurance',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
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