import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:looninary/core/models/task_model.dart';

class TaskEditScreen extends StatefulWidget {
  final Task? task;
  final List<Task>? allTasks;
  final String currentLanguage;

  const TaskEditScreen({
    Key? key,
    this.task,
    this.allTasks,
    required this.currentLanguage,
  }) : super(key: key);

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _autocompleteKey = GlobalKey();

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _parentController;

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
    _parentController = TextEditingController();

    _selectedParentId = widget.task?.parentId;
    _selectedColor = widget.task?.color ?? ItemColor.teal;
    _selectedStatus = widget.task?.taskStatus ?? TaskStatus.notStarted;
    _selectedStartDate = widget.task?.startDate;
    _selectedDueDate = widget.task?.dueDate;

    if (_selectedParentId != null && widget.allTasks != null) {
      try {
        final parentTask =
            widget.allTasks!.firstWhere((t) => t.id == _selectedParentId);
        _parentController.text = parentTask.title;
      } catch (e) {
        // Parent task not found
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _parentController.dispose();
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

  Future<void> _pickDateTime(BuildContext context,
      {required bool isStartDate}) async {
    final initialDate =
        (isStartDate ? _selectedStartDate : _selectedDueDate) ?? DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      locale: Locale(widget.currentLanguage), // truyền ngôn ngữ hiện tại
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return;

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
    final texts = {
      'newTask': widget.currentLanguage == 'en' ? 'New Task' : 'Nhiệm vụ mới',
      'editTask': widget.currentLanguage == 'en' ? 'Edit Task' : 'Chỉnh sửa nhiệm vụ',
      'title': widget.currentLanguage == 'en' ? 'Title' : 'Tiêu đề',
      'pleaseEnterTitle': widget.currentLanguage == 'en' ? 'Please enter a title' : 'Vui lòng nhập tiêu đề',
      'content': widget.currentLanguage == 'en' ? 'Content (optional)' : 'Nội dung (không bắt buộc)',
      'parentTask': widget.currentLanguage == 'en' ? 'Parent Task (optional)' : 'Nhiệm vụ chính (không bắt buộc)',
      'status': widget.currentLanguage == 'en' ? 'Status' : 'Trạng thái',
      'color': widget.currentLanguage == 'en' ? 'Color' : 'Màu sắc',
      'startDate': widget.currentLanguage == 'en' ? 'Start Date' : 'Ngày bắt đầu',
      'dueDate': widget.currentLanguage == 'en' ? 'Due Date' : 'Ngày hết hạn',
      'cancel': widget.currentLanguage == 'en' ? 'Cancel' : 'Hủy',
      'save': widget.currentLanguage == 'en' ? 'Save' : 'Lưu',
      // Status values
      'completed': widget.currentLanguage == 'en' ? 'Completed' : 'Hoàn thành',
      'inProgress': widget.currentLanguage == 'en' ? 'In Progress' : 'Đang thực hiện',
      'notStarted': widget.currentLanguage == 'en' ? 'Not Started' : 'Chưa bắt đầu',
      'blocked': widget.currentLanguage == 'en' ? 'Outdate' : 'Quá hạn',
    };

    final statusTexts = {
      TaskStatus.completed: texts['completed']!,
      TaskStatus.inProgress: texts['inProgress']!,
      TaskStatus.notStarted: texts['notStarted']!,
      TaskStatus.blocked: texts['blocked']!,
    };

    final colorTexts = {
      ItemColor.maroon: widget.currentLanguage == 'en' ? 'maroon' : 'đỏ nâu',
      ItemColor.peach: widget.currentLanguage == 'en' ? 'peach' : 'cam đào',
      ItemColor.yellow: widget.currentLanguage == 'en' ? 'yellow' : 'vàng',
      ItemColor.green: widget.currentLanguage == 'en' ? 'green' : 'xanh lá',
      ItemColor.teal: widget.currentLanguage == 'en' ? 'teal' : 'xanh ngọc',
    };

    String formatDateTime(DateTime? dt) {
      if (dt == null) return '';
      return DateFormat.yMd().add_jm().format(dt);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? texts['newTask']! : texts['editTask']!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: texts['title']),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return texts['pleaseEnterTitle'];
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: texts['content']),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Autocomplete<Task>(
                key: _autocompleteKey,
                initialValue: TextEditingValue(text: _parentController.text),
                displayStringForOption: (Task option) => option.title,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<Task>.empty();
                  }
                  return widget.allTasks?.where((Task option) {
                        final isItself = option.id == widget.task?.id;
                        final matches = option.title
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                        return !isItself && matches;
                      }) ??
                      const Iterable<Task>.empty();
                },
                onSelected: (Task selection) {
                  setState(() {
                    _selectedParentId = selection.id;
                    _parentController.text = selection.title;
                  });
                },
                optionsViewBuilder: (context, onSelected, options) {
                  final RenderBox? fieldRenderBox = _autocompleteKey.currentContext?.findRenderObject() as RenderBox?;
                  final double fieldWidth = fieldRenderBox?.size.width ?? 300;
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        width: fieldWidth,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(option.title),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                fieldViewBuilder: (context, fieldTextEditingController, fieldFocusNode, onFieldSubmitted) {
                  _parentController = fieldTextEditingController;
                  return TextFormField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: InputDecoration(
                      labelText: texts['parentTask'],
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            fieldTextEditingController.clear();
                            _selectedParentId = null;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskStatus>(
                      value: _selectedStatus,
                      decoration: InputDecoration(labelText: texts['status']),
                      items: TaskStatus.values
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(statusTexts[status]!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedStatus = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<ItemColor>(
                      value: _selectedColor,
                      decoration: InputDecoration(labelText: texts['color']),
                      items: ItemColor.values
                          .map((color) => DropdownMenuItem(
                                value: color,
                                child: Row(
                                  children: [
                                    Icon(Icons.circle,
                                        color: color.toColor(context),
                                        size: 16),
                                    const SizedBox(width: 8),
                                    Text(colorTexts[color]!),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _selectedColor = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_selectedStartDate == null
                          ? texts['startDate']!
                          : formatDateTime(_selectedStartDate)),
                      onPressed: () => _pickDateTime(context, isStartDate: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.flag),
                      label: Text(_selectedDueDate == null
                          ? texts['dueDate']!
                          : formatDateTime(_selectedDueDate)),
                      onPressed: () => _pickDateTime(context, isStartDate: false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                child: Text(texts['cancel']!),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                child: Text(texts['save']!),
                onPressed: _saveForm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}