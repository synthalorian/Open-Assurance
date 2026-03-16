/// Affirmation templates for generation
class AffirmationTemplates {
  static const List<AffirmationTemplate> all = [
    // Self-worth templates
    AffirmationTemplate(
      id: 'self_worth_1',
      category: 'self_worth',
      template: 'I am {adjective} and I deserve {noun}.',
      variables: {
        'adjective': ['worthy', 'capable', 'strong', 'beautiful', 'intelligent'],
        'noun': ['happiness', 'success', 'love', 'peace', 'abundance'],
      },
    ),
    AffirmationTemplate(
      id: 'self_worth_2',
      category: 'self_worth',
      template: '{name}, you are {quality}.',
      variables: {
        'quality': ['enough', 'worthy', 'loved', 'valuable', 'important'],
      },
    ),

    // Motivation templates
    AffirmationTemplate(
      id: 'motivation_1',
      category: 'motivation',
      template: 'I have the power to {action}.',
      variables: {
        'action': [
          'achieve my goals',
          'create positive change',
          'overcome any obstacle',
          'make my dreams reality',
        ],
      },
    ),
    AffirmationTemplate(
      id: 'motivation_2',
      category: 'motivation',
      template: 'Every day, I am becoming more {quality}.',
      variables: {
        'quality': ['confident', 'successful', 'focused', 'determined', 'resilient'],
      },
    ),

    // Anxiety templates
    AffirmationTemplate(
      id: 'anxiety_1',
      category: 'anxiety',
      template: 'I release {negative} and embrace {positive}.',
      variables: {
        'negative': ['fear', 'worry', 'doubt', 'anxiety'],
        'positive': ['peace', 'calm', 'confidence', 'trust'],
      },
    ),
    AffirmationTemplate(
      id: 'anxiety_2',
      category: 'anxiety',
      template: 'In this moment, I am {state}.',
      variables: {
        'state': ['safe', 'calm', 'grounded', 'at peace', 'centered'],
      },
    ),

    // Confidence templates
    AffirmationTemplate(
      id: 'confidence_1',
      category: 'confidence',
      template: 'I am confident in my ability to {action}.',
      variables: {
        'action': [
          'handle any situation',
          'achieve my goals',
          'express myself',
          'make decisions',
        ],
      },
    ),

    // Peace templates
    AffirmationTemplate(
      id: 'peace_1',
      category: 'peace',
      template: 'I find peace in {source}.',
      variables: {
        'source': [
          'this moment',
          'my breath',
          'nature',
          'stillness',
          'self-acceptance',
        ],
      },
    ),

    // Hope templates
    AffirmationTemplate(
      id: 'hope_1',
      category: 'hope',
      template: 'I believe in {belief}.',
      variables: {
        'belief': [
          'better days ahead',
          'my ability to grow',
          'the power of change',
          'new possibilities',
        ],
      },
    ),

    // Gratitude templates
    AffirmationTemplate(
      id: 'gratitude_1',
      category: 'gratitude',
      template: 'I am grateful for {gratitude_item}.',
      variables: {
        'gratitude_item': [
          'this moment',
          'my journey',
          'the people in my life',
          'my strength',
          'today\'s opportunities',
        ],
      },
    ),
  ];

  static List<AffirmationTemplate> getByCategory(String category) {
    return all.where((t) => t.category == category).toList();
  }

  static AffirmationTemplate? getById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Affirmation template model
class AffirmationTemplate {
  final String id;
  final String category;
  final String template;
  final Map<String, List<String>> variables;

  const AffirmationTemplate({
    required this.id,
    required this.category,
    required this.template,
    required this.variables,
  });

  /// Generate an affirmation from the template
  String generate({Map<String, String>? customVariables}) {
    String result = template;
    final random = DateTime.now().millisecondsSinceEpoch;

    variables.forEach((key, options) {
      final value = customVariables?[key] ?? options[random % options.length];
      result = result.replaceAll('{$key}', value);
    });

    return result;
  }
}
