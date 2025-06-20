import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:looninary/core/theme/app_colors.dart';

class TaskEditDialog extends StatefulWidget {
  final Task? task;

  const TaskEditDialog({super.key, this.task});

  @override
  _TaskEditDialogState createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String? _content;
  late TaskPriority _priority;
  late ItemColor _color;
  late DateTime? _startDate;
  late DateTime? _dueDate;
  // --- NEW STATE VARIABLES for Time ---
  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;


  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _content = widget.task?.content ?? '';
    _priority = widget.task?.taskPriority ?? TaskPriority.medium;
    _color = widget.task?.color ?? ItemColor.teal;

    // Initialize Dates
    _startDate = widget.task?.startDate ?? DateTime.now();
    _dueDate = widget.task?.dueDate;

    // --- INITIALIZE Time from the DateTime objects ---
    _startTime = widget.task?.startDate != null ? TimeOfDay.fromDateTime(widget.task!.startDate!) : TimeOfDay.now();
    _endTime = widget.task?.dueDate != null ? TimeOfDay.fromDateTime(widget.task!.dueDate!) : null;
  }

  // --- NEW HELPER for picking time ---
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final initialTime = isStartTime 
      ? (_startTime ?? TimeOfDay.now()) 
      : (_endTime ?? _startTime ?? TimeOfDay.now());

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate ? (_startDate ?? DateTime.now()) : (_dueDate ?? _startDate ?? DateTime.now());
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _dueDate = pickedDate;
        }
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // --- UPDATED SAVE LOGIC to combine Date and Time ---
      DateTime? finalStartDate;
      if (_startDate != null && _startTime != null) {
        finalStartDate = DateTime(_startDate!.year, _startDate!.month, _startDate!.day, _startTime!.hour, _startTime!.minute);
      }

      DateTime? finalDueDate;
      if (_dueDate != null && _endTime != null) {
        finalDueDate = DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day, _endTime!.hour, _endTime!.minute);
      }


      final result = {
        'title': _title,
        'content': _content,
        'priority': _priority.toDbValue(),
        'color': _color.name,
        'start_date': finalStartDate?.toIso8601String(),
        'due_date': finalDueDate?.toIso8601String(),
        'status': widget.task?.taskStatus.toDbValue() ?? 'Not Started',
      };
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(labelText: 'Content (Optional)'),
                maxLines: 3,
                onSaved: (value) => _content = value,
              ),
              const SizedBox(height: 20),

              // --- UPDATED UI with Time Pickers ---
              Text("From", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildDatePickerField(context, 'Start Date', _startDate, true)),
                  const SizedBox(width: 12),
                  SizedBox(width: 120, child: _buildTimePickerField(context, 'Start Time', _startTime, true)),
                ],
              ),
              const SizedBox(height: 20),
              Text("To", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildDatePickerField(context, 'Due Date', _dueDate, false)),
                  const SizedBox(width: 12),
                  SizedBox(width: 120, child: _buildTimePickerField(context, 'End Time', _endTime, false)),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskPriority>(
                      value: _priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: TaskPriority.values
                          .map((priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority.toDbValue()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _priority = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<ItemColor>(
                      value: _color,
                      decoration: const InputDecoration(labelText: 'Color'),
                      items: ItemColor.values
                          .map((color) => DropdownMenuItem(
                                value: color,
                                child: Text(color.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _color = value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(onPressed: _saveForm, child: const Text('Save')),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context, String label, DateTime? date, bool isStartDate) {
    return InkWell(
      onTap: () => _selectDate(context, isStartDate),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(
          date != null ? DateFormat.yMMMd().format(date) : 'Not set',
          style: TextStyle(color: date != null ? null : Colors.grey),
        ),
      ),
    );
  }

  // --- NEW HELPER WIDGET for creating time fields ---
  Widget _buildTimePickerField(BuildContext context, String label, TimeOfDay? time, bool isStartTime) {
    return InkWell(
      onTap: () => _selectTime(context, isStartTime),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(
          time != null ? time.format(context) : 'Not set',
          style: TextStyle(color: time != null ? null : Colors.grey),
        ),
      ),
    );
  }
}
