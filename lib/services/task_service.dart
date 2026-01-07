import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class TaskService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String tableName = 'tasks';

  /// ✅ Get all tasks (sorted by due date)
  static Future<List<TaskModel>> getAllTasks() async {
    final data = await _supabase
        .from(tableName)
        .select()
        .order('due_date', ascending: true);

    return (data as List)
        .map((e) => TaskModel.fromMap(e))
        .toList();
  }

  /// ✅ Get recent 5 tasks (latest first)
  /// Uses due_date (SAFE option)
  static Future<List<TaskModel>> getRecentTasks() async {
    final data = await _supabase
        .from(tableName)
        .select()
        .order('due_date', ascending: false)
        .limit(5);

    return (data as List)
        .map((e) => TaskModel.fromMap(e))
        .toList();
  }

  /// ✅ Create task
  static Future<void> createTask(TaskModel task) async {
    await _supabase.from(tableName).insert(task.toMap());
  }

  /// ✅ Update task
  static Future<void> updateTask(TaskModel task) async {
    await _supabase
        .from(tableName)
        .update(task.toMap())
        .eq('id', task.id);
  }

  /// ✅ Delete task
  static Future<void> deleteTask(String id) async {
    await _supabase.from(tableName).delete().eq('id', id);
  }
}
