import 'package:flutter/material.dart';
import 'package:looninary/features/auth/views/login_screen.dart';
import 'package:looninary/features/home/views/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Return a StreamBuilder that listens to the auth state changes
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // While waiting for the first event, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final AuthState? authState = snapshot.data;
        // If the user has a session, they are logged in
        if (authState != null && authState.session != null) {
          // Show the HomePage if logged in
          return HomePage();
        } else {
          // Show the LoginScreen if not logged in
          return const LoginScreen();
        }
      },
    );
  }
}
