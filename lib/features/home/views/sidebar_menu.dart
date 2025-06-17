import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_colors.dart';

class SidebarMenu extends StatelessWidget {
  // cacllback function to notify the HomePage wich item was tapped
  final Function(int) onItemSelected;

  const SidebarMenu({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              "Looninary",
              style: TextStyle(
                fontSize: 24,
                color: AppColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_rounded),
            title: const Text("Dasboard"),
            onTap: () {
              onItemSelected(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text("Agenda View"),
            onTap: () {
              onItemSelected(1);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              onItemSelected(2);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
