import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.base, // Nền trắng
      colorScheme: const ColorScheme.light(
        primary: AppColors.mauve,
        surface: AppColors.base,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.text),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.textLight),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mauve, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.surface0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.midnight, // Nền đen
      colorScheme: const ColorScheme.dark(
        primary: AppColors.mauve,
        surface: AppColors.midnight,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.base), // Chữ trắng
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.textLight),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mauve, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.surface0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    );
  }
}
