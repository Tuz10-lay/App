// Logic for managing and switching themes


import 'package:flutter/material.dart';

// The ThemeProvider class manages the theme state of the application.
// It uses the ChangeNotifier mixin, which allows it to notify listeners when the theme changes.
class ThemeProvider with ChangeNotifier {
  // A private variable to hold the current theme mode.
  ThemeMode _themeMode = ThemeMode.dark;

  // A public getter to access the current theme mode.
  // Widgets will use this to determine which theme to apply.
  ThemeMode get themeMode => _themeMode;

  // A method to toggle the theme between light and dark mode.
  void toggleTheme() {
    // Check the current theme mode and switch to the other.
    // If it's dark, switch to light. If it's light, switch to dark.
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    
    // notifyListeners() is a crucial method from ChangeNotifier.
    // It tells all listening widgets that the state has changed,
    // causing them to rebuild with the new theme.
    notifyListeners();
  }
}
