import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_app/models/ProfileModel.dart';
import '../models/task_model.dart';

class TaskService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // ================= TASKS =================
  static const String taskTable = 'tasks';

  /// Get all tasks (sorted by due date)
  static Future<List<TaskModel>> getAllTasks() async {
    final data = await _supabase
        .from(taskTable)
        .select()
        .order('due_date', ascending: true);

    return (data as List)
        .map((e) => TaskModel.fromMap(e))
        .toList();
  }

  /// Get recent 5 tasks
  static Future<List<TaskModel>> getRecentTasks() async {
    final data = await _supabase
        .from(taskTable)
        .select()
        .order('due_date', ascending: false)
        .limit(5);

    return (data as List)
        .map((e) => TaskModel.fromMap(e))
        .toList();
  }

  /// Create task
  static Future<void> createTask(TaskModel task) async {
    await _supabase.from(taskTable).insert(task.toMap());
  }

  /// Update task
  static Future<void> updateTask(TaskModel task) async {
    await _supabase
        .from(taskTable)
        .update(task.toMap())
        .eq('id', task.id);
  }

  /// Delete task
  static Future<void> deleteTask(String id) async {
    await _supabase.from(taskTable).delete().eq('id', id);
  }

  // ================= PROFILES =================
  static const String profileTable = 'profiles';

  /// Get all profiles (admin + student)
  static Future<List<ProfileModel>> getProfiles() async {
    final data = await _supabase
        .from(profileTable)
        .select()
        .order('role', ascending: true);

    return (data as List)
        .map((e) => ProfileModel.fromMap(e))
        .toList();
  }
}
