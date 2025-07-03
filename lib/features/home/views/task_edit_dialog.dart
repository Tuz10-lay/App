import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for formatting
import 'package:looninary/core/models/task_model.dart';

class TaskEditDialog extends StatefulWidget {
  final Task? task;
  final List<Task>? allTasks;

  const TaskEditDialog({
    super.key,
    this.task,
    this.allTasks,
  });

  @override
  State<TaskEditDialog> createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _selectedParentId;
  ItemColor _selectedColor = ItemColor.teal;
  TaskStatus _selectedStatus = TaskStatus.notStarted;
  DateTime? _selectedStartDate;
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _contentController = TextEditingController(text: widget.task?.content ?? '');
    _selectedParentId = widget.task?.parentId;
    _selectedColor = widget.task?.color ?? ItemColor.teal;
    _selectedStatus = widget.task?.taskStatus ?? TaskStatus.notStarted;
    _selectedStartDate = widget.task?.startDate;
    _selectedDueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final result = {
        'title': _titleController.text,
        'content': _contentController.text,
        'parent_id': _selectedParentId,
        'color': _selectedColor.name,
        'status': _selectedStatus.toDbValue(),
        'start_date': _selectedStartDate?.toIso8601String(),
        'due_date': _selectedDueDate?.toIso8601String(),
      };
      result.removeWhere((key, value) => value == null && key != 'parent_id');
      Navigator.of(context).pop(result);
    }
  }
  
  // --- FIXED: Combined Date and Time Picker Logic ---
  Future<void> _pickDateTime(BuildContext context, {required bool isStartDate}) async {
    final initialDate = (isStartDate ? _selectedStartDate : _selectedDueDate) ?? DateTime.now();

    // 1. Pick the Date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate == null) return; // User canceled the date picker

    // 2. Pick the Time
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return; // User canceled the time picker

    // 3. Combine Date and Time
    final finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    
    setState(() {
      if (isStartDate) {
        _selectedStartDate = finalDateTime;
      } else {
        _selectedDueDate = finalDateTime;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Helper for formatting the date and time text on the buttons
    String formatDateTime(DateTime? dt) {
        if (dt == null) return '';
        // e.g., "Jul 3, 2025, 6:30 PM"
        return DateFormat.yMd().add_jm().format(dt);
    }

    return AlertDialog(
      title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ... (Title, Content, Parent Task, Status, Color Dropdowns remain the same)
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                value: _selectedParentId,
                hint: const Text('No parent task'),
                decoration: const InputDecoration(labelText: 'Parent Task'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('None'),
                  ),
                  if (widget.allTasks != null)
                    ...widget.allTasks!
                        .where((t) => t.id != widget.task?.id)
                        .map((task) => DropdownMenuItem(
                              value: task.id,
                              child: Text(task.title),
                            )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedParentId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskStatus>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: TaskStatus.values.map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.toDbValue()),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedStatus = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<ItemColor>(
                      value: _selectedColor,
                      decoration: const InputDecoration(labelText: 'Color'),
                      items: ItemColor.values.map((color) => DropdownMenuItem(
                        value: color,
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: color.toColor(context), size: 16),
                            const SizedBox(width: 8),
                            Text(color.name),
                          ],
                        ),
                      )).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedColor = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // --- FIXED: Date/Time buttons ---
              Row(
                children: [
                   Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_selectedStartDate == null ? 'Start Date' : formatDateTime(_selectedStartDate)),
                      onPressed: () => _pickDateTime(context, isStartDate: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.flag),
                      label: Text(_selectedDueDate == null ? 'Due Date' : formatDateTime(_selectedDueDate)),
                       onPressed: () => _pickDateTime(context, isStartDate: false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: _saveForm,
        ),
      ],
    );
  }
}
