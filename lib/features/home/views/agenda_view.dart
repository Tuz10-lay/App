import 'package:flutter/material.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:looninary/features/home/controllers/task_controller.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  late final TaskController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TaskController();
    _taskController.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChangeNotifierProvider(
      create: (_) => _taskController,
      child: Consumer<TaskController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SfCalendar(
            view: CalendarView.schedule,
            dataSource: _getCalendarDataSource(controller.tasks, colorScheme),
            scheduleViewSettings: const ScheduleViewSettings(
              appointmentItemHeight: 70,
            ),
          );
        },
      ),
    );
  }

  _TaskDataSource _getCalendarDataSource(List<Task> tasks, ColorScheme colorScheme) {
    return _TaskDataSource(tasks, colorScheme);
  }
}

class _TaskDataSource extends CalendarDataSource {
  final ColorScheme colorScheme;
  _TaskDataSource(List<Task> source, this.colorScheme) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments![index] as Task).startDate ?? DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments![index] as Task).dueDate ?? getStartTime(index).add(const Duration(hours: 1));
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as Task).title;
  }

  @override
  Color getColor(int index) {
    switch ((appointments![index] as Task).color) {
      case ItemColor.maroon:
        return colorScheme.error;
      case ItemColor.peach:
        return colorScheme.secondary;
      case ItemColor.yellow:
        return colorScheme.tertiary;
      case ItemColor.green:
        return colorScheme.primaryContainer;
      case ItemColor.teal:
        return colorScheme.secondaryContainer;
    }
  }
}
