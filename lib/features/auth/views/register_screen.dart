import 'package:flutter/material.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/core/widgets/app_snack_bar.dart';
import 'package:looninary/core/theme/theme_swithcher_button.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onShowLogin;
  const RegisterScreen({super.key, this.onShowLogin});

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                      Text(
                        'Create Account',
                        style: textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Email
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _emailController,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email_rounded, color: colorScheme.onSurface.withOpacity(0.7)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock, color: colorScheme.onSurface.withOpacity(0.7)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure ? Icons.visibility_off : Icons.visibility,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Confirm Password
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: _isObscure,
                          style: TextStyle(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock, color: colorScheme.onSurface.withOpacity(0.7)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure ? Icons.visibility_off : Icons.visibility,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          ),
                        ),
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
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(colorScheme.primary.withOpacity(0.1)),
                            foregroundColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return colorScheme.primary;
                                }
                                return colorScheme.primary;
                              },
                            ),
                          ),
                          onPressed: () {
                            if (widget.onShowLogin != null) {
                              widget.onShowLogin!();
                            }
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onBackground.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign in',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
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
      floatingActionButton: const ThemeSwitcherButton(),
    );
  }
}
