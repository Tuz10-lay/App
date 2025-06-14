import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_colors.dart';

enum SnackBarType {
  success,
  failure
}

void showAppSnackBar(BuildContext context, String message, SnackBarType type) {
  final Color backgroundColor = type == SnackBarType.success 
    ? AppColors.green
    : AppColors.maroon;

    // Hide the current snack bar if one is showing
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the new snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
}
