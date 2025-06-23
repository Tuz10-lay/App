import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_colors.dart';

enum SnackBarType {
  success,
  failure,
  pending
}

void showAppSnackBar(BuildContext context, String message, SnackBarType type) {
  Color backgroundColor = AppColors.yellow ;
  
  if (type == SnackBarType.success) {
    backgroundColor = AppColors.green;
  } else if (type == SnackBarType.failure) {
    backgroundColor = AppColors.maroon;
  } else if (type == SnackBarType.pending) {
    backgroundColor = AppColors.teal;
  }


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
