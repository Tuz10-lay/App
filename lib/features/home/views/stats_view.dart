import 'package:flutter/material.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:looninary/features/home/controllers/task_controller.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:looninary/core/theme/app_colors.dart';

class Achievement {
  final String name;
  final IconData icon;
  final int requiredTasks;
  final Color color;

  Achievement({
    required this.name,
    required this.icon,
    required this.requiredTasks,
    required this.color,
  });
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  static final List<Achievement> achievements = [
    Achievement(name: 'Bronze', icon: Icons.shield_outlined, requiredTasks: 0, color: const Color(0xFFCD7F32)),
    Achievement(name: 'Silver', icon: Icons.shield, requiredTasks: 10, color: const Color(0xFFC0C0C0)),
    Achievement(name: 'Gold', icon: Icons.military_tech_outlined, requiredTasks: 25, color: const Color(0xFFFFD700)),
    Achievement(name: 'Platinum', icon: Icons.military_tech, requiredTasks: 50, color: const Color(0xFFE5E4E2)),
    Achievement(name: 'Diamond', icon: Icons.diamond_outlined, requiredTasks: 100, color: const Color(0xFFB9F2FF)),
    Achievement(name: 'Master', icon: Icons.workspace_premium, requiredTasks: 250, color: const Color(0xFF9B30FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, controller, child) {
        if (controller.isLoading && controller.flatTasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final allTasks = controller.flatTasks;
        final totalTasks = allTasks.length;
        final completedTasks = allTasks.where((t) => t.taskStatus == TaskStatus.completed).length;
        final inProgressTasks = allTasks.where((t) => t.taskStatus == TaskStatus.inProgress).length;
        final notStartedTasks = allTasks.where((t) => t.taskStatus == TaskStatus.notStarted).length;
        final blockedTasks = allTasks.where((t) => t.taskStatus == TaskStatus.blocked).length;
        final tasksLeft = totalTasks - completedTasks;

        return RefreshIndicator(
          onRefresh: () => controller.fetchTasks(),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildUserInfo(),
              const SizedBox(height: 24),
              _buildOverallProgressCard(
                completed: completedTasks,
                left: tasksLeft,
                total: totalTasks,
              ),
              const SizedBox(height: 24),
              _buildAchievementsSection(completedTasks: completedTasks),
              const SizedBox(height: 24),
              _buildStatusBreakdownCard(
                total: totalTasks,
                completed: completedTasks,
                inProgress: inProgressTasks,
                notStarted: notStartedTasks,
                blocked: blockedTasks,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserInfo() {
    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? 'anonymous@user.com';
    return Builder(builder: (context) {
      final theme = Theme.of(context);
      return Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(Icons.person, size: 30, color: theme.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back,', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              Text(userEmail, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildOverallProgressCard({required int completed, required int left, required int total}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _StatProgressIndicator(title: 'Tasks Completed', value: completed, total: total, height: 12, color: AppColors.green),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatCounter(count: total, label: 'Created'),
                _StatCounter(count: completed, label: 'Done'),
                _StatCounter(count: left, label: 'Left'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection({required int completedTasks}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(builder: (context) {
          return Text(
            'Achievements',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          );
        }),
        const SizedBox(height: 12),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: achievements.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            final isUnlocked = completedTasks >= achievement.requiredTasks;
            return _AchievementCard(achievement: achievement, isUnlocked: isUnlocked);
          },
        ),
      ],
    );
  }

  Widget _buildStatusBreakdownCard({required int total, required int completed, required int inProgress, required int notStarted, required int blocked}) {
    return Builder(builder: (context) {
      final theme = Theme.of(context);
      return Card(
        elevation: 0,
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status Breakdown', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _StatProgressIndicator(title: 'Completed', value: completed, total: total, color: AppColors.green),
              const SizedBox(height: 16),
              _StatProgressIndicator(title: 'In Progress', value: inProgress, total: total, color: AppColors.blue),
              const SizedBox(height: 16),
              _StatProgressIndicator(title: 'Not Started', value: notStarted, total: total, color: AppColors.mSubtext0),
              const SizedBox(height: 16),
              _StatProgressIndicator(title: 'Blocked', value: blocked, total: total, color: AppColors.maroon),
            ],
          ),
        ),
      );
    });
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  const _AchievementCard({required this.achievement, required this.isUnlocked});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isUnlocked ? achievement.color : Colors.grey.shade700;
    final textColor = isUnlocked ? theme.textTheme.bodyLarge?.color : Colors.grey.shade500;
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.5,
      child: Card(
        elevation: isUnlocked ? 2 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(achievement.icon, size: 32, color: color),
                    const SizedBox(height: 8),
                    Text(achievement.name, style: theme.textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${achievement.requiredTasks} Tasks', style: theme.textTheme.bodySmall?.copyWith(color: textColor)),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0, top: 0, bottom: 0, width: 6,
              child: Container(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatProgressIndicator extends StatelessWidget {
  final String title;
  final int value;
  final int total;
  final double height;
  final Color color;
  const _StatProgressIndicator({required this.title, required this.value, required this.total, this.height = 8.0, this.color = Colors.blue});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = total > 0 ? value / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.bodyLarge),
            Text('$value / $total', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          minHeight: height,
          borderRadius: BorderRadius.circular(height / 2),
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}

class _StatCounter extends StatelessWidget {
  final int count;
  final String label;
  const _StatCounter({required this.count, required this.label});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(count.toString(), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
