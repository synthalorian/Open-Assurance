import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// Affirmation model
@HiveType(typeId: 0)
class Affirmation extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String text;
  
  @HiveField(2)
  final String category;
  
  @HiveField(3)
  final String? author;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final bool isCustom;
  
  @HiveField(6)
  final List<String> tags;

  Affirmation({
    String? id,
    required this.text,
    required this.category,
    this.author,
    DateTime? createdAt,
    this.isCustom = false,
    this.tags = const [],
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Affirmation copyWith({
    String? id,
    String? text,
    String? category,
    String? author,
    DateTime? createdAt,
    bool? isCustom,
    List<String>? tags,
  }) {
    return Affirmation(
      id: id ?? this.id,
      text: text ?? this.text,
      category: category ?? this.category,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      isCustom: isCustom ?? this.isCustom,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() => 'Affirmation(id: $id, text: $text, category: $category)';
}

/// Simple adapter for Affirmation
class AffirmationAdapter extends TypeAdapter<Affirmation> {
  @override
  final int typeId = 0;

  @override
  Affirmation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Affirmation(
      id: fields[0] as String,
      text: fields[1] as String,
      category: fields[2] as String,
      author: fields[3] as String?,
      createdAt: fields[4] as DateTime,
      isCustom: fields[5] as bool,
      tags: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Affirmation obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.author)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.isCustom)
      ..writeByte(6)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AffirmationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// Affirmation categories
class AffirmationCategories {
  static const String selfWorth = 'Self-Worth';
  static const String anxiety = 'Anxiety';
  static const String motivation = 'Motivation';
  static const String grief = 'Grief';
  static const String stress = 'Stress Relief';
  static const String relationships = 'Relationships';
  static const String healing = 'Healing';
  static const String confidence = 'Confidence';
  static const String gratitude = 'Gratitude';
  static const String general = 'General';

  static const List<String> allCategories = [
    selfWorth,
    anxiety,
    motivation,
    grief,
    stress,
    relationships,
    healing,
    confidence,
    gratitude,
    general,
  ];

  static const Map<String, String> categoryIcons = {
    selfWorth: '💎',
    anxiety: '🫂',
    motivation: '🚀',
    grief: '🕯️',
    stress: '🧘',
    relationships: '💝',
    healing: '🌱',
    confidence: '💪',
    gratitude: '🙏',
    general: '✨',
  };

  static const Map<String, String> categoryDescriptions = {
    selfWorth: 'Reminders of your inherent value',
    anxiety: 'Comfort for anxious moments',
    motivation: 'Fuel for your journey',
    grief: 'Gentle words for loss',
    stress: 'Relief when overwhelmed',
    relationships: 'Connection and love',
    healing: 'Recovery and growth',
    confidence: 'Belief in yourself',
    gratitude: 'Appreciation and joy',
    general: 'Words of hope and comfort',
  };
}
