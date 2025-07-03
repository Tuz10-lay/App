// features/home/views/sidebar_menu.dart

import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final Function(int) onItemSelected;
  const SidebarMenu({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(child: Text("Looninary", style: theme.textTheme.displayLarge)),
          // --- UPDATED: First item is now Stats ---
          ListTile(
            leading: const Icon(Icons.bar_chart_rounded),
            title: const Text("Stats"),
            onTap: () { onItemSelected(0); Navigator.pop(context); },
          ),
          ListTile(
            leading: const Icon(Icons.task_alt_sharp),
            title: const Text("All Tasks"),
            onTap: () { onItemSelected(1); Navigator.pop(context); },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () { onItemSelected(2); Navigator.pop(context); },
          ),
        ],
      ),
    );
  }
}
