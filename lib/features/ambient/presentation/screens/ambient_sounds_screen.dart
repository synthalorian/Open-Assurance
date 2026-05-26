import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../data/soundscapes.dart';
import '../providers/ambient_provider.dart';

/// Provider for sleep timer
final sleepTimerProvider = StateProvider<int?>((ref) => null);

class AmbientSoundsScreen extends ConsumerStatefulWidget {
  const AmbientSoundsScreen({super.key});

  @override
  ConsumerState<AmbientSoundsScreen> createState() => _AmbientSoundsScreenState();
}

class _AmbientSoundsScreenState extends ConsumerState<AmbientSoundsScreen> {
  Timer? _sleepTimer;
  int _remainingSeconds = 0;
  double _masterVolume = 0.8;

  @override
  void dispose() {
    _sleepTimer?.cancel();
    super.dispose();
  }

  void _startSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    _remainingSeconds = minutes * 60;
    ref.read(sleepTimerProvider.notifier).state = minutes;

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });
      if (_remainingSeconds <= 0) {
        timer.cancel();
        ref.read(ambientProvider.notifier).stopAll();
        ref.read(sleepTimerProvider.notifier).state = null;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ambient sounds stopped — sleep timer complete. 🌙'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    });
  }

  void _cancelSleepTimer() {
    _sleepTimer?.cancel();
    ref.read(sleepTimerProvider.notifier).state = null;
    setState(() => _remainingSeconds = 0);
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Soundscape? _findSound(String assetPath) {
    try {
      return Soundscapes.all.firstWhere((s) => s.assetPath == assetPath);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeSounds = ref.watch(ambientProvider);
    const allSounds = Soundscapes.all;
    final sleepTimerMinutes = ref.watch(sleepTimerProvider);
    final palette = ref.watch(currentPaletteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambient Mixer'),
        actions: [
          if (activeSounds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.stop_rounded),
              tooltip: 'Stop All',
              onPressed: () => ref.read(ambientProvider.notifier).stopAll(),
            ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Header ─────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Your Sanctuary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mix nature sounds to build your perfect environment.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Quick Presets ──────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Quick Presets',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 0, 0),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: Soundscapes.presets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final preset = Soundscapes.presets[index];
                    final isActive = preset.soundIds.every((id) {
                      final s = Soundscapes.getById(id);
                      return s != null && activeSounds.containsKey(s.assetPath);
                    });
                    return Material(
                      color: isActive
                          ? palette.primary.withValues(alpha: 0.2)
                          : palette.card,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () => ref.read(ambientProvider.notifier).loadPreset(preset),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isActive
                                  ? palette.primaryLight.withValues(alpha: 0.5)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(preset.icon, style: const TextStyle(fontSize: 24)),
                              const SizedBox(height: 4),
                              Text(
                                preset.name,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: isActive ? palette.primaryLight : palette.textSecondary,
                                      fontWeight: isActive ? FontWeight.bold : null,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ─── Master Volume ──────────────────────
          if (activeSounds.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.volume_up_rounded, size: 20),
                      const SizedBox(width: 12),
                      Text('Master', style: Theme.of(context).textTheme.labelLarge),
                      const Spacer(),
                      SizedBox(
                        width: 160,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                          ),
                          child: Slider(
                            value: _masterVolume,
                            onChanged: (v) {
                              setState(() => _masterVolume = v);
                              ref.read(ambientProvider.notifier).setMasterVolume(v);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        child: Text(
                          '${(_masterVolume * 100).toInt()}%',
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ─── Active Sounds (volume sliders) ─────
          if (activeSounds.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final assetPath = activeSounds.keys.elementAt(index);
                    final volume = activeSounds[assetPath]!;
                    final sound = _findSound(assetPath);

                    if (sound == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: palette.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Text(sound.icon, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 60,
                              child: Text(
                                sound.name,
                                style: Theme.of(context).textTheme.labelSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 2,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                ),
                                child: Slider(
                                  value: volume,
                                  onChanged: (v) =>
                                      ref.read(ambientProvider.notifier).updateVolume(assetPath, v),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '${(volume * 100).toInt()}%',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () =>
                                  ref.read(ambientProvider.notifier).toggleSound(assetPath),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: activeSounds.length,
                ),
              ),
            ),

          // ─── Sleep Timer ────────────────────────
          if (activeSounds.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Sleep Timer',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (sleepTimerMinutes != null) ...[
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: palette.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _formatTime(_remainingSeconds),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: palette.primaryLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (sleepTimerMinutes == null)
                        Row(
                          children: [
                            _buildTimerButton(context, '15m', 15),
                            const SizedBox(width: 8),
                            _buildTimerButton(context, '30m', 30),
                            const SizedBox(width: 8),
                            _buildTimerButton(context, '45m', 45),
                            const SizedBox(width: 8),
                            _buildTimerButton(context, '60m', 60),
                          ],
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _cancelSleepTimer,
                            icon: const Icon(Icons.cancel_rounded, size: 18),
                            label: const Text('Cancel Timer'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: palette.error,
                              side: BorderSide(color: palette.error.withValues(alpha: 0.5)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // ─── Sound Grid ─────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'All Sounds',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final sound = allSounds[index];
                  final isActive = activeSounds.containsKey(sound.assetPath);

                  return AnimatedContainer(
                    duration: 200.ms,
                    decoration: BoxDecoration(
                      color: isActive
                          ? palette.primary.withValues(alpha: 0.15)
                          : palette.card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isActive
                            ? palette.primaryLight.withValues(alpha: 0.5)
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: palette.primary.withValues(alpha: 0.2),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => ref.read(ambientProvider.notifier).toggleSound(sound.assetPath),
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(sound.icon, style: const TextStyle(fontSize: 36)),
                            const SizedBox(height: 10),
                            Text(
                              sound.name,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                    color: isActive ? palette.primaryLight : null,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sound.description,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: palette.textTertiary,
                                  ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: allSounds.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildTimerButton(BuildContext context, String label, int minutes) {
    final palette = ref.watch(currentPaletteProvider);
    return Expanded(
      child: OutlinedButton(
        onPressed: () => _startSleepTimer(minutes),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: BorderSide(color: palette.primary.withValues(alpha: 0.4)),
          foregroundColor: palette.primaryLight,
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}