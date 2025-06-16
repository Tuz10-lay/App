import 'package:flutter/material.dart';
import 'package:looninary/core/widgets/social_icon_button.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/core/widgets/app_elevated_button.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Welcome to Looninary ✨",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_rounded),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      _togglePasswordVisibility();
                    },
                  ),
                ),
                obscureText: _isObscure,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AppElevatedButton(
                    text: "Log in",
                    onPressed: () {
                      _authController.logIn(
                        context,
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                  ),
                  AppElevatedButton(
                    text: "Sign up",
                    onPressed: () {
                      _authController.signUp(
                        context,
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  AppElevatedButton(
                    text: "Continue as Guest",
                    onPressed: () {
                      _authController.signInAnonymously(context);
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialIconButton(
                        iconPath: 'assets/icons/google_logo.png',
                        onTap: () {
                          _authController.signInWithOAuth(
                            context,
                            OAuthProvider.google,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      SocialIconButton(
                        iconPath: 'assets/icons/github_logo.png',
                        onTap: () {
                          _authController.signInWithOAuth(
                            context,
                            OAuthProvider.github,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
