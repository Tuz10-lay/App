import 'package:flutter/material.dart';
import 'package:looninary/features/home/controllers/task_controller.dart';
import 'package:looninary/features/home/views/settings_screen.dart';
import 'package:looninary/features/home/views/all_tasks_view.dart';
import 'package:looninary/features/home/views/stats_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String initialLanguage;
  const HomePage({Key? key, this.initialLanguage = 'en'}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.initialLanguage;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLanguageChanged(String newLang) {
    setState(() {
      _currentLanguage = newLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = {
      'dashboard': _currentLanguage == 'en' ? 'Dashboard' : 'Bảng tin',
      'tasks': _currentLanguage == 'en' ? 'Tasks' : 'Nhiệm vụ',
      'settings': _currentLanguage == 'en' ? 'Settings' : 'Cài đặt',
    };

    final List<Widget> _widgetOptions = <Widget>[
      StatsView(currentLanguage: _currentLanguage),
      AllTasksView(currentLanguage: _currentLanguage),
      SettingsScreen(
        currentLanguage: _currentLanguage,
        onLanguageChanged: _onLanguageChanged,
      ),
    ];

    return ChangeNotifierProvider(
      create: (context) => TaskController(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: texts['dashboard'],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined),
              activeIcon: Icon(Icons.task_alt),
              label: texts['tasks'],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: texts['settings'],
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

