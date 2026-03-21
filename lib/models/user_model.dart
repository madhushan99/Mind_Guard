import 'base_model.dart';

// INHERITANCE — UserModel extends BaseModel
class UserModel extends BaseModel {
  // ENCAPSULATION — private fields with getters
  String _name;
  String _email;
  int _age;
  String _occupation;

  UserModel({
    required super.id,
    required super.createdAt,
    required String name,
    required String email,
    required int age,
    required String occupation,
  })  : _name = name,
        _email = email,
        _age = age,
        _occupation = occupation;

  // Getters (controlled access to private fields)
  String get name => _name;
  String get email => _email;
  int get age => _age;
  String get occupation => _occupation;

  // Setters with validation (encapsulation)
  set name(String value) {
    if (value.trim().isEmpty) throw Exception('Name cannot be empty');
    _name = value.trim();
  }

  set age(int value) {
    if (value < 1 || value > 120) throw Exception('Invalid age');
    _age = value;
  }

  set occupation(String value) {
    _occupation = value.trim();
  }

  // POLYMORPHISM — overriding modelType from BaseModel
  @override
  String get modelType => 'UserModel';

  // POLYMORPHISM — overriding toMap from BaseModel
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': _name,
      'email': _email,
      'age': _age,
      'occupation': _occupation,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create UserModel from Supabase data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
      occupation: map['occupation'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
