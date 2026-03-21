import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Singleton pattern (OOP concept)
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _supabase = Supabase.instance.client;

  // Get current logged in user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if someone is logged in
  bool get isLoggedIn => currentUser != null;

  // REGISTER
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // LOGIN
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // LOGOUT
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  // SAVE PROFILE
  Future<void> saveProfile({
    required String name,
    required int age,
    required String occupation,
  }) async {
    final userId = currentUser?.id;
    if (userId == null) return;

    await _supabase.from('profiles').upsert({
      'id': userId,
      'name': name,
      'age': age,
      'occupation': occupation,
    });
  }

  // GET PROFILE
  Future<Map<String, dynamic>?> getProfile() async {
    final userId = currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select('id, name, age, occupation, created_at')
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }
}
