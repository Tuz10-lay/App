import 'package:flutter/material.dart';
import 'package:looninary/core/services/auth_service.dart';
import 'package:looninary/core/utils/logger.dart';
import 'package:looninary/core/widgets/app_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:looninary/core/utils/language_provider.dart';

// Map chứa các thông báo theo ngôn ngữ
final Map<String, Map<String, String>> notificationText = {
  'signUpSuccess': {
    'en': 'Sign up successfully! Please check your email for verification',
    'vi': 'Đăng ký thành công! Vui lòng kiểm tra email để xác thực',
  },
  'logInSuccess': {
    'en': 'Log in successfully',
    'vi': 'Đăng nhập thành công',
  },
  'anonymousSignIn': {
    'en': 'Anonymous sign in successful',
    'vi': 'Đăng nhập ẩn danh thành công',
  },
  'waitingOAuth': {
    'en': 'Waiting for OAuth',
    'vi': 'Đang chờ xác thực OAuth',
  },
  'signOutFailed': {
    'en': 'Sign out failed',
    'vi': 'Đăng xuất thất bại',
  },
  'passwordResetSent': {
    'en': 'Password reset email sent!',
    'vi': 'Đã gửi email đặt lại mật khẩu!',
  },
  'passwordResetFailed': {
    'en': 'Password reset failed',
    'vi': 'Gửi email đặt lại mật khẩu thất bại',
  },
  'passwordUpdated': {
    'en': 'Password updated successfully!',
    'vi': 'Đổi mật khẩu thành công!',
  },
  'passwordUpdateFailed': {
    'en': 'Update password failed',
    'vi': 'Đổi mật khẩu thất bại',
  },
  'updateEmail': {
    'en': 'Check email for verification',
    'vi': 'Vui lòng kiểm tra email để xác thực',
  },
  'updateEmailFailed': {
    'en': 'Update email failed',
    'vi': 'Thay đổi email thất bại',
  },
  'unexpectedError': {
    'en': 'Unexpected error, please try again.',
    'vi': 'Lỗi không xác định, vui lòng thử lại.',
  },
};

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> signUp(
    BuildContext context,
    String email,
    String password,
  ) async {
    logger.i("Attempting to sign up user with email: $email");

    final lang = Provider.of<LanguageProvider>(context, listen: false).language;
    try {
      final user = await _authService.signUp(email, password);

      if (!context.mounted) return;

      if (user != null) {
        logger.i("Sign up successfully for user with email: $email");
        showAppSnackBar(
          context,
          notificationText['signUpSuccess']![lang]!,
          SnackBarType.success,
        );
      }
    } on AuthException catch (e) {
      logger.e("Sign up failed for user with email: $email. Error: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, e.message, SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error during sign up: $e");
      if (!context.mounted) return;
      showAppSnackBar(
        context,
        notificationText['unexpectedError']![lang]!,
        SnackBarType.failure,
      );
    }
  }

  Future<bool> logIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    logger.i("Attempting log in user with email: $email");
    final lang = Provider.of<LanguageProvider>(context, listen: false).language;
    try {
      final user = await _authService.logIn(email, password);

      if (!context.mounted) return false;

      if (user != null) {
        logger.i("Log in successfully for user with email: $email");
        showAppSnackBar(context, notificationText['logInSuccess']![lang]!, SnackBarType.success);
        return true;
      } else {
        return false;
      }
    } on AuthException catch (e) {
      logger.e("Log in failed for user with email: $email, error: ${e.message}");
      if (!context.mounted) return false;
      showAppSnackBar(context, e.message, SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error during login: $e");
      if (!context.mounted) return false;
      showAppSnackBar(context, notificationText['unexpectedError']![lang]!, SnackBarType.failure);
    }
    return false;
  }

  Future<void> signInAnonymously(BuildContext context) async {
    logger.i("Attemping sign in anonymously");
    final lang = Provider.of<LanguageProvider>(context, listen: false).language;

    try {
      final user = await _authService.signInAnonymously();

      if (!context.mounted) return;

      if (user != null) {
        logger.i("Anonymous sign in successful for user with id: ${user.id}");
        showAppSnackBar(context, notificationText['anonymousSignIn']![lang]!, SnackBarType.success);
      }
    } on AuthException catch (e) {
      logger.e("Anonymous sign in failed: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, e.message, SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error during anonymous sign in: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, notificationText['unexpectedError']![lang]!, SnackBarType.failure);
    }
  }

  Future<void> signInWithOAuth(BuildContext context, OAuthProvider provider) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false).language;
    try {
      await _authService.signInWithOAuth(provider);

      if (!context.mounted) return;

      showAppSnackBar(context, notificationText['waitingOAuth']![lang]!, SnackBarType.pending);
    } on AuthException catch (e) {
      logger.e("OAuth failed: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, e.message, SnackBarType.failure);

    } catch (e) {
      // Không hiện thông báo lỗi khi đăng nhập OAuth
    }
  }

  Future<void> signOut(BuildContext context) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false).language;
    try {
      await _authService.signOut();
    } on AuthException catch (e) {
      logger.e("Sign out failed: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, "${notificationText['signOutFailed']![lang]!}: ${e.message}", SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, notificationText['unexpectedError']![lang]!, SnackBarType.failure);
    }
  }

  Future<void> updateUserEmail(BuildContext context, String newEmail) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false).language;
    try {
      await _authService.updateUserEmail(newEmail);
      if (!context.mounted) return;

      showAppSnackBar(context, notificationText['updateEmail']![lang]!, SnackBarType.pending);
    } on AuthException catch (e) {
      logger.e("Email update failed: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, "${notificationText['updateEmailFailed']![lang]!}: ${e.message}", SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error while updating email: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, notificationText['unexpectedError']![lang]!, SnackBarType.failure);
    }
  }

  Future<void> register(BuildContext context, String email, String password) async {
    await signUp(context, email, password);
  }

  Future<void> sendPasswordReset(BuildContext context, String email) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false).language;
    try {
      await _authService.sendPasswordResetEmail(email);
      if (!context.mounted) return;
      showAppSnackBar(context, notificationText['passwordResetSent']![lang]!, SnackBarType.success);
    } on AuthException catch (e) {
      logger.e("Password reset failed: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, "${notificationText['passwordResetFailed']![lang]!}: ${e.message}", SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error during password reset: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, notificationText['unexpectedError']![lang]!, SnackBarType.failure);
    }
  }

  Future<void> updateUserPassword(BuildContext context, String newPassword, {required String currentPassword}) async {
    final lang = Provider.of<LanguageProvider>(context, listen: false).language;
    try {
      await _authService.updateUserPassword(newPassword, currentPassword: currentPassword);
      if (!context.mounted) return;
      showAppSnackBar(context, notificationText['passwordUpdated']![lang]!, SnackBarType.success);
    } on AuthException catch (e) {
      logger.e("Password update failed: ${e.message}");
      if (!context.mounted) return;
      showAppSnackBar(context, "${notificationText['passwordUpdateFailed']![lang]!}: ${e.message}", SnackBarType.failure);
    } catch (e) {
      logger.e("Unexpected error while updating password: $e");
      if (!context.mounted) return;
      showAppSnackBar(context, notificationText['unexpectedError']![lang]!, SnackBarType.failure);
    }
  }
}