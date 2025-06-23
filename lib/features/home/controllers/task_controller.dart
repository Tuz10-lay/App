import 'package:flutter/material.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:looninary/core/services/task_service.dart';
import 'package:looninary/core/utils/logger.dart'; // Assuming you have a logger

class TaskController extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _tasks = await _taskService.getTasks();
    } catch (e) {
      logger.e("Failed to fetch tasks: $e");
      _error = "Failed to load tasks. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Map<String, dynamic> taskData) async {
    try {
      final newTask = await _taskService.addTask(taskData);
      _tasks.insert(0, newTask); // Add to the top of the list
      notifyListeners();
    } catch (e) {
      logger.e("Failed to add task: $e");
      // Optionally, set an error message to show in the UI
    }
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> taskData) async {
    try {
      final updatedTask = await _taskService.updateTask(taskId, taskData);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      logger.e("Failed to update task: $e");
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      // Optimistically remove from UI
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
      await _taskService.deleteTask(taskId);
    } catch (e) {
      logger.e("Failed to delete task: $e");
      // If deleting from the service fails, you might want to refetch the tasks
      // to ensure UI consistency.
      fetchTasks();
    }
  }
}
