import 'package:flutter/material.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:looninary/features/home/controllers/task_controller.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:looninary/core/theme/app_colors.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final TaskController _taskController;
  CalendarView _currentView = CalendarView.month;

  @override
  void initState() {
    super.initState();
    _taskController = TaskController();
    _taskController.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _taskController,
      child: Consumer<TaskController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SegmentedButton<CalendarView>(
                  segments: const <ButtonSegment<CalendarView>>[
                    ButtonSegment(value: CalendarView.month, label: Text('Month'), icon: Icon(Icons.calendar_month)),
                    ButtonSegment(value: CalendarView.week, label: Text('Week'), icon: Icon(Icons.view_week)),
                    ButtonSegment(value: CalendarView.day, label: Text('Day'), icon: Icon(Icons.view_day)),
                  ],
                  selected: {_currentView},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      _currentView = newSelection.first;
                    });
                  },
                ),
              ),
              Expanded(
                child: SfCalendar(
                  view: _currentView,
                  dataSource: getCalendarDataSource(controller.tasks),
                  initialSelectedDate: DateTime.now(),
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                    showAgenda: true
                  ),
                  onTap: (details) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped on ${details.date?.day}/${details.date?.month}'))
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TaskDataSource extends CalendarDataSource {
  TaskDataSource(List<Task> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments![index] as Task).startDate ?? DateTime.now();
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments![index] as Task).dueDate ??
        getStartTime(index).add(const Duration(hours: 1));
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as Task).title;
  }

  @override
  Color getColor(int index) {
    switch ((appointments![index] as Task).color) {
      case ItemColor.maroon: return AppColors.maroon;
      case ItemColor.peach: return AppColors.peach;
      case ItemColor.yellow: return AppColors.yellow;
      case ItemColor.green: return AppColors.green;
      case ItemColor.teal: return AppColors.teal;
    }
  }
}

TaskDataSource getCalendarDataSource(List<Task> tasks) {
  return TaskDataSource(tasks);
}
