import 'package:flutter/material.dart';
import 'package:looninary/features/home/controllers/task_controller.dart';
import 'package:looninary/features/home/views/task_edit_dialog.dart';
import 'package:provider/provider.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:looninary/features/home/views/dashboard_view.dart';
import 'package:looninary/core/theme/theme_swithcher_button.dart';

class AllTasksView extends StatefulWidget {
  const AllTasksView({super.key});

  @override
  State<AllTasksView> createState() => _AllTasksViewState();
}

class _AllTasksViewState extends State<AllTasksView> {
  late final TaskController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TaskController();
    _taskController.fetchTasks();
  }

  void _showEditDialog({Task? task}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => TaskEditDialog(task: task),
    );

    if (result != null) {
      if (task == null) {
        // Add new task
        _taskController.addTask(result);
        NotificationService().add('Task "${result['title']}" has been created!');
      } else {
        // Update existing task
        _taskController.updateTask(task.id, result);
        NotificationService().add('Task "${result['title']}" has been updated!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ChangeNotifierProvider.value(
      value: _taskController,
      child: Scaffold(
        body: Consumer<TaskController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.error != null) {
              return Center(child: Text(controller.error!, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)));
            }
            if (controller.tasks.isEmpty) {
              return Center(child: Text('No tasks yet. Add one!', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)));
            }
            return ListView.builder(
              itemCount: controller.tasks.length,
              itemBuilder: (context, index) {
                final task = controller.tasks[index];
                return Card(
                  color: colorScheme.surface,
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(task.title, style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
                    subtitle: (task.content != null && task.content!.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Html(
                              data: task.content,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(14.0),
                                  color: colorScheme.onSurface,
                                ),
                              },
                            ),
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: colorScheme.primary),
                          onPressed: () => _showEditDialog(task: task),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: colorScheme.error),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Are you sure?', style: textTheme.titleMedium?.copyWith(color: colorScheme.onBackground)),
                                content: Text('Do you want to delete "${task.title}"?', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: Text('No', style: textTheme.labelLarge?.copyWith(color: colorScheme.primary)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _taskController.deleteTask(task.id);
                                      NotificationService().add('Task "${task.title}" has been deleted!');
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text('Yes', style: textTheme.labelLarge?.copyWith(color: colorScheme.error)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _showEditDialog(),
              backgroundColor: colorScheme.primary,
              child: Icon(Icons.add, color: colorScheme.onPrimary),
              tooltip: 'Add Task',
            ),
            const SizedBox(height: 16),
            const ThemeSwitcherButton(),
          ],
        ),
      ),
    );
  }
}
