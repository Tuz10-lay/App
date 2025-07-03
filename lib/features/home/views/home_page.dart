import 'package:flutter/material.dart';
import 'package:looninary/features/home/views/settings_screen.dart';
import 'package:looninary/features/home/views/all_tasks_view.dart';
import 'package:looninary/features/home/views/stats_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of widgets to display in the body based on the selected tab.
  static const List<Widget> _widgetOptions = <Widget>[
    StatsView(),      // Index 0: Dashboard
    AllTasksView(),   // Index 1: Tasks
    SettingsScreen(), // Index 2: Settings
  ];

  // Updates the state when a tab is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A minimal AppBar to act as a separator from the phone's status bar.
      appBar: AppBar(
        // This makes the AppBar itself invisible and take up no space.
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // We use the 'bottom' property to create a thin divider line.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Theme.of(context).dividerColor,
            height: 1.0,
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            activeIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
