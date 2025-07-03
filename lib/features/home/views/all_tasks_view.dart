import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:looninary/features/home/controllers/task_controller.dart';
import 'package:looninary/features/home/views/task_edit_dialog.dart';
import 'package:provider/provider.dart';

class AllTasksView extends StatelessWidget {
  const AllTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskController(),
      child: Consumer<TaskController>(
        builder: (context, controller, child) {
          void showEditDialog({Task? task}) async {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (ctx) => TaskEditDialog(
                task: task,
                allTasks: controller.flatTasks,
              ),
            );

            if (result != null) {
              if (task == null) {
                controller.addTask(result);
              } else {
                controller.updateTask(task.id, result);
              }
            }
          }

          return Scaffold(
            body: _buildBody(context, controller, showEditDialog),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showEditDialog(),
              tooltip: 'Add Task',
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TaskController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.dateFilter ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != controller.dateFilter) {
      controller.updateDateFilter(picked);
    }
  }

  Widget _buildBody(BuildContext context, TaskController controller,
      Function({Task? task}) showEditDialog) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final tasksToDisplay = controller.filteredTasks;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search by Title',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => controller.updateSearchQuery(value),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskStatus?>(
                      hint: const Text('Status'),
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('Search By Status - All')),
                        ...TaskStatus.values.map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.toDbValue()),
                            )),
                      ],
                      onChanged: (value) =>
                          controller.updateStatusFilter(value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<ItemColor?>(
                      hint: const Text('Color'),
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('Search by Color - All')),
                        ...ItemColor.values.map((color) => DropdownMenuItem(
                              value: color,
                              child: Row(
                                children: [
                                  Icon(Icons.circle,
                                      color: color.toColor(context), size: 14),
                                  const SizedBox(width: 8),
                                  Text(color.name),
                                ],
                              ),
                            )),
                      ],
                      onChanged: (value) =>
                          controller.updateColorFilter(value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        controller.dateFilter == null
                            ? 'Filter by Date'
                            : DateFormat.yMMMd().format(controller.dateFilter!),
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => _selectDate(context, controller),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    tooltip: 'Clear All Filters',
                    onPressed: controller.clearFilters,
                    icon: const Icon(Icons.clear),
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: tasksToDisplay.isEmpty
              ? const Center(child: Text('No tasks match your search.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  itemCount: tasksToDisplay.length,
                  itemBuilder: (context, index) {
                    final task = tasksToDisplay[index];
                    return _TaskNode(
                      task: task,
                      showEditDialog: showEditDialog,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _TaskNode extends StatelessWidget {
  final Task task;
  final Function({Task? task}) showEditDialog;
  final int level;

  const _TaskNode({
    required this.task,
    required this.showEditDialog,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TaskController>(context);
    final double indentation = level * 30.0;

    final bool isExpanded = controller.expandedTaskIds.contains(task.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: indentation),
          child: _TaskCard(
            task: task,
            showEditDialog: showEditDialog,
            isExpanded: isExpanded,
          ),
        ),
        if (task.children.isNotEmpty && isExpanded)
          ...task.children.map((child) => _TaskNode(
                task: child,
                showEditDialog: showEditDialog,
                level: level + 1,
              )),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final Function({Task? task}) showEditDialog;
  final bool isExpanded;

  const _TaskCard({
    required this.task,
    required this.showEditDialog,
    required this.isExpanded,
  });

  Widget _getIconForStatus(TaskStatus status, Color iconColor) {
    IconData iconData;
    switch (status) {
      case TaskStatus.completed:
        iconData = Icons.check_circle_rounded;
        break;
      case TaskStatus.inProgress:
        iconData = Icons.hourglass_top_rounded;
        break;
      case TaskStatus.blocked:
        iconData = Icons.block_rounded;
        break;
      case TaskStatus.notStarted:
      default:
        iconData = Icons.radio_button_unchecked_rounded;
        break;
    }
    return Icon(iconData, color: iconColor);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Provider.of<TaskController>(context, listen: false);

    final stripColor = task.color.toColor(context);
    final onStripColor = task.color.onColor(context);

    final double progress = task.children.isNotEmpty
        ? task.children
                .where((c) => c.taskStatus == TaskStatus.completed)
                .length /
            task.children.length
        : 0.0;

    return Opacity(
      opacity: task.isHibernated ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(62, 12, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: task.isHibernated
                                ? Colors.grey
                                : theme.colorScheme.onSurface,
                            decoration: task.taskStatus == TaskStatus.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        if (task.content != null && task.content!.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(task.content!,
                                style: theme.textTheme.bodyMedium),
                          ),
                        Row(
                          children: [
                            if (task.startDate != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Row(children: [
                                  Icon(Icons.calendar_today,
                                      size: 14,
                                      color:
                                          theme.colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 4.0),
                                  Text(
                                      DateFormat.yMMMd()
                                          .format(task.startDate!),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: theme
                                              .colorScheme.onSurfaceVariant)),
                                ]),
                              ),
                            if (task.dueDate != null)
                              Row(children: [
                                Icon(Icons.flag,
                                    size: 14,
                                    color:
                                        theme.colorScheme.onSurfaceVariant),
                                const SizedBox(width: 4.0),
                                Text(DateFormat.yMMMd().format(task.dueDate!),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: theme
                                            .colorScheme.onSurfaceVariant)),
                              ]),
                          ],
                        ),
                        if (task.children.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${(progress * 100).toInt()}% complete',
                                  style: theme.textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(stripColor),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => showEditDialog(task: task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () => controller.deleteTask(task.id),
                      ),
                      IconButton(
                        icon: Icon(
                            task.isHibernated
                                ? Icons.bedtime
                                : Icons.bedtime_outlined,
                            size: 20),
                        onPressed: () => controller.toggleHibernate(
                            task.id, !task.isHibernated),
                      ),
                      if (task.children.isNotEmpty)
                        IconButton(
                          icon: Icon(
                              isExpanded
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_right,
                              size: 24),
                          onPressed: () =>
                              controller.toggleTaskExpansion(task.id),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 50,
              child: Container(
                color: stripColor,
                child: Center(
                    child: _getIconForStatus(task.taskStatus, onStripColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
