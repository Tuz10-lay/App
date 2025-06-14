import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.surface0,
      colorScheme: const ColorScheme.light(
        primary: AppColors.surface0,
        secondary: AppColors.base,
        error: AppColors.error,
        background: AppColors.background,
      ),

      // Define the default font family (we'll add one later!)
      // fontFamily: 'YourWhimsicalFont',

      // Customize TextTheme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: AppColors.text),
      ),


      // Customize TextField Theme
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.textLight),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.surface0, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
           borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        border: OutlineInputBorder(
           borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    );
  }
}
