import 'package:flutter/material.dart';
import 'package:looninary/core/theme/theme_manager.dart';

class ThemeSwitcherButton extends StatelessWidget {
  const ThemeSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeMode,
      builder: (context, mode, _) => FloatingActionButton(
        backgroundColor: colorScheme.onBackground.withOpacity(0.15),
        elevation: 2,
        shape: const CircleBorder(),
        child: Icon(
          mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
          color: colorScheme.onBackground,
          size: 28,
        ),
        tooltip: mode == ThemeMode.light ? 'Chuyển sang giao diện tối' : 'Chuyển sang giao diện sáng',
        onPressed: () => ThemeManager.toggleTheme(),
      ),
    );
  }
}