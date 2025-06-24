import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class AuthService {
  // GoTrueClient: a client provided by supabase to hanldes all user authentication tasks
  // Supabase.instance: access the single and globally available instance of your Supabase client
  // .client: get the main SupabaseClient from that instance and .auth is the getter on the client that returns the initialized GoTrueClient
  final GoTrueClient _auth = Supabase.instance.client.auth;

  final _storage = const FlutterSecureStorage();
  final _sessionKey = 'supabase_session'; // Key for storage

  // Sign up an user
  Future<User?> signUp(String email, String password) async {
    final response = await _auth.signUp(email: email, password: password);
    return response.user;
  }

  // Log in an existing user
  Future<User?> logIn(String email, String password) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    final response = await _auth.signInAnonymously();
    return response.user;
  }

  // Promote an anonymous user to a pernament user
  Future<User?> linkAnonymousUer(String email, String password) async {
    final response = await _auth.updateUser(
      UserAttributes(email: email, password: password),
    );
    return response.user;
  }

  // Generic Social Login (OAuth)
  Future<void> signInWithOAuth(OAuthProvider provider) async {
    await _auth.signInWithOAuth(
      provider,
      redirectTo:
          kIsWeb
              ? 'https://looninary.netlify.app/'
              : 'io.supabase.looninary://callback',
    );
  }

  // Log out the current user
  Future<void> signOut() async {
    await _auth.signOut();
    await _clearSession();
  }

  // Update user email
  Future<void> updateUserEmail(String newEmail) async {
    await _auth.updateUser(UserAttributes(email: newEmail));
  }

  // Update user password
  Future<void> updateUserPassword(String newPassword, {required String currentPassword}) async {
    // TODO: Thực hiện xác thực currentPassword với backend nếu cần
    // Ví dụ: gửi cả currentPassword và newPassword lên API
    // Hiện tại chỉ log ra để minh họa
    print('Current password: $currentPassword, New password: $newPassword');
    // ...gọi API thực tế ở đây...
  }

  // Get the current user
  User? get currentUser => _auth.currentUser;

  // Saves the current user session securely to the device
  Future<void> persistSession() async {
    if (_auth.currentSession != null) {
      await _storage.write(
        key: _sessionKey,
        value: jsonEncode(_auth.currentSession!.toJson()),
      );
    }
  }

  // Tries to restore a session from secure storage
  Future<bool> restoreSession() async {
    final sessionJson = await _storage.read(key: _sessionKey);

    if (sessionJson == null) {
      return false;
    }
    try {
      final sessionMap = jsonDecode(sessionJson) as Map<String, dynamic>;
      final response = await _auth.setSession(sessionMap['refresh_token']);
      if (response.user != null) {
        // Also persist the newly refreshed session
        await persistSession();
        return true;
      }
    } catch (e) {
      // If session is invalid or expired, clear it
      await _clearSession();
    }
    return false;
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.resetPasswordForEmail(email);
  }

  /// Clears the session from secure storage on logout.
  Future<void> _clearSession() async {
    await _storage.delete(key: _sessionKey);
  }
}
