// ABSTRACTION — abstract class that all models inherit from
abstract class BaseModel {
  final String id;
  final DateTime createdAt;

  BaseModel({
    required this.id,
    required this.createdAt,
  });

  // Every model must implement this (abstraction)
  Map<String, dynamic> toMap();

  // Every model must implement this (abstraction)
  String get modelType;

  @override
  String toString() {
    return '$modelType(id: $id, createdAt: $createdAt)';
  }
}
