import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../affirmations/data/models/affirmation.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  final _textController = TextEditingController();
  List<Affirmation> _customAffirmations = [];
  bool _isLoading = true;

  // Template parts for generation
  final List<String> _starters = [
    'I am',
    'I choose to',
    'I deserve',
    'I embrace',
    'I release',
    'I trust',
    'I welcome',
    'I believe in',
  ];

  final List<String> _middles = [
    'worthy of love and respect',
    'enough exactly as I am',
    'growing stronger each day',
    'capable of amazing things',
    'at peace with myself',
    'deserving of happiness',
    'moving forward with courage',
    'healing and becoming whole',
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomAffirmations();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomAffirmations() async {
    final box = await Hive.openBox<Affirmation>('custom_affirmations');
    setState(() {
      _customAffirmations = box.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _isLoading = false;
    });
  }

  Future<void> _saveAffirmation() async {
    if (_textController.text.trim().isEmpty) return;

    final affirmation = Affirmation(
      text: _textController.text.trim(),
      category: AffirmationCategories.general,
      isCustom: true,
    );

    final box = await Hive.openBox<Affirmation>('custom_affirmations');
    await box.put(affirmation.id, affirmation);

    setState(() {
      _customAffirmations.insert(0, affirmation);
      _textController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.affirmationSaved),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String _generateAffirmation() {
    final starter = _starters[DateTime.now().millisecond % _starters.length];
    final middle = _middles[DateTime.now().microsecond % _middles.length];
    return '$starter $middle.';
  }

  Future<void> _deleteAffirmation(String id) async {
    final box = await Hive.openBox<Affirmation>('custom_affirmations');
    await box.delete(id);

    setState(() {
      _customAffirmations.removeWhere((a) => a.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.affirmationGenerator),
      ),
      body: CustomScrollView(
        slivers: [
          // Generator section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Your Own',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Write a personal affirmation or generate one',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          // Input card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Write your affirmation...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _textController.text = _generateAffirmation();
                            },
                            icon: const Icon(Icons.auto_awesome_rounded),
                            label: const Text('Generate'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saveAffirmation,
                            icon: const Icon(Icons.save_rounded),
                            label: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Saved affirmations
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.myCustomAffirmations,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Custom affirmations list
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_customAffirmations.isEmpty)
            SliverToBoxAdapter(
              child: _buildEmptyState(context),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final affirmation = _customAffirmations[index];
                  return _buildAffirmationCard(context, affirmation);
                },
                childCount: _customAffirmations.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 40,
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No custom affirmations yet',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Create your own personal affirmations',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAffirmationCard(BuildContext context, Affirmation affirmation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Dismissible(
          key: Key(affirmation.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.delete_rounded,
              color: AppColors.error,
            ),
          ),
          onDismissed: (direction) {
            _deleteAffirmation(affirmation.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit_rounded,
                            size: 12,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Custom',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.accent,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(affirmation.createdAt),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  affirmation.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
