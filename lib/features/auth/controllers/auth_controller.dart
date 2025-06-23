import 'package:flutter/material.dart';
import 'package:looninary/core/services/auth_service.dart';
import 'package:looninary/core/utils/logger.dart';
import 'package:looninary/core/widgets/app_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> signUp(
    BuildContext context,
    String email,
    String password,
  ) async {
    logger.i("Attempting to sign up user with email: $email");

    try {
      final user = await _authService.signUp(email, password);

      // since the await up there create an async gap, user might navigate away in the sign up process
      // after the await completes, we have to check the widget which provided the BuildContext still in the widget tree, in case it not mounted, we won't process since using 'context' would result in an error
      if (!context.mounted) return;

      if (user != null) {
        logger.i("Sign up successfully for user with email: $email");
        showAppSnackBar(
          context,
          "Sign up successfully! Please check your email for verification",
          SnackBarType.success,
        );
      }
    } on AuthException catch (e) {
      logger.e(
        "Sign up failed for user with email: $email. Error: ${e.message}",
      );
      if (!context.mounted) return;
      showAppSnackBar(context, e.message, SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error during sign up: $e");
      if (!context.mounted) return;
      showAppSnackBar(
        context,
        "Unexpected error during sign up, please try again.",
        SnackBarType.failure,
      );
    }
  }

  Future<void> logIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    logger.i("Attempting log in user with email: $email");
    try {
      final user = await _authService.logIn(email, password);

      if (!context.mounted) return;

      if (user != null) {
        logger.i("Log in successfully for user with email: $email");
        showAppSnackBar(context, "Log in successfully", SnackBarType.success);
      }
    } on AuthException catch (e) {
      logger.e("Log in failed for user with email: $email, error: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, e.message, SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error during login: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, "Log in failed, please try again", SnackBarType.failure);
    }
  }

  Future<void> signInAnonymously(BuildContext context) async {
    logger.i("Attemping sign in anonymously");

    try {
      final user = await _authService.signInAnonymously();

      if (!context.mounted) return;

      if (user != null) {
        logger.i("Anonymous sign in successful for user with id: ${user.id}");
        showAppSnackBar(context, "Anonymous sign in successful", SnackBarType.success);
      }
    } on AuthException catch (e) {
      logger.e("Anonymous sign in failed: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, e.message, SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error during anonymous sign in: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, "Unexpected error", SnackBarType.failure);
    }
  }

  Future<void> signInWithOAuth(BuildContext context, OAuthProvider provider) async {
    try {
      await _authService.signInWithOAuth(provider);

      if (!context.mounted) return;

      showAppSnackBar(context, "Waiting for OAuth", SnackBarType.pending);
    } on AuthException catch (e) {
      logger.e("OAuth failed: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, e.message, SnackBarType.failure);

    } catch (e) {
      // Không hiện thông báo lỗi khi đăng nhập OAuth
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _authService.signOut();
    } on AuthException catch (e) {
      logger.e("Sign out failed: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, "Sign out failed: ${e.message}", SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, "Unexpected error", SnackBarType.failure);
    }
  }

  Future<void> updateUserEmail(BuildContext context, String newEmail) async {
    try {
      await _authService.updateUserEmail(newEmail);
      if (!context.mounted) return;
  
      showAppSnackBar(context, "Check email $newEmail for verification", SnackBarType.pending);
    } on AuthException catch (e) {
      logger.e("Email update failed: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, "Update email failed: ${e.message}", SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpeced error while updating password: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, "Update email failed due to unexpected error", SnackBarType.failure);
    }
  }

  Future<void> register(BuildContext context, String email, String password) async {
    await signUp(context, email, password);
  }

  Future<void> sendPasswordReset(BuildContext context, String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      if (!context.mounted) return;
      showAppSnackBar(context, "Password reset email sent!", SnackBarType.success);
    } on AuthException catch (e) {
      logger.e("Password reset failed: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, "Password reset failed: ${e.message}", SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error during password reset: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, "Password reset failed due to unexpected error", SnackBarType.failure);
    }
  }

  Future<void> updateUserPassword(BuildContext context, String newPassword, {required String currentPassword}) async {
    try {
      // Gửi cả currentPassword và newPassword cho service xử lý
      await _authService.updateUserPassword(newPassword, currentPassword: currentPassword);
      if (!context.mounted) return;
      showAppSnackBar(context, "Password updated successfully!", SnackBarType.success);
    } on AuthException catch (e) {
      logger.e("Password update failed: [31m${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, "Update password failed: ${e.message}", SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error while updating password: $e");

      if (!context.mounted) return;
      showAppSnackBar(context, "Update password failed due to unexpected error", SnackBarType.failure);
    }
  }

   
}
