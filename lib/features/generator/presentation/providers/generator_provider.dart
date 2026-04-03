import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/templates.dart';

/// State for affirmation generator
class GeneratorState {
  final AffirmationTemplate? selectedTemplate;
  final Map<String, String> customVariables;
  final String? generatedAffirmation;
  final bool isGenerating;

  GeneratorState({
    this.selectedTemplate,
    Map<String, String>? customVariables,
    this.generatedAffirmation,
    this.isGenerating = false,
  }) : customVariables = customVariables ?? {};

  GeneratorState copyWith({
    AffirmationTemplate? selectedTemplate,
    Map<String, String>? customVariables,
    String? generatedAffirmation,
    bool? isGenerating,
  }) {
    return GeneratorState(
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      customVariables: customVariables ?? this.customVariables,
      generatedAffirmation: generatedAffirmation ?? this.generatedAffirmation,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }
}

/// Notifier for generator state
class GeneratorNotifier extends StateNotifier<GeneratorState> {
  final Random _random = Random();

  GeneratorNotifier() : super(GeneratorState());

  void selectTemplate(AffirmationTemplate template) {
    state = state.copyWith(
      selectedTemplate: template,
      customVariables: {},
      generatedAffirmation: null,
    );
  }

  void setVariable(String key, String value) {
    final newVariables = Map<String, String>.from(state.customVariables);
    newVariables[key] = value;
    state = state.copyWith(customVariables: newVariables);
  }

  void generate() {
    if (state.selectedTemplate == null) return;

    state = state.copyWith(isGenerating: true);

    // Simulate generation delay for effect
    Future.delayed(const Duration(milliseconds: 500), () {
      final affirmation = state.selectedTemplate!.generate(
        customVariables: state.customVariables.isNotEmpty
            ? state.customVariables
            : null,
      );
      state = state.copyWith(
        generatedAffirmation: affirmation,
        isGenerating: false,
      );
    });
  }

  void generateRandom({String? category}) {
    state = state.copyWith(isGenerating: true);

    Future.delayed(const Duration(milliseconds: 500), () {
      final templates = category != null
          ? AffirmationTemplates.getByCategory(category)
          : AffirmationTemplates.all;

      if (templates.isEmpty) {
        state = state.copyWith(isGenerating: false);
        return;
      }

      final template = templates[_random.nextInt(templates.length)];
      final affirmation = template.generate();

      state = state.copyWith(
        selectedTemplate: template,
        generatedAffirmation: affirmation,
        isGenerating: false,
      );
    });
  }

  void reset() {
    state = GeneratorState();
  }
}

/// Provider for generator state
final generatorProvider =
    StateNotifierProvider<GeneratorNotifier, GeneratorState>((ref) {
  return GeneratorNotifier();
});

/// Provider for all templates
final templatesProvider = Provider<List<AffirmationTemplate>>((ref) {
  return AffirmationTemplates.all;
});

/// Provider for templates by category
final templatesByCategoryProvider =
    Provider.family<List<AffirmationTemplate>, String>((ref, category) {
  return AffirmationTemplates.getByCategory(category);
});
