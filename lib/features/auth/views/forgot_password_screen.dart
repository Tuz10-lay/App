import 'package:flutter/material.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:looninary/core/theme/theme_swithcher_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback? onShowLogin;
  const ForgotPasswordScreen({super.key, this.onShowLogin});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
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
                      'Forgot Password',
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Email input với Container bo góc và nền nhạt
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        await _authController.sendPasswordReset(
                          context,
                          _emailController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Send Password Reset Email',
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: TextButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0)),
                            overlayColor: WidgetStateProperty.all(colorScheme.primary.withOpacity(0.1)),
                            foregroundColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return colorScheme.primary;
                                }
                                return colorScheme.onBackground;
                              },
                            ),
                          ),
                          onPressed: () {
                            if (widget.onShowLogin != null) {
                              widget.onShowLogin!();
                            }
                          },
                          child: Text(
                            'Back to Sign in',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onBackground,
                              fontWeight: FontWeight.w500,
                            ),
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
      floatingActionButton: const ThemeSwitcherButton(),
    );
  }
}
