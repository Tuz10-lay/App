import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_colors.dart';

class AppTheme {
  // Private constructor to prevent instantiation.
  AppTheme._();

  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background, // Main light background
      primaryColor: AppColors.surface0,
      colorScheme: const ColorScheme.light(
        primary: AppColors.purple,
        onPrimary: AppColors.background,
        secondary: AppColors.aqua,
        error: AppColors.red,
        surface: AppColors.surface0,
        onSurface: AppColors.text,
        onSurfaceVariant: AppColors.subText1,
        surfaceContainerHighest: AppColors.surface1,
        primaryContainer: AppColors.purple,
        onPrimaryContainer: AppColors.background,
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
        filled: true,
        fillColor: AppColors.surface1,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.purple, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.surface1), // Border is visible
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: AppColors.surface1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.purple,
        ),
      ),
    );
  }

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.grbd,
      primaryColor: AppColors.mSurface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.mPurple,
        onPrimary: AppColors.midnight,
        secondary: AppColors.mAqua,
        error: AppColors.mRed,
        surface: AppColors.mSurface,
        onSurface: AppColors.mText,
        onSurfaceVariant: AppColors.mSubtext0,
        surfaceContainerHighest: AppColors.mSurface,
        primaryContainer: AppColors.mPurple,
        onPrimaryContainer: AppColors.midnight,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.mText,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: AppColors.mText),
        titleSmall: TextStyle(color: AppColors.mText),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.mText),
        filled: true,
        fillColor: AppColors.midnight,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.mPurple, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        enabledBorder: OutlineInputBorder(
          // Border is visible against the darker background
          borderSide: BorderSide(color: AppColors.mSurface),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: AppColors.mSurface),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mPurple,
          foregroundColor: AppColors.midnight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mPurple,
        ),
      ),
    );
  }
}
