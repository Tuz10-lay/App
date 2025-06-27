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
        surface: AppColors.background,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: AppColors.text),
      ),

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

  static ThemeData get darkTheme {
    const mBackground = Color(0xFF24273A); // A standard dark background
    const mSurface = Color(0xFF363A4F); // A slightly lighter surface color

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: mBackground,
      primaryColor: mSurface,
      colorScheme: const ColorScheme.dark(
        primary: mSurface,
        secondary: AppColors.mTeal, // Example secondary color
        error: AppColors.mRed,
        background: mBackground,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.mText,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: AppColors.mText),
        titleSmall: TextStyle(color: AppColors.mText), // For section headers
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.mText),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.mMauve,
            width: 2.0,
          ), // Use a bright color for focus
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mSurface),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    );
  }
}
