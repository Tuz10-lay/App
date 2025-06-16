import 'package:flutter/material.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:looninary/core/services/task_service.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = AuthController();
  final TaskService _taskService = TaskService();
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    // Fetch tasks when the widget is first created
    _tasksFuture = _taskService.getTasks();
  }

  // Method to refresh the tasks list
  void _refreshTasks() {
    setState(() {
      _tasksFuture = _taskService.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks ✨'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.signOut(context),
            tooltip: 'Log Out',
          ),
        ],
      ),
      // Use FutureBuilder to handle the loading state
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          // While waiting for data, show a loading spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If there's an error, show an error message
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }
          // If data is empty or null, show a message
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet. Create one!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // If we have data, display it in a list
          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onStatusChanged: () => _refreshTasks(), // Refresh list on change
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Method to show the dialog for adding a new task
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Whimsical Task'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Task title"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  await _taskService.createTask(title: titleController.text);
                  if (!context.mounted) return;
                  Navigator.pop(context); // Close the dialog
                  _refreshTasks(); // Refresh the list to show the new task
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}


class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Color(int.parse(task.color.substring(1, 7), radix: 16) + 0xFF000000).withOpacity(0.1);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: cardColor,
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            // Cross out completed tasks
            decoration: task.taskStatus == TaskStatus.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        // A checkbox to mark tasks as complete/incomplete
        leading: Checkbox(
          value: task.taskStatus == TaskStatus.completed,
          onChanged: (bool? value) async {
            final newStatus = value == true ? TaskStatus.completed : TaskStatus.notStarted;
            await TaskService().updateTaskStatus(task.id, newStatus);
            onStatusChanged();
          },
        ),
        trailing: Text(task.taskPriority.name, style: TextStyle(color: Colors.black54)),
      ),
    );
  }
}
