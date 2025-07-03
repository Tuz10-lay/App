import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:looninary/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  List<Task> _flatTasks = [];
  List<Task> get flatTasks => _flatTasks;

  String _searchQuery = '';
  TaskStatus? _statusFilter;
  ItemColor? _colorFilter;
  DateTime? _dateFilter;
  DateTime? get dateFilter => _dateFilter;

  List<Task> get filteredTasks {
    List<Task> filtered;

    if (_searchQuery.isEmpty &&
        _statusFilter == null &&
        _colorFilter == null &&
        _dateFilter == null) {
      return _tasks;
    } else {
      var filteredFlat = _flatTasks.where((task) {
        final titleMatch = _searchQuery.isEmpty ||
            task.title.toLowerCase().contains(_searchQuery.toLowerCase());
        final statusMatch =
            _statusFilter == null || task.taskStatus == _statusFilter;
        final colorMatch =
            _colorFilter == null || task.color == _colorFilter;
        final dateMatch = _dateFilter == null ||
            (task.startDate != null &&
                DateUtils.isSameDay(task.startDate, _dateFilter)) ||
            (task.dueDate != null &&
                DateUtils.isSameDay(task.dueDate, _dateFilter));

        return titleMatch && statusMatch && colorMatch && dateMatch;
      }).toList();

      final Set<String> includedIds = Set.from(filteredFlat.map((t) => t.id));
      for (final task in filteredFlat) {
        var parentId = task.parentId;
        while (parentId != null) {
          if (includedIds.add(parentId)) {
            final parentTask =
                _flatTasks.firstWhere((t) => t.id == parentId, orElse: () => task);
            parentId = parentTask.parentId;
          } else {
            break;
          }
        }
      }
      filtered =
          _flatTasks.where((task) => includedIds.contains(task.id)).toList();
    }
    return _buildTreeFromFiltered(filtered);
  }

  final Set<String> _expandedTaskIds = {};
  UnmodifiableSetView<String> get expandedTaskIds =>
      UnmodifiableSetView(_expandedTaskIds);

  final _supabase = Supabase.instance.client;

  TaskController() {
    fetchTasks();
  }

  List<Task> _buildTreeFromFiltered(List<Task> filteredTasks) {
    final Map<String, Task> taskMap = {
      for (var task in filteredTasks) task.id: task.copyWith(children: [])
    };
    final List<Task> topLevelTasks = [];

    for (final task in filteredTasks) {
      if (task.parentId != null && taskMap.containsKey(task.parentId)) {
        taskMap[task.parentId]!.children.add(taskMap[task.id]!);
      } else {
        topLevelTasks.add(taskMap[task.id]!);
      }
    }
    return topLevelTasks;
  }

  void _structureTasks(List<Task> tasks) {
    _flatTasks = tasks;
    _tasks = _buildTreeFromFiltered(tasks);
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateStatusFilter(TaskStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void updateColorFilter(ItemColor? color) {
    _colorFilter = color;
    notifyListeners();
  }

  void updateDateFilter(DateTime? date) {
    _dateFilter = date;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    _colorFilter = null;
    _dateFilter = null;
    notifyListeners();
  }

  void toggleTaskExpansion(String taskId) {
    if (_expandedTaskIds.contains(taskId)) {
      _expandedTaskIds.remove(taskId);
    } else {
      _expandedTaskIds.add(taskId);
    }
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _supabase.from('tasks').select().order('created_at');
      final List<Task> allTasks =
          response.map<Task>((data) => Task.fromJson(data)).toList();
      _structureTasks(allTasks);
    } catch (e, s) {
      logger.e('Error fetching tasks', error: e, stackTrace: s);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Map<String, dynamic> taskData) async {
    try {
      final response = await _supabase.from('tasks').insert(taskData).select();
      final newTask = Task.fromJson(response.first);
      _flatTasks.add(newTask);
      _structureTasks(_flatTasks);
      notifyListeners();
    } catch (e, s) {
      logger.e('Error adding task', error: e, stackTrace: s);
    }
  }
  
  // --- NEW: Method to cycle through task statuses ---
  Future<void> cycleTaskStatus(Task task) async {
    TaskStatus nextStatus;
    switch (task.taskStatus) {
      case TaskStatus.notStarted:
        nextStatus = TaskStatus.inProgress;
        break;
      case TaskStatus.inProgress:
        nextStatus = TaskStatus.completed;
        break;
      case TaskStatus.completed:
        nextStatus = TaskStatus.notStarted;
        break;
      case TaskStatus.blocked:
        // Blocked tasks can only be changed via the edit dialog
        return;
    }
    await updateTask(task.id, {'status': nextStatus.toDbValue()});
  }

  // --- NEW: Recursive check to auto-complete parent tasks ---
  Future<void> _checkAndCompleteParent(String taskId) async {
    final task = _flatTasks.firstWhere((t) => t.id == taskId);
    final parentId = task.parentId;

    if (parentId == null) return; // No parent, nothing to do

    final siblings = _flatTasks.where((t) => t.parentId == parentId).toList();
    if (siblings.isEmpty) return;

    final allChildrenAreComplete =
        siblings.every((sibling) => sibling.taskStatus == TaskStatus.completed);

    if (allChildrenAreComplete) {
      // This recursive call will bubble up the tree
      await updateTask(parentId, {'status': TaskStatus.completed.toDbValue()});
    }
  }

  Future<void> updateTask(String id, Map<String, dynamic> taskData) async {
    final originalTasks = List<Task>.from(_flatTasks);
    final taskToUpdate = _flatTasks.firstWhere((t) => t.id == id);
    
    // Determine if the status is changing to 'Completed'
    final newStatusString = taskData['status'];
    bool isCompleting = newStatusString == TaskStatus.completed.toDbValue();

    final updatedTask = taskToUpdate.copyWith(
      title: taskData['title'],
      content: taskData['content'],
      parentId: taskData.containsKey('parent_id') ? taskData['parent_id'] : null,
      color: taskData['color'] != null
          ? ItemColor.values.byName(taskData['color'])
          : null,
      taskStatus: newStatusString != null
          ? TaskStatus.values.firstWhere((e) => e.toDbValue() == newStatusString,
              orElse: () => taskToUpdate.taskStatus)
          : null,
      startDate: taskData['start_date'] != null
          ? DateTime.parse(taskData['start_date'])
          : taskToUpdate.startDate,
      dueDate: taskData['due_date'] != null
          ? DateTime.parse(taskData['due_date'])
          : taskToUpdate.dueDate,
    );

    final newFlatList = _flatTasks.map((t) => t.id == id ? updatedTask : t).toList();
    _structureTasks(newFlatList);
    notifyListeners();

    try {
      await _supabase.from('tasks').update(taskData).eq('id', id);
      // If the task was just completed, check its parent
      if (isCompleting) {
        await _checkAndCompleteParent(id);
      }
    } catch (e, s) {
      logger.e("Failed to update task. Reverting UI.", error: e, stackTrace: s);
      _structureTasks(originalTasks);
      notifyListeners();
    }
  }

  Future<void> toggleHibernate(String id, bool isHibernated) async {

    final originalTasks = List<Task>.from(_flatTasks);

    final Set<String> allIdsToUpdate = {id};
    final List<String> queue = [id];
    while (queue.isNotEmpty) {
      final currentId = queue.removeAt(0);
      final children = _flatTasks.where((t) => t.parentId == currentId);
      for (final child in children) {
        allIdsToUpdate.add(child.id);
        queue.add(child.id);
      }
    }

    final newFlatList = _flatTasks.map((task) {
      if (allIdsToUpdate.contains(task.id)) {
        return task.copyWith(isHibernated: isHibernated);
      }
      return task;
    }).toList();

    _structureTasks(newFlatList);
    if (isHibernated) {
      _expandedTaskIds.remove(id);
    }
    notifyListeners();

    try {
      await _supabase
          .from('tasks')
          .update({'is_hibernated': isHibernated})
          .inFilter('id', allIdsToUpdate.toList());
    } catch (e, s) {
      logger.e("Failed to hibernate task(s). Reverting UI.",
          error: e, stackTrace: s);
      _structureTasks(originalTasks);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    final originalTasks = List<Task>.from(_flatTasks);

    final Set<String> allIdsToRemove = {id};
    final List<String> queue = [id];
    while (queue.isNotEmpty) {
      final currentId = queue.removeAt(0);
      final children = _flatTasks.where((t) => t.parentId == currentId);
      for (final child in children) {
        allIdsToRemove.add(child.id);
        queue.add(child.id);
      }
    }

    final newFlatList =
        _flatTasks.where((task) => !allIdsToRemove.contains(task.id)).toList();
    _structureTasks(newFlatList);
    notifyListeners();

    try {
      await _supabase.from('tasks').delete().eq('id', id);
    } catch (e, s) {
      logger.e('Error deleting task. Reverting UI', error: e, stackTrace: s);
      _structureTasks(originalTasks);
      notifyListeners();
    }
  }
}
