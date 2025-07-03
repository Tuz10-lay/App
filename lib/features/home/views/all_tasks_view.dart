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
    return Consumer<TaskController>(
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
            child: const Icon(Icons.add),
          ),
        );
      },
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
    if (controller.isLoading && controller.flatTasks.isEmpty) {
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
                            value: null, child: Text('Status - All')),
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
                            value: null, child: Text('Color - All')),
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
              ? const Center(child: Text('No tasks found.'))
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
    final double indentation = level * 24.0;

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
        ? task.children.where((c) => c.taskStatus == TaskStatus.completed).length /
            task.children.length
        : 0.0;
        
    final bool isCompleted = task.taskStatus == TaskStatus.completed;
    final dateStyle = theme.textTheme.bodySmall?.copyWith(
      color: isCompleted
        ? theme.textTheme.bodySmall?.color?.withOpacity(0.6)
        : theme.textTheme.bodySmall?.color
    );

    return Opacity(
      opacity: task.isHibernated ? 0.5 : (isCompleted ? 0.7 : 1.0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => controller.cycleTaskStatus(task),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(52, 10, 8, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: task.isHibernated || isCompleted
                                  ? theme.colorScheme.onSurface.withOpacity(0.6)
                                  : theme.colorScheme.onSurface,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          if (task.content != null && task.content!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                task.content!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: isCompleted
                                      ? theme.textTheme.bodySmall?.color?.withOpacity(0.6)
                                      : theme.textTheme.bodySmall?.color
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          if (task.startDate != null || task.dueDate != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Row(
                                children: [
                                  if (task.startDate != null)
                                    Row(children: [
                                      Icon(Icons.calendar_today_outlined, size: 14, color: dateStyle?.color),
                                      const SizedBox(width: 4.0),
                                      Text(DateFormat.yMMMd().format(task.startDate!), style: dateStyle),
                                    ]),
                                  
                                  if (task.startDate != null && task.dueDate != null)
                                    const SizedBox(width: 8.0),

                                  if (task.dueDate != null)
                                    Row(children: [
                                      Icon(Icons.flag_outlined, size: 14, color: dateStyle?.color),
                                      const SizedBox(width: 4.0),
                                      Text(DateFormat.yMMMd().format(task.dueDate!), style: dateStyle),
                                    ]),
                                ],
                              ),
                            ),
                          if (task.children.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${(progress * 100).toInt()}% Complete',
                                    style: theme.textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey.shade300,
                                    valueColor: AlwaysStoppedAnimation<Color>(stripColor),
                                    minHeight: 5,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (task.children.isNotEmpty)
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(isExpanded ? Icons.arrow_drop_down : Icons.arrow_right, size: 24),
                            onPressed: () => controller.toggleTaskExpansion(task.id),
                          ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 20),
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                showEditDialog(task: task);
                                break;
                              case 'hibernate':
                                controller.toggleHibernate(task.id, !task.isHibernated);
                                break;
                              case 'delete':
                                controller.deleteTask(task.id);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(children: [Icon(Icons.edit_outlined, size: 20), SizedBox(width: 8), Text('Edit')]),
                            ),
                            PopupMenuItem<String>(
                              value: 'hibernate',
                              child: Row(children: [Icon(task.isHibernated ? Icons.bedtime : Icons.bedtime_outlined, size: 20), const SizedBox(width: 8), Text(task.isHibernated ? 'Wake Up' : 'Hibernate')]),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(children: [Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.error), const SizedBox(width: 8), Text('Delete', style: TextStyle(color: theme.colorScheme.error))]),
                            ),
                          ],
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
                width: 42,
                child: Container(
                  color: stripColor,
                  child: Center(child: _getIconForStatus(task.taskStatus, onStripColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
