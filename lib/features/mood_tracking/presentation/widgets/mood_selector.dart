import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/mood_provider.dart';

class MoodSelector extends ConsumerStatefulWidget {
  const MoodSelector({super.key});

  @override
  ConsumerState<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends ConsumerState<MoodSelector> {
  int? _selectedMood;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            'How are you feeling right now?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Mood grid (3x2)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: _buildMoodOptions(),
          ),

          const SizedBox(height: 20),
          
          // Note field (always visible)
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Add a note about how you\'re feeling...',
            ),
          ),

          const SizedBox(height: 20),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedMood == null ? null : () async {
                await ref.read(moodNotifierProvider.notifier).addMoodEntry(
                  _selectedMood!,
                  note: _noteController.text.isNotEmpty 
                      ? _noteController.text 
                      : null,
                );
                setState(() {
                  _selectedMood = null;
                  _noteController.clear();
                });
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mood logged successfully! 💜'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Log Mood'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMoodOptions() {
    final moods = [
      (0, '😢', 'Rough', AppColors.moodTerrible),
      (1, '😰', 'Meh', AppColors.moodAnxious),
      (2, '😐', 'Okay', AppColors.moodNeutral),
      (3, '😌', 'Good', AppColors.moodHappy),
      (4, '😊', 'Great', AppColors.moodHappy),
      (5, '🤩', 'Amazing', AppColors.moodHappy),
    ];

    return moods.map((mood) {
      final (level, emoji, label, color) = mood;
      final isSelected = _selectedMood == level;

      return GestureDetector(
        onTap: () => setState(() => _selectedMood = level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected 
                ? color.withOpacity(0.2) 
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected ? color : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
