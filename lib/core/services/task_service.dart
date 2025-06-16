import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:looninary/core/services/task_service.dart';
import 'package:looninary/core/models/task_model.dart';

class TaskService {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch all user's task
  Future<List<Task>> getTasks() async {
    final response = await _client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    // Since Supabase return a List<dynamic>, we need to cast i
    final List<dynamic> data = response as List<dynamic>;

    // Map list of JSON objects to a list of Task objects
    return data
        .map((json) => Task.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> createTask({required String title, String? content}) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception("User must be logged in to create a task");
    }

    final taskMap = {'title': title, 'content': content, 'user_id': user.id};

    await _client.from('tasks').insert(taskMap);
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    await _client
        .from('tasks')
        .update({'status': newStatus.name})
        .eq('id', taskId);
  }

  Future<void> deleteTask(String taskId) async {
    await _client.from('tasks').delete().eq('id', taskId);
  }
}
