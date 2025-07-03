
import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_colors.dart';

/// A safe way to get an enum value by its name, ignoring case.
extension EnumByNameIgnoreCase<T extends Enum> on Iterable<T> {
  T byNameIgnoreCase(String name, {required T orElse}) {
    for (var value in this) {
      if (value.name.toLowerCase() == name.toLowerCase()) {
        return value;
      }
    }
    return orElse;
  }
}

enum TaskStatus { notStarted, inProgress, completed, blocked }

extension TaskStatusExtension on TaskStatus {
  String toDbValue() {
    switch (this) {
      case TaskStatus.notStarted: return 'Not Started';
      case TaskStatus.inProgress: return 'In Progress';
      case TaskStatus.completed: return 'Completed';
      case TaskStatus.blocked: return 'Blocked';
    }
  }
}

enum TaskPriority { low, medium, high, urgent }

extension TaskPriorityExtension on TaskPriority {
  String toDbValue() {
    switch (this) {
      case TaskPriority.low: return 'Low';
      case TaskPriority.medium: return 'Medium';
      case TaskPriority.high: return 'High';
      case TaskPriority.urgent: return 'Urgent';
    }
  }
}

enum TaskType { normal, pomodoro }

enum ItemColor {
  maroon,
  peach,
  yellow,
  green,
  teal,
}

extension ItemColorExtension on ItemColor {
  Color toColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case ItemColor.maroon: return isDarkMode ? AppColors.mMaroon : AppColors.maroon;
      case ItemColor.peach: return isDarkMode ? AppColors.mPeach : AppColors.peach;
      case ItemColor.yellow: return isDarkMode ? AppColors.mYellow : AppColors.yellow;
      case ItemColor.green: return isDarkMode ? AppColors.mGreen : AppColors.green;
      case ItemColor.teal: return isDarkMode ? AppColors.mTeal : AppColors.teal;
    }
  }

  Color onColor(BuildContext context) {
    final bgColor = toColor(context);
    return ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }
}

class Task {
  final String id;
  final String userId;
  final DateTime createdAt;
  final String title;
  final String? content;
  final TaskType taskType;
  final TaskStatus taskStatus;
  final TaskPriority taskPriority;
  final ItemColor color;
  final DateTime? startDate;
  final DateTime? dueDate;
  final int? pomodoroDurationMinutes;
  final int? pomodoroCyclesCompleted;
  final String? parentId;
  final List<Task> children;
  final List<Tag> tags;
  final double progress;

  Task({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.title,
    this.content,
    this.taskType = TaskType.normal,
    this.taskStatus = TaskStatus.notStarted,
    this.taskPriority = TaskPriority.medium,
    this.color = ItemColor.teal,
    this.startDate,
    this.dueDate,
    this.pomodoroDurationMinutes,
    this.pomodoroCyclesCompleted,
    this.parentId,
    this.children = const [],
    this.tags = const [],
    this.progress = 0.0,
  });

  Task copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    String? title,
    String? content,
    TaskType? taskType,
    TaskStatus? taskStatus,
    TaskPriority? taskPriority,
    ItemColor? color,
    DateTime? startDate,
    DateTime? dueDate,
    int? pomodoroDurationMinutes,
    int? pomodoroCyclesCompleted,
    String? parentId,
    List<Task>? children,
    List<Tag>? tags,
    double? progress,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      content: content ?? this.content,
      taskType: taskType ?? this.taskType,
      taskStatus: taskStatus ?? this.taskStatus,
      taskPriority: taskPriority ?? this.taskPriority,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      pomodoroDurationMinutes: pomodoroDurationMinutes ?? this.pomodoroDurationMinutes,
      pomodoroCyclesCompleted: pomodoroCyclesCompleted ?? this.pomodoroCyclesCompleted,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
      tags: tags ?? this.tags,
      progress: progress ?? this.progress,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      title: json['title'],
      content: json['content'],
      taskType: TaskType.values.byNameIgnoreCase(json['task_type'] ?? 'normal', orElse: TaskType.normal),
      taskStatus: TaskStatus.values.byNameIgnoreCase(json['status'] ?? 'Not Started', orElse: TaskStatus.notStarted),
      taskPriority: TaskPriority.values.byNameIgnoreCase(json['priority'] ?? 'medium', orElse: TaskPriority.medium),
      color: ItemColor.values.byNameIgnoreCase(json['color'] ?? 'teal', orElse: ItemColor.teal),
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      pomodoroDurationMinutes: json['pomodoro_duration_minutes'],
      pomodoroCyclesCompleted: json['pomodoro_cycles_completed'],
      parentId: json['parent_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'task_type': taskType.name,
      'status': taskStatus.toDbValue(),
      'priority': taskPriority.toDbValue(),
      'color': color.name,
      'start_date': startDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'pomodoro_duration_minutes': pomodoroDurationMinutes,
      'pomodoro_cycles_completed': pomodoroCyclesCompleted,
      'parent_id': parentId,
      'children': children.map((task) => task.toJson()).toList(),
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'progress': progress,
    };
  }
}

class Tag {
  final String id;
  final String name;
  final ItemColor color;

  Tag({required this.id, required this.name, required this.color});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      color: ItemColor.values.byNameIgnoreCase(json['color'] ?? 'teal', orElse: ItemColor.teal),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'color': color.name};
  }
}
