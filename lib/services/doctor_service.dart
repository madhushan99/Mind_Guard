import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/doctor_model.dart';

class DoctorService {
  final _supabase = Supabase.instance.client;

  Future<List<DoctorModel>> getDoctors() async {
    final response = await _supabase
        .from('doctors')
        .select()
        .order('id', ascending: true);

    return (response as List)
        .map((item) => DoctorModel.fromMap(item))
        .toList();
  }
}