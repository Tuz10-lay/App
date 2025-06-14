import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // GoTrueClient: a client provided by supabase to hanldes all user authentication tasks
  // Supabase.instance: access the single and globally available instance of your Supabase client
  // .client: get the main SupabaseClient from that instance and .auth is the getter on the client that returns the initialized GoTrueClient
  final GoTrueClient _auth = Supabase.instance.client.auth;

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

  // Log out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get the current user
  User? get currentUser => _auth.currentUser;
}
