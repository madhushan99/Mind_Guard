import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class DataService {
  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  // ── Stress Logs ──────────────────────────────────────────────

  Future<void> saveStressLog(StressLogModel log) async {
    await _supabase.from('stress_logs').insert(log.toMap());
  }

  Future<List<StressLogModel>> getStressLogs() async {
    final response = await _supabase
        .from('stress_logs')
        .select()
        .eq('user_id', _userId ?? '')
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => StressLogModel.fromMap(item))
        .toList();
  }

  // ── Wellness Tasks ───────────────────────────────────────────

  Future<void> saveTask(WellnessTaskModel task) async {
    final map = task.toMap();
    map['user_id'] = _userId;
    await _supabase.from('wellness_tasks').insert(map);
  }

  Future<void> updateTask(WellnessTaskModel task) async {
    await _supabase
        .from('wellness_tasks')
        .update(task.toMap())
        .eq('id', task.id);
  }

  Future<void> deleteTask(String taskId) async {
    await _supabase.from('wellness_tasks').delete().eq('id', taskId);
  }

  Future<List<WellnessTaskModel>> getTasks() async {
    final response = await _supabase
        .from('wellness_tasks')
        .select()
        .eq('user_id', _userId ?? '')
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => WellnessTaskModel.fromMap(item))
        .toList();
  }
}
