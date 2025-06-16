/// A safe way to get an enum value by its name, ignoring case, because i messed up the db
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

enum TaskPriority { low, medium, high, urgent }

enum TaskType { normal, pomodoro }

class Task {
  final String id;
  final String userId;
  final DateTime createdAt;

  String title;
  String? content;

  TaskType taskType;
  TaskStatus taskStatus;
  TaskPriority taskPriority;

  String color;

  DateTime? startDate;
  DateTime? dueDate;

  // Pomodoro fields
  int? pomodoroDurationMinutes;
  int? pomodoroCyclesCompleted;

  // Hierarchy
  String? parentId;

  // Relational data (Populated after fetching)
  List<Task> children;
  List<Tag> tags;
  double progress;

  Task({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.title,
    this.content,
    this.taskType = TaskType.normal,
    this.taskStatus = TaskStatus.notStarted,
    this.taskPriority = TaskPriority.medium,
    this.color = '#FFC0CB',
    this.startDate,
    this.dueDate,
    this.pomodoroDurationMinutes,
    this.pomodoroCyclesCompleted,
    this.parentId,
    this.children = const [],
    this.tags = const [],
    this.progress = 0.0,
  });

factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      title: json['title'],
      content: json['content'],
      
      taskType: TaskType.values.byNameIgnoreCase(
        json['task_type'] ?? 'normal',
        orElse: TaskType.normal,
      ),
      taskStatus: TaskStatus.values.byNameIgnoreCase(
        json['status'] ?? 'notStarted',
        orElse: TaskStatus.notStarted,
      ),
      taskPriority: TaskPriority.values.byNameIgnoreCase(
        json['priority'] ?? 'medium',
        orElse: TaskPriority.medium,
      ),
      
      color: json['color'] ?? '#FFC0CB',
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
      'task_status': taskStatus.name,
      'task_priority': taskPriority.name,
      'color': color,
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
  String? color;

  Tag({required this.id, required this.name, this.color});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}
