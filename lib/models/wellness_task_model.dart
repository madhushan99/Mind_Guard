import 'base_model.dart';

// INHERITANCE — WellnessTaskModel extends BaseModel
class WellnessTaskModel extends BaseModel {
  String _title;
  String _subtitle;
  bool _isCompleted;
  DateTime? _completedAt;

  WellnessTaskModel({
    required super.id,
    required super.createdAt,
    required String title,
    required String subtitle,
    bool isCompleted = false,
    DateTime? completedAt,
  })  : _title = title,
        _subtitle = subtitle,
        _isCompleted = isCompleted,
        _completedAt = completedAt;

  // Getters
  String get title => _title;
  String get subtitle => _subtitle;
  bool get isCompleted => _isCompleted;
  DateTime? get completedAt => _completedAt;

  // Setters with logic
  set title(String value) {
    if (value.trim().isEmpty) throw Exception('Title cannot be empty');
    _title = value.trim();
  }

  // Method to complete the task
  void complete() {
    _isCompleted = true;
    _completedAt = DateTime.now();
    _subtitle = 'Completed at ${_formattedTime(_completedAt!)}';
  }

  // Method to undo completion
  void uncomplete() {
    _isCompleted = false;
    _completedAt = null;
    _subtitle = 'Tap to mark complete';
  }

  String _formattedTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // POLYMORPHISM — overriding modelType
  @override
  String get modelType => 'WellnessTaskModel';

  // POLYMORPHISM — overriding toMap
  @override
  @override
  Map<String, dynamic> toMap() {
    return {
      'title': _title,
      'subtitle': _subtitle,
      'is_completed': _isCompleted,
      'completed_at': _completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory WellnessTaskModel.fromMap(Map<String, dynamic> map) {
    return WellnessTaskModel(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'] ?? '',
      isCompleted: map['is_completed'] ?? false,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'])
          : null,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
