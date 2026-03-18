import 'dart:math';
import '../models/affirmation.dart';

/// Curated collection of affirmations
/// 100+ affirmations across 10 categories
class LocalAffirmations {
  LocalAffirmations._();

  static final List<Affirmation> allAffirmations = [
    // Self-Worth (1-12)
    Affirmation(
      text: 'You are worthy of love and belonging, exactly as you are.',
      category: AffirmationCategories.selfWorth,
      tags: ['love', 'acceptance'],
    ),
    Affirmation(
      text: 'Your value does not decrease based on someone\'s inability to see your worth.',
      category: AffirmationCategories.selfWorth,
      tags: ['value', 'perspective'],
    ),
    Affirmation(
      text: 'You are enough. You have always been enough. You will always be enough.',
      category: AffirmationCategories.selfWorth,
      tags: ['enough', 'identity'],
    ),
    Affirmation(
      text: 'Your imperfections make you human, not unlovable.',
      category: AffirmationCategories.selfWorth,
      tags: ['humanity', 'acceptance'],
    ),
    Affirmation(
      text: 'You deserve the same kindness you so freely give to others.',
      category: AffirmationCategories.selfWorth,
      tags: ['kindness', 'self-care'],
    ),
    Affirmation(
      text: 'There is no one else in the world quite like you, and that is your power.',
      category: AffirmationCategories.selfWorth,
      tags: ['uniqueness', 'power'],
    ),
    Affirmation(
      text: 'You are not defined by your past or your mistakes.',
      category: AffirmationCategories.selfWorth,
      tags: ['freedom', 'growth'],
    ),
    Affirmation(
      text: 'Your presence in this world matters more than you know.',
      category: AffirmationCategories.selfWorth,
      tags: ['purpose', 'meaning'],
    ),
    Affirmation(
      text: 'You are worthy of good things, even when life feels hard.',
      category: AffirmationCategories.selfWorth,
      tags: ['worthiness', 'hope'],
    ),
    Affirmation(
      text: 'Your worth is not negotiable. It simply is.',
      category: AffirmationCategories.selfWorth,
      tags: ['worthiness', 'truth'],
    ),
    Affirmation(
      text: 'You are loved, you are valuable, you are important.',
      category: AffirmationCategories.selfWorth,
      tags: ['love', 'value'],
    ),
    Affirmation(
      text: 'Treat yourself with the same compassion you offer your closest friends.',
      category: AffirmationCategories.selfWorth,
      tags: ['compassion', 'self-care'],
    ),

    // Anxiety (13-24)
    Affirmation(
      text: 'This feeling will pass, like clouds moving across the sky.',
      category: AffirmationCategories.anxiety,
      tags: ['temporary', 'peace'],
    ),
    Affirmation(
      text: 'You have survived every anxious moment before this one. You will survive this too.',
      category: AffirmationCategories.anxiety,
      tags: ['strength', 'survival'],
    ),
    Affirmation(
      text: 'Breathe. You are safe in this moment.',
      category: AffirmationCategories.anxiety,
      tags: ['breathing', 'safety'],
    ),
    Affirmation(
      text: 'Not every thought deserves your attention. Let this one go.',
      category: AffirmationCategories.anxiety,
      tags: ['thoughts', 'release'],
    ),
    Affirmation(
      text: 'Your anxiety is lying to you. You are capable and strong.',
      category: AffirmationCategories.anxiety,
      tags: ['truth', 'capability'],
    ),
    Affirmation(
      text: 'It is okay to feel anxious. It does not make you weak.',
      category: AffirmationCategories.anxiety,
      tags: ['acceptance', 'strength'],
    ),
    Affirmation(
      text: 'One step at a time. You do not have to figure everything out right now.',
      category: AffirmationCategories.anxiety,
      tags: ['patience', 'pace'],
    ),
    Affirmation(
      text: 'Your nervous system is trying to protect you. Thank it, then remind it you are safe.',
      category: AffirmationCategories.anxiety,
      tags: ['protection', 'safety'],
    ),
    Affirmation(
      text: 'Anxiety is a feeling, not a fact. This is not permanent.',
      category: AffirmationCategories.anxiety,
      tags: ['feelings', 'impermanence'],
    ),
    Affirmation(
      text: 'You are more than your anxious thoughts.',
      category: AffirmationCategories.anxiety,
      tags: ['identity', 'truth'],
    ),
    Affirmation(
      text: 'Ground yourself in this moment. The future is not here yet.',
      category: AffirmationCategories.anxiety,
      tags: ['present', 'grounding'],
    ),
    Affirmation(
      text: 'It is okay to take a break. The world can wait.',
      category: AffirmationCategories.anxiety,
      tags: ['rest', 'permission'],
    ),

    // Motivation (25-36)
    Affirmation(
      text: 'You do not have to be perfect to make progress.',
      category: AffirmationCategories.motivation,
      tags: ['progress', 'perfectionism'],
    ),
    Affirmation(
      text: 'Small steps still move you forward.',
      category: AffirmationCategories.motivation,
      tags: ['steps', 'movement'],
    ),
    Affirmation(
      text: 'You are capable of more than you think.',
      category: AffirmationCategories.motivation,
      tags: ['capability', 'potential'],
    ),
    Affirmation(
      text: 'The fact that you are trying is proof of your strength.',
      category: AffirmationCategories.motivation,
      tags: ['effort', 'strength'],
    ),
    Affirmation(
      text: 'Progress, not perfection. Growth, not arrival.',
      category: AffirmationCategories.motivation,
      tags: ['progress', 'growth'],
    ),
    Affirmation(
      text: 'You have overcome challenges before. You can do it again.',
      category: AffirmationCategories.motivation,
      tags: ['resilience', 'strength'],
    ),
    Affirmation(
      text: 'Your best is enough, and your best changes from day to day.',
      category: AffirmationCategories.motivation,
      tags: ['effort', 'acceptance'],
    ),
    Affirmation(
      text: 'Do not let fear of failure stop you from trying.',
      category: AffirmationCategories.motivation,
      tags: ['fear', 'courage'],
    ),
    Affirmation(
      text: 'Every expert was once a beginner. Keep going.',
      category: AffirmationCategories.motivation,
      tags: ['learning', 'persistence'],
    ),
    Affirmation(
      text: 'Your potential is endless. Keep exploring.',
      category: AffirmationCategories.motivation,
      tags: ['potential', 'exploration'],
    ),
    Affirmation(
      text: 'Rest is part of the journey, not the opposite of it.',
      category: AffirmationCategories.motivation,
      tags: ['rest', 'balance'],
    ),
    Affirmation(
      text: 'Believe in yourself as much as others believe in you.',
      category: AffirmationCategories.motivation,
      tags: ['belief', 'confidence'],
    ),

    // Grief (37-47)
    Affirmation(
      text: 'Your grief is proof of your love. It is okay to feel it all.',
      category: AffirmationCategories.grief,
      tags: ['love', 'feelings'],
    ),
    Affirmation(
      text: 'There is no timeline for healing. Move at your own pace.',
      category: AffirmationCategories.grief,
      tags: ['healing', 'time'],
    ),
    Affirmation(
      text: 'It is okay to miss someone and still find moments of joy.',
      category: AffirmationCategories.grief,
      tags: ['joy', 'loss'],
    ),
    Affirmation(
      text: 'Your loved ones would want you to be gentle with yourself.',
      category: AffirmationCategories.grief,
      tags: ['gentleness', 'love'],
    ),
    Affirmation(
      text: 'Grief is not linear. Some days will be harder than others.',
      category: AffirmationCategories.grief,
      tags: ['process', 'acceptance'],
    ),
    Affirmation(
      text: 'You do not have to be strong all the time. It is okay to fall apart.',
      category: AffirmationCategories.grief,
      tags: ['vulnerability', 'permission'],
    ),
    Affirmation(
      text: 'The love you shared cannot be taken from you.',
      category: AffirmationCategories.grief,
      tags: ['love', 'memories'],
    ),
    Affirmation(
      text: 'Your tears are prayers your heart makes when words fail.',
      category: AffirmationCategories.grief,
      tags: ['expression', 'healing'],
    ),
    Affirmation(
      text: 'Healing does not mean forgetting. It means learning to carry the love forward.',
      category: AffirmationCategories.grief,
      tags: ['healing', 'memories'],
    ),
    Affirmation(
      text: 'You are allowed to feel everything you are feeling.',
      category: AffirmationCategories.grief,
      tags: ['feelings', 'permission'],
    ),
    Affirmation(
      text: 'It is okay to ask for help. You do not have to grieve alone.',
      category: AffirmationCategories.grief,
      tags: ['support', 'community'],
    ),

    // Stress Relief (48-58)
    Affirmation(
      text: 'This moment of stress will pass. You will get through it.',
      category: AffirmationCategories.stress,
      tags: ['temporary', 'strength'],
    ),
    Affirmation(
      text: 'You cannot pour from an empty cup. Take care of yourself first.',
      category: AffirmationCategories.stress,
      tags: ['self-care', 'boundaries'],
    ),
    Affirmation(
      text: 'It is okay to say no. Your peace matters.',
      category: AffirmationCategories.stress,
      tags: ['boundaries', 'peace'],
    ),
    Affirmation(
      text: 'You do not have to handle everything right now.',
      category: AffirmationCategories.stress,
      tags: ['patience', 'release'],
    ),
    Affirmation(
      text: 'Take a deep breath. Release the tension you are holding.',
      category: AffirmationCategories.stress,
      tags: ['breathing', 'relaxation'],
    ),
    Affirmation(
      text: 'You are doing the best you can with what you have. That is enough.',
      category: AffirmationCategories.stress,
      tags: ['effort', 'enough'],
    ),
    Affirmation(
      text: 'Not everything requires your immediate attention.',
      category: AffirmationCategories.stress,
      tags: ['priorities', 'release'],
    ),
    Affirmation(
      text: 'Step back. Rest. Return when you are ready.',
      category: AffirmationCategories.stress,
      tags: ['rest', 'pace'],
    ),
    Affirmation(
      text: 'You are allowed to take breaks. You are human.',
      category: AffirmationCategories.stress,
      tags: ['rest', 'humanity'],
    ),
    Affirmation(
      text: 'Let go of what you cannot control. Focus on what you can.',
      category: AffirmationCategories.stress,
      tags: ['control', 'focus'],
    ),
    Affirmation(
      text: 'Peace is a choice you can make in any moment.',
      category: AffirmationCategories.stress,
      tags: ['peace', 'choice'],
    ),

    // Relationships (59-69)
    Affirmation(
      text: 'You deserve relationships that feel safe and supportive.',
      category: AffirmationCategories.relationships,
      tags: ['boundaries', 'worth'],
    ),
    Affirmation(
      text: 'It is okay to outgrow people. Not everyone is meant to stay.',
      category: AffirmationCategories.relationships,
      tags: ['growth', 'change'],
    ),
    Affirmation(
      text: 'Your needs matter. Do not apologize for having them.',
      category: AffirmationCategories.relationships,
      tags: ['needs', 'boundaries'],
    ),
    Affirmation(
      text: 'Healthy love does not hurt. You deserve gentleness.',
      category: AffirmationCategories.relationships,
      tags: ['love', 'health'],
    ),
    Affirmation(
      text: 'You are allowed to set boundaries. The right people will respect them.',
      category: AffirmationCategories.relationships,
      tags: ['boundaries', 'respect'],
    ),
    Affirmation(
      text: 'You are whole on your own. Others add to your life, they do not complete it.',
      category: AffirmationCategories.relationships,
      tags: ['wholeness', 'independence'],
    ),
    Affirmation(
      text: 'It is okay to need space. It does not mean you do not care.',
      category: AffirmationCategories.relationships,
      tags: ['space', 'self-care'],
    ),
    Affirmation(
      text: 'The people who matter will make you feel like you matter.',
      category: AffirmationCategories.relationships,
      tags: ['value', 'love'],
    ),
    Affirmation(
      text: 'You are not responsible for other people\'s emotions.',
      category: AffirmationCategories.relationships,
      tags: ['boundaries', 'responsibility'],
    ),
    Affirmation(
      text: 'It is okay to let go of relationships that no longer serve you.',
      category: AffirmationCategories.relationships,
      tags: ['release', 'growth'],
    ),
    Affirmation(
      text: 'You are worthy of love that feels like home.',
      category: AffirmationCategories.relationships,
      tags: ['love', 'home'],
    ),

    // Healing (70-80)
    Affirmation(
      text: 'Healing is not linear. Be patient with your process.',
      category: AffirmationCategories.healing,
      tags: ['patience', 'process'],
    ),
    Affirmation(
      text: 'Your wounds do not make you weak. They make you human.',
      category: AffirmationCategories.healing,
      tags: ['vulnerability', 'humanity'],
    ),
    Affirmation(
      text: 'It is never too late to heal. Your journey starts when you say yes to it.',
      category: AffirmationCategories.healing,
      tags: ['time', 'beginning'],
    ),
    Affirmation(
      text: 'You are not broken. You are becoming.',
      category: AffirmationCategories.healing,
      tags: ['growth', 'transformation'],
    ),
    Affirmation(
      text: 'Healing requires feeling. Let yourself feel.',
      category: AffirmationCategories.healing,
      tags: ['feelings', 'release'],
    ),
    Affirmation(
      text: 'Your past does not determine your future. You can rewrite your story.',
      category: AffirmationCategories.healing,
      tags: ['future', 'agency'],
    ),
    Affirmation(
      text: 'It is brave to heal. It takes courage to face your pain.',
      category: AffirmationCategories.healing,
      tags: ['bravery', 'courage'],
    ),
    Affirmation(
      text: 'You are allowed to be both a masterpiece and a work in progress.',
      category: AffirmationCategories.healing,
      tags: ['acceptance', 'growth'],
    ),
    Affirmation(
      text: 'Healing happens in small moments. Celebrate each one.',
      category: AffirmationCategories.healing,
      tags: ['celebration', 'progress'],
    ),
    Affirmation(
      text: 'You are stronger than what tried to hurt you.',
      category: AffirmationCategories.healing,
      tags: ['strength', 'resilience'],
    ),
    Affirmation(
      text: 'Your story of healing can inspire others. Keep going.',
      category: AffirmationCategories.healing,
      tags: ['inspiration', 'hope'],
    ),

    // Confidence (81-91)
    Affirmation(
      text: 'You are capable of amazing things. Believe it.',
      category: AffirmationCategories.confidence,
      tags: ['capability', 'belief'],
    ),
    Affirmation(
      text: 'Your voice matters. Speak your truth.',
      category: AffirmationCategories.confidence,
      tags: ['voice', 'truth'],
    ),
    Affirmation(
      text: 'You do not need permission to be yourself.',
      category: AffirmationCategories.confidence,
      tags: ['authenticity', 'freedom'],
    ),
    Affirmation(
      text: 'Your uniqueness is your superpower. Own it.',
      category: AffirmationCategories.confidence,
      tags: ['uniqueness', 'power'],
    ),
    Affirmation(
      text: 'You have survived 100% of your hardest days. That is strength.',
      category: AffirmationCategories.confidence,
      tags: ['resilience', 'strength'],
    ),
    Affirmation(
      text: 'It is okay to take up space. You deserve to be here.',
      category: AffirmationCategories.confidence,
      tags: ['presence', 'worthiness'],
    ),
    Affirmation(
      text: 'Your ideas are valuable. Do not hide them.',
      category: AffirmationCategories.confidence,
      tags: ['ideas', 'value'],
    ),
    Affirmation(
      text: 'You are allowed to be confident and humble at the same time.',
      category: AffirmationCategories.confidence,
      tags: ['balance', 'authenticity'],
    ),
    Affirmation(
      text: 'Trust yourself. You know more than you think you do.',
      category: AffirmationCategories.confidence,
      tags: ['trust', 'knowledge'],
    ),
    Affirmation(
      text: 'You do not have to be the best. You just have to be brave enough to try.',
      category: AffirmationCategories.confidence,
      tags: ['bravery', 'effort'],
    ),
    Affirmation(
      text: 'Confidence comes from action. Start small, start now.',
      category: AffirmationCategories.confidence,
      tags: ['action', 'start'],
    ),

    // Gratitude (92-100)
    Affirmation(
      text: 'There is always something to be grateful for, even on hard days.',
      category: AffirmationCategories.gratitude,
      tags: ['gratitude', 'perspective'],
    ),
    Affirmation(
      text: 'Gratitude turns what we have into enough.',
      category: AffirmationCategories.gratitude,
      tags: ['abundance', 'contentment'],
    ),
    Affirmation(
      text: 'Small moments of joy are worth noticing.',
      category: AffirmationCategories.gratitude,
      tags: ['joy', 'awareness'],
    ),
    Affirmation(
      text: 'You have made it through difficult days before. Be grateful for your strength.',
      category: AffirmationCategories.gratitude,
      tags: ['strength', 'resilience'],
    ),
    Affirmation(
      text: 'Gratitude is a practice. It gets easier with time.',
      category: AffirmationCategories.gratitude,
      tags: ['practice', 'habit'],
    ),
    Affirmation(
      text: 'Even the smallest good thing is worth celebrating.',
      category: AffirmationCategories.gratitude,
      tags: ['celebration', 'joy'],
    ),
    Affirmation(
      text: 'Your breath, your heartbeat, your existence—these are gifts.',
      category: AffirmationCategories.gratitude,
      tags: ['life', 'presence'],
    ),
    Affirmation(
      text: 'Gratitude is not about having everything. It is about appreciating what you have.',
      category: AffirmationCategories.gratitude,
      tags: ['appreciation', 'perspective'],
    ),
    Affirmation(
      text: 'Today, find three things you are grateful for.',
      category: AffirmationCategories.gratitude,
      tags: ['practice', 'mindfulness'],
    ),

    // General (101+)
    Affirmation(
      text: 'You are not alone in this. Many have felt what you are feeling and found their way through.',
      category: AffirmationCategories.general,
      tags: ['connection', 'hope'],
    ),
    Affirmation(
      text: 'This too shall pass. Nothing is permanent, including this pain.',
      category: AffirmationCategories.general,
      tags: ['impermanence', 'hope'],
    ),
    Affirmation(
      text: 'You are braver than you believe, stronger than you seem, and loved more than you know.',
      category: AffirmationCategories.general,
      tags: ['bravery', 'love'],
    ),
    Affirmation(
      text: 'It is okay to have bad days. They do not make you a bad person.',
      category: AffirmationCategories.general,
      tags: ['acceptance', 'permission'],
    ),
    Affirmation(
      text: 'You are doing better than you think you are.',
      category: AffirmationCategories.general,
      tags: ['perspective', 'encouragement'],
    ),
    Affirmation(
      text: 'Tomorrow is a new day. A fresh start. A chance to begin again.',
      category: AffirmationCategories.general,
      tags: ['hope', 'fresh-start'],
    ),
    Affirmation(
      text: 'You do not have to have everything figured out. Just take the next step.',
      category: AffirmationCategories.general,
      tags: ['patience', 'progress'],
    ),
    Affirmation(
      text: 'There is hope, even when your mind says there is not.',
      category: AffirmationCategories.general,
      tags: ['hope', 'truth'],
    ),
    Affirmation(
      text: 'Your story is not over. Keep turning the pages.',
      category: AffirmationCategories.general,
      tags: ['hope', 'future'],
    ),
    Affirmation(
      text: 'You are allowed to take up space, to exist, to be here.',
      category: AffirmationCategories.general,
      tags: ['presence', 'permission'],
    ),
    Affirmation(
      text: 'Better days are coming. Hold on.',
      category: AffirmationCategories.general,
      tags: ['hope', 'future'],
    ),
    Affirmation(
      text: 'You matter. Your life matters. You are important.',
      category: AffirmationCategories.general,
      tags: ['worth', 'importance'],
    ),
    Affirmation(
      text: 'Even the smallest step forward is still progress.',
      category: AffirmationCategories.general,
      tags: ['progress', 'encouragement'],
    ),
    Affirmation(
      text: 'You are stronger than the storm you are walking through.',
      category: AffirmationCategories.general,
      tags: ['strength', 'resilience'],
    ),
    Affirmation(
      text: 'It is okay to ask for help. It is a sign of strength, not weakness.',
      category: AffirmationCategories.general,
      tags: ['help', 'strength'],
    ),
    Affirmation(
      text: 'Your feelings are valid, even if they are difficult.',
      category: AffirmationCategories.general,
      tags: ['validation', 'feelings'],
    ),
    Affirmation(
      text: 'There is no shame in struggling. We all struggle sometimes.',
      category: AffirmationCategories.general,
      tags: ['acceptance', 'normalizing'],
    ),
    Affirmation(
      text: 'You are exactly where you need to be right now.',
      category: AffirmationCategories.general,
      tags: ['presence', 'acceptance'],
    ),
    Affirmation(
      text: 'The world is better with you in it.',
      category: AffirmationCategories.general,
      tags: ['worth', 'value'],
    ),
    Affirmation(
      text: 'Keep going. Not because you have to, but because you choose to.',
      category: AffirmationCategories.general,
      tags: ['choice', 'persistence'],
    ),
  ];

  /// Get affirmations by category
  static List<Affirmation> getByCategory(String category) {
    return allAffirmations
        .where((a) => a.category == category)
        .toList();
  }

  /// Get random affirmation
  static Affirmation getRandom() {
    final index = Random().nextInt(allAffirmations.length);
    return allAffirmations[index];
  }

  /// Get daily affirmation based on current date
  static Affirmation getDailyAffirmation() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % allAffirmations.length;
    return allAffirmations[index];
  }
}
