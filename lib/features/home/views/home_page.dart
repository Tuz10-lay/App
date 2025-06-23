import 'package:flutter/material.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/features/home/views/calendar_view.dart';
import 'package:looninary/features/home/views/sidebar_menu.dart';
import 'package:looninary/features/home/views/agenda_view.dart';
import 'package:looninary/features/home/views/settings_screen.dart';
import 'package:looninary/features/home/views/all_tasks_view.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = AuthController();
  
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Dashboard Page')),
    AllTasksView(),
    AgendaView(), 
    CalendarPage(),
    SettingsScreen(),
  ];
  
  static const List<String> _widgetTitles = <String>[
    'Dashboard',
    'All Tasks',
    'Agenda View',
    'CalendarView',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarMenu(onItemSelected: _onItemTapped),
      appBar: AppBar(
        title: Text(_widgetTitles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.signOut(context),
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
