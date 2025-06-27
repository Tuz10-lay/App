import 'package:flutter/material.dart';
import 'package:looninary/features/home/views/home_page.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<String> notifications = [];
  int unreadCount = 0;

  void add(String message) {
    notifications.insert(0, message);
    unreadCount++;
    notifyListeners();
  }

  void markAllRead() {
    unreadCount = 0;
    notifyListeners();
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  // Để tránh lỗi Provider, chỉ dùng list tĩnh hoặc lấy task từ nơi khác, KHÔNG dùng Provider ở đây
  List tasks = []; // Nếu muốn hiển thị task thực tế, hãy truyền từ cha hoặc dùng controller riêng

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> items = const [
      _DashboardItem(icon: Icons.task_alt_sharp, label: 'All Tasks', index: 1),
      _DashboardItem(icon: Icons.task, label: 'Agenda View', index: 2),
      _DashboardItem(icon: Icons.calendar_month, label: 'Calendar View', index: 3),
      _DashboardItem(icon: Icons.settings, label: 'Settings', index: 4),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 120), // Khoảng trống phía trên
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: items
                      .map((item) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _DashboardIcon(item: item),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          if (tasks.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    child: ListTile(
                      title: Text(task['title'] ?? ''),
                      subtitle: Text(task['description'] ?? ''),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _DashboardItem {
  final IconData icon;
  final String label;
  final int index;
  const _DashboardItem({required this.icon, required this.label, required this.index});
}

class _DashboardIcon extends StatelessWidget {
  final _DashboardItem item;
  const _DashboardIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final state = context.findAncestorStateOfType<HomePageState>();
        state?.onItemTapped(item.index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.deepPurple.shade200,
            child: Icon(item.icon, size: 32, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(item.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
