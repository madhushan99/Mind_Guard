import 'base_model.dart';

// Enum for mood (OOP concept — custom type)
enum Mood { happy, neutral, stressed, sad }

// INHERITANCE — StressLogModel extends BaseModel
class StressLogModel extends BaseModel {
  final String userId;
  final double sleepHours;
  final double workHours;
  final double screenTime;
  final double exerciseMins;
  final Mood mood;
  final int stressScore;
  final String notes;

  StressLogModel({
    required super.id,
    required super.createdAt,
    required this.userId,
    required this.sleepHours,
    required this.workHours,
    required this.screenTime,
    required this.exerciseMins,
    required this.mood,
    required this.stressScore,
    required this.notes,
  });

  // POLYMORPHISM — overriding modelType
  @override
  String get modelType => 'StressLogModel';

  // POLYMORPHISM — overriding toMap
  @override
  @override
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'sleep_hours': sleepHours,
      'work_hours': workHours,
      'screen_time': screenTime,
      'exercise_mins': exerciseMins,
      'mood': mood.name,
      'stress_score': stressScore,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory StressLogModel.fromMap(Map<String, dynamic> map) {
    return StressLogModel(
      id: map['id'],
      userId: map['user_id'],
      sleepHours: (map['sleep_hours'] as num).toDouble(),
      workHours: (map['work_hours'] as num).toDouble(),
      screenTime: (map['screen_time'] as num).toDouble(),
      exerciseMins: (map['exercise_mins'] as num).toDouble(),
      mood: Mood.values.byName(map['mood']),
      stressScore: map['stress_score'],
      notes: map['notes'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Computed property — stress level label
  String get stressLevel {
    if (stressScore <= 13) return 'Low';
    if (stressScore <= 26) return 'Moderate';
    return 'High';
  }

  // Computed property — mood emoji
  String get moodEmoji {
    switch (mood) {
      case Mood.happy:
        return '😊';
      case Mood.neutral:
        return '😐';
      case Mood.stressed:
        return '😤';
      case Mood.sad:
        return '😢';
    }
  }
}
