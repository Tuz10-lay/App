import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/features/home/views/calendar_view.dart';
import 'package:looninary/features/home/views/sidebar_menu.dart';
import 'package:looninary/features/home/views/agenda_view.dart';
import 'package:looninary/features/home/views/settings_screen.dart';
import 'package:looninary/features/home/views/all_tasks_view.dart';
import 'package:looninary/features/home/views/dashboard_view.dart';
import 'package:provider/provider.dart';
import 'package:looninary/features/home/controllers/task_controller.dart';
import 'package:looninary/core/models/task_model.dart';
import 'package:looninary/core/theme/theme_swithcher_button.dart'; // <-- Thêm dòng này

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AuthController _authController = AuthController();
  
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardView(),
    AllTasksView(),
    AgendaView(), 
    CalendarPage(),
    SettingsScreen(),
  ];
  
  static const List<String> _widgetTitles = <String>[
    'Dashboard',
    'All Tasks',
    'Agenda View',
    'Calendar View',
    'Settings',
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      drawer: SidebarMenu(onItemSelected: onItemTapped),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
        titleSpacing: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Menu',
            color: colorScheme.onBackground,
          ),
        ),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => onItemTapped(0),
              tooltip: 'Home',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              color: colorScheme.onBackground,
            ),
            const SizedBox(width: 8),
            Text(
              _widgetTitles[_selectedIndex],
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: NotificationService(),
            builder: (context, _) {
              final unread = NotificationService().unreadCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    tooltip: 'Notifications',
                    color: colorScheme.onBackground,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Notifications', style: textTheme.titleMedium?.copyWith(color: colorScheme.onBackground)),
                          backgroundColor: colorScheme.background,
                          content: SizedBox(
                            width: 350,
                            height: 400,
                            child: AnimatedBuilder(
                              animation: NotificationService(),
                              builder: (context, _) {
                                final notifications = NotificationService().notifications;
                                return notifications.isEmpty
                                    ? Center(child: Text('No notifications', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground)))
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: notifications.length,
                                        separatorBuilder: (c, i) => Divider(color: colorScheme.outline.withOpacity(0.2)),
                                        itemBuilder: (context, index) => ListTile(
                                          leading: Icon(Icons.notifications_active, color: colorScheme.primary),
                                          title: Text(
                                            notifications[index],
                                            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground, fontWeight: FontWeight.w500),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            'Received at: ' + DateTime.now().toString().substring(0, 16),
                                            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 12),
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close', style: textTheme.labelLarge?.copyWith(color: colorScheme.primary)),
                            ),
                          ],
                        ),
                      );
                      NotificationService().markAllRead();
                    },
                  ),
                  if (unread > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$unread',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onError,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.signOut(context),
            tooltip: 'Logout',
            color: colorScheme.onBackground, // icon logout
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.2),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.07),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _DashboardIcon(
                              item: _DashboardItem(icon: Icons.task_alt_sharp, label: 'All Tasks', index: 1),
                              isSelected: _selectedIndex == 1,
                              onTap: () => onItemTapped(1),
                            ),
                            const SizedBox(width: 32),
                            _DashboardIcon(
                              item: _DashboardItem(icon: Icons.task, label: 'Agenda View', index: 2),
                              isSelected: _selectedIndex == 2,
                              onTap: () => onItemTapped(2),
                            ),
                            const SizedBox(width: 32),
                            _DashboardIcon(
                              item: _DashboardItem(icon: Icons.calendar_month, label: 'Calendar View', index: 3),
                              isSelected: _selectedIndex == 3,
                              onTap: () => onItemTapped(3),
                            ),
                            const SizedBox(width: 32),
                            _DashboardIcon(
                              item: _DashboardItem(icon: Icons.settings, label: 'Settings', index: 4),
                              isSelected: _selectedIndex == 4,
                              onTap: () => onItemTapped(4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _RecentTasksPreview(),
                  const SizedBox(height: 16),
                  _CompletedTasksPreview(),
                ],
              ),
            )
          : _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: const ThemeSwitcherButton(),
    );
  }
}

class _DashboardIcon extends StatelessWidget {
  final _DashboardItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _DashboardIcon({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colorScheme.primary : colorScheme.surface,
                border: Border.all(
                  color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.2),
                  width: isSelected ? 2 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(isSelected ? 0.18 : 0.07),
                    blurRadius: isSelected ? 18 : 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Icon(
                  item.icon,
                  color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.label,
              style: textTheme.bodyLarge?.copyWith(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardItem {
  final IconData icon;
  final String label;
  final int index;

  _DashboardItem({required this.icon, required this.label, required this.index});
}

class _RecentTasksPreview extends StatefulWidget {
  @override
  State<_RecentTasksPreview> createState() => _RecentTasksPreviewState();
}

class _RecentTasksPreviewState extends State<_RecentTasksPreview> {
  final TaskController _controller = TaskController();
  bool _loading = true;
  String? _error;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _controller.fetchTasks();
      setState(() {
        _tasks = List.from(_controller.tasks);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load tasks';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(_error!, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
      );
    }
    if (_tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('No tasks found', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
      );
    }
    final activeTasks = _tasks.where((t) => t.taskStatus != TaskStatus.completed).toList();
    final showTasks = activeTasks.take(5).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Tasks', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.onBackground)),
          const SizedBox(height: 12),
          ...showTasks.map((task) => _TaskCard(task: task, faded: false)),
        ],
      ),
    );
  }
}

class _CompletedTasksPreview extends StatefulWidget {
  @override
  State<_CompletedTasksPreview> createState() => _CompletedTasksPreviewState();
}

class _CompletedTasksPreviewState extends State<_CompletedTasksPreview> {
  final TaskController _controller = TaskController();
  bool _loading = true;
  String? _error;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _controller.fetchTasks();
      setState(() {
        _tasks = List.from(_controller.tasks);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load tasks';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(_error!, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
      );
    }
    final completedTasks = _tasks.where((t) => t.taskStatus == TaskStatus.completed).toList();
    if (completedTasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('No completed tasks', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
      );
    }
    final showTasks = completedTasks.take(5).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Completed Tasks', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.onBackground)),
          const SizedBox(height: 12),
          ...showTasks.map((task) => _TaskCard(task: task, faded: true)),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final bool faded;
  const _TaskCard({required this.task, this.faded = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Opacity(
      opacity: faded ? 0.45 : 1.0,
      child: Card(
        color: colorScheme.surface,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline.withOpacity(0.2), width: 1),
        ),
        child: ListTile(
          leading: Icon(Icons.circle, color: _colorFromItemColor(context, task.color), size: 18),
          title: Text(task.title, style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w600)),
          subtitle: Text(
            '${task.taskStatus.toDbValue()} • Priority: ${task.taskPriority.toDbValue()}',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 13),
          ),
          trailing: Text(
            task.dueDate != null ? _formatDate(task.dueDate!) : '',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Color _colorFromItemColor(BuildContext context, ItemColor color) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (color) {
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

