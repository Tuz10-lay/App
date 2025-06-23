import 'package:flutter/material.dart';
import 'package:looninary/core/services/auth_service.dart';
import 'package:looninary/features/auth/views/login_screen.dart';
import 'package:looninary/features/home/views/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _authService = AuthService();

  // Thêm state để quản lý màn hình auth hiện tại
  AuthScreen _currentScreen = AuthScreen.login;

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    if (!kIsWeb) {
      await _authService.restoreSession();
    }
  }

  void _showLogin() {
    setState(() {
      _currentScreen = AuthScreen.login;
    });
  }

  void _showRegister() {
    setState(() {
      _currentScreen = AuthScreen.register;
    });
  }

  void _showForgotPassword() {
    setState(() {
      _currentScreen = AuthScreen.forgotPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // Quản lý điều hướng auth tập trung tại đây
          switch (_currentScreen) {
            case AuthScreen.login:
              return LoginScreen(
                onShowRegister: _showRegister,
                onShowForgotPassword: _showForgotPassword,
              );
            case AuthScreen.register:
              return RegisterScreen(
                onShowLogin: _showLogin,
              );
            case AuthScreen.forgotPassword:
              return ForgotPasswordScreen(
                onShowLogin: _showLogin,
              );
          }
        }
      },
    );
  }
}

enum AuthScreen { login, register, forgotPassword }
