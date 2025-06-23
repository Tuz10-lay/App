import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:looninary/core/models/task_model.dart';

class TaskService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _tableName = 'tasks';

  // Fetch all tasks for the current user
  Future<List<Task>> getTasks() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthException('User is not authenticated.');

    final response = await _client.from(_tableName).select().eq('user_id', userId).order('created_at', ascending: false);
    
    final data = response as List<dynamic>;
    return data.map((json) => Task.fromJson(json)).toList();
  }

  // Add a new task
  Future<Task> addTask(Map<String, dynamic> taskData) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthException('User is not authenticated.');
    
    // Add user_id to the task data before inserting
    taskData['user_id'] = userId;

    final response = await _client.from(_tableName).insert(taskData).select().single();
    
    return Task.fromJson(response);
  }

  // Update an existing task
  Future<Task> updateTask(String taskId, Map<String, dynamic> taskData) async {
    final response = await _client.from(_tableName).update(taskData).eq('id', taskId).select().single();

    return Task.fromJson(response);
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _client.from(_tableName).delete().eq('id', taskId);
  }
}
