import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

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

  Future<StressLogModel?> getTodayScreenTimeLog() async {
    final logs = await getStressLogs();

    final now = DateTime.now();

    try {
      return logs.firstWhere(
        (log) =>
            log.createdAt.year == now.year &&
            log.createdAt.month == now.month &&
            log.createdAt.day == now.day,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveScreenTime(double screenHours) async {
    final userId = _userId;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final log = StressLogModel(
      id: '',
      userId: userId,
      sleepHours: 0,
      workHours: 0,
      screenTime: screenHours,
      exerciseMins: 0,
      mood: Mood.neutral,
      stressScore: 0,
      notes: 'Screen Time Update',
      createdAt: DateTime.now(),
    );

    await saveStressLog(log);
  }

  Future<List<int>> getWeeklyScreenTimeMinutes() async {
    final logs = await getStressLogs();
    final now = DateTime.now();

    final List<int> weekly = List.filled(7, 0);

    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: 6 - i));

      final dayLogs = logs.where(
        (log) =>
            log.createdAt.year == day.year &&
            log.createdAt.month == day.month &&
            log.createdAt.day == day.day,
      );

      double totalHours = 0;
      for (final log in dayLogs) {
        totalHours += log.screenTime;
      }

      weekly[i] = (totalHours * 60).round();
    }

    return weekly;
  }

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