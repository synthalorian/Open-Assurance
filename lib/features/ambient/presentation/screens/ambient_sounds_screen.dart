import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/soundscapes.dart';
import '../../../../core/utils/audio_service.dart';
import '../providers/ambient_provider.dart';

class AmbientSoundsScreen extends ConsumerWidget {
  const AmbientSoundsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSounds = ref.watch(ambientProvider);
    const allSounds = AmbientSounds.allSounds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambient Mixer'),
        actions: [
          if (activeSounds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.stop_rounded),
              onPressed: () => ref.read(ambientProvider.notifier).stopAll(),
            ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Your Sanctuary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mix multiple nature sounds together for a custom environment.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          
          // Quick Presets
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Presets',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Soundscapes.presets.length,
                      itemBuilder: (context, index) {
                        final preset = Soundscapes.presets[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Material(
                            color: AppColors.backgroundCard,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () => ref.read(ambientProvider.notifier).loadPreset(preset),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(preset.icon, style: const TextStyle(fontSize: 24)),
                                    const SizedBox(height: 4),
                                    Text(
                                      preset.name,
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.primaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          if (activeSounds.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final fileName = activeSounds.keys.elementAt(index);
                    final volume = activeSounds[fileName]!;
                    final sound = allSounds.firstWhere((s) => s.fileName == fileName);
                    
                    return _buildVolumeSlider(context, ref, sound, volume);
                  },
                  childCount: activeSounds.length,
                ),
              ),
            ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
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
                  final isActive = activeSounds.containsKey(sound.fileName);
                  
                  return _buildSoundToggle(context, ref, sound, isActive);
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

  Widget _buildVolumeSlider(
    BuildContext context,
    WidgetRef ref,
    AmbientSound sound,
    double volume,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(sound.icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(sound.displayName, style: Theme.of(context).textTheme.labelLarge),
                    Text('${(volume * 100).toInt()}%', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  ),
                  child: Slider(
                    value: volume,
                    onChanged: (v) => ref.read(ambientProvider.notifier).updateVolume(sound.fileName, v),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () => ref.read(ambientProvider.notifier).toggleSound(sound.fileName),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundToggle(
    BuildContext context,
    WidgetRef ref,
    AmbientSound sound,
    bool isActive,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withValues(alpha: 0.2) : AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? AppColors.primaryLight : Colors.transparent,
          width: 2,
        ),
        boxShadow: isActive ? [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ref.read(ambientProvider.notifier).toggleSound(sound.fileName),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(sound.icon, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(
                sound.displayName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.primaryLight : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
