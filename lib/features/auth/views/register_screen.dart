import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:looninary/core/widgets/app_snack_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.midnight,
              AppColors.mauve,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white70, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white70, width: 2.0),
                          ),
                          prefixIcon: const Icon(Icons.email_rounded, color: Colors.white54),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white70, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white70, width: 2.0),
                          ),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white70, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white70, width: 2.0),
                          ),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white54),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_emailController.text.isEmpty) {
                            showAppSnackBar(context, 'Email cannot be empty', SnackBarType.failure);
                            return;
                          }
                          if (_passwordController.text.isEmpty) {
                            showAppSnackBar(context, 'Password cannot be empty', SnackBarType.failure);
                            return;
                          }
                          if (_confirmPasswordController.text.isEmpty) {
                            showAppSnackBar(context, 'Confirm Password cannot be empty', SnackBarType.failure);
                            return;
                          }
                          if (_passwordController.text != _confirmPasswordController.text) {
                            showAppSnackBar(context, 'Passwords do not match', SnackBarType.failure);
                            return;
                          }
                          await _authController.register(
                            context,
                            _emailController.text,
                            _passwordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mauve,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(AppColors.mauve.withOpacity(0.1)),
                            foregroundColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return AppColors.mauve;
                                }
                                return Colors.white;
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                  text: 'Sign in',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
