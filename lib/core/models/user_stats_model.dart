
class UserStats {
  final String userId;
  final int tasksCompleted;
  final int currentStreak;

  UserStats({
    required this.userId,
    required this.tasksCompleted,
    required this.currentStreak,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['user_id'],
      tasksCompleted: json['tasks_completed'] ?? 0,
      currentStreak: json['current_streak'] ?? 0,
    );
  }

  // A default/empty state for when data is loading or not found
  factory UserStats.empty(String userId) {
    return UserStats(
      userId: userId,
      tasksCompleted: 0,
      currentStreak: 0,
    );
  }
}
