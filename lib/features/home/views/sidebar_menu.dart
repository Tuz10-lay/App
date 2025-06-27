import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  // cacllback function to notify the HomePage wich item was tapped
  final Function(int) onItemSelected;

  const SidebarMenu({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      backgroundColor: colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.surface,
            ),
            child: Text(
              "Looninary",
              style: textTheme.titleLarge?.copyWith(
                fontSize: 24,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard_rounded, color: colorScheme.onSurface),
            title: Text("Dashboard", style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
            onTap: () {
              onItemSelected(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.task_alt_sharp, color: colorScheme.onSurface),
            title: Text("All Tasks", style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
            onTap: () {
              onItemSelected(1);
              Navigator.pop(context);
            }
          ),
          ListTile(
            leading: Icon(Icons.task, color: colorScheme.onSurface),
            title: Text("Agenda View", style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
            onTap: () {
              onItemSelected(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month, color: colorScheme.onSurface),
            title: Text("Calendar View", style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
            onTap: () {
              onItemSelected(3);
              Navigator.pop(context);
            },
          ),
          Divider(color: colorScheme.outline.withOpacity(0.2)),
          ListTile(
            leading: Icon(Icons.settings, color: colorScheme.onSurface),
            title: Text("Settings", style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
            onTap: () {
              onItemSelected(4);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
