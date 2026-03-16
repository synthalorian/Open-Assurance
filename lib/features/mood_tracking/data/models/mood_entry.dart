import 'package:hive/hive.dart';

/// Model for a mood entry
@HiveType(typeId: 1)
class MoodEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int moodLevel; // 0-4 (0=terrible, 4=great)

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String? note;

  @HiveField(4)
  final String moodLabel;

  @HiveField(5)
  final List<String>? tags;

  MoodEntry({
    required this.id,
    required this.moodLevel,
    required this.timestamp,
    this.note,
    required this.moodLabel,
    this.tags,
  });

  MoodEntry copyWith({
    String? id,
    int? moodLevel,
    DateTime? timestamp,
    String? note,
    String? moodLabel,
    List<String>? tags,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      moodLevel: moodLevel ?? this.moodLevel,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
      moodLabel: moodLabel ?? this.moodLabel,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() =>
      'MoodEntry(id: $id, moodLevel: $moodLevel, timestamp: $timestamp)';
}

/// Simple adapter for MoodEntry
class MoodEntryAdapter extends TypeAdapter<MoodEntry> {
  @override
  final int typeId = 1;

  @override
  MoodEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodEntry(
      id: fields[0] as String,
      moodLevel: fields[1] as int,
      timestamp: fields[2] as DateTime,
      note: fields[3] as String?,
      moodLabel: fields[4] as String,
      tags: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MoodEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.moodLevel)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.moodLabel)
      ..writeByte(5)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Mood levels with labels and emojis
class MoodLevels {
  static const int terrible = 0;
  static const int sad = 1;
  static const int anxious = 2;
  static const int neutral = 3;
  static const int great = 4;

  static const Map<int, String> labels = {
    terrible: 'Struggling',
    sad: 'Sad',
    anxious: 'Anxious',
    neutral: 'Okay',
    great: 'Great',
  };

  static const Map<int, String> emojis = {
    terrible: '😢',
    sad: '😔',
    anxious: '😰',
    neutral: '😐',
    great: '😊',
  };

  static String getLabel(int level) => labels[level] ?? 'Unknown';
  static String getEmoji(int level) => emojis[level] ?? '🤔';
}
