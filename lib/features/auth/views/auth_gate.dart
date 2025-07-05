import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'package:looninary/core/services/auth_service.dart';
import 'package:looninary/core/utils/language_provider.dart';

import 'package:looninary/features/auth/views/login_screen.dart';
import 'package:looninary/features/auth/views/register_screen.dart';
import 'package:looninary/features/auth/views/forgot_password_screen.dart';
import 'package:looninary/features/home/views/home_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _authService = AuthService();

  // Quản lý màn hình auth hiện tại: login / register / forgotPassword
  AuthScreen _currentScreen = AuthScreen.login;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    if (!kIsWeb) {
      await _authService.restoreSession();
    }
  }

  // Chuyển màn hình
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final AuthState? authState = snapshot.data;
        final lang = Provider.of<LanguageProvider>(context).language;

        if (authState != null && authState.session != null) {
          return HomePage(initialLanguage: lang);
        } else {
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

// Enum dùng để xác định màn hình auth hiện tại
enum AuthScreen { login, register, forgotPassword }
