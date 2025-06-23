import 'package:flutter/material.dart';
import 'package:looninary/features/home/controllers/task_controller.dart';
import 'package:looninary/features/home/views/task_edit_dialog.dart';
import 'package:provider/provider.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:flutter_html/flutter_html.dart';

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
      } else {
        // Update existing task
        _taskController.updateTask(task.id, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _taskController,
      child: Scaffold(
        body: Consumer<TaskController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.error != null) {
              return Center(child: Text(controller.error!));
            }
            if (controller.tasks.isEmpty) {
              return const Center(child: Text('No tasks yet. Add one!'));
            }
            
            return ListView.builder(
              itemCount: controller.tasks.length,
              itemBuilder: (context, index) {
                final task = controller.tasks[index];
                return Card(
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: 
                      (task.content != null && task.content!.isNotEmpty)
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Html(
                                data: task.content,
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(14.0),
                                    color: Colors.black,
                                  ),
                                },
                              ),
                            )
                          : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(task: task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Show a confirmation dialog before deleting
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: const Text('Are you sure?'),
                                      content: Text('Do you want to delete "${task.title}"?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('No')),
                                        TextButton(onPressed: () {
                                            _taskController.deleteTask(task.id);
                                            Navigator.of(ctx).pop();
                                        }, child: const Text('Yes')),
                                      ],
                                    ));
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showEditDialog(),
          child: const Icon(Icons.add),
          tooltip: 'Add Task',
        ),
      ),
    );
  }
}
