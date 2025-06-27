import 'package:flutter/material.dart';
import 'package:looninary/core/widgets/social_icon_button.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onShowRegister;
  final VoidCallback? onShowForgotPassword;
  const LoginScreen({super.key, this.onShowRegister, this.onShowForgotPassword});

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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Sign in',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in with a social account',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SocialIconButton(
                            iconPath: 'assets/icons/google_logo.png',
                            onTap: () {
                              _authController.signInWithOAuth(
                                context,
                                OAuthProvider.google,
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          SocialIconButton(
                            iconPath: 'assets/icons/github_logo.png',
                            onTap: () {
                              _authController.signInWithOAuth(
                                context,
                                OAuthProvider.github,
                              );
                            },
                          ),

                          const SizedBox(width: 12),
                          SocialIconButton(
                            iconPath: 'assets/icons/fb_logo.png',
                            onTap: () {
                              _authController.signInWithOAuth(
                                context,
                                OAuthProvider.facebook,
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          SocialIconButton(
                            iconPath: 'assets/icons/x_logo.png',
                            onTap: () {
                              _authController.signInWithOAuth(
                                context,
                                OAuthProvider.twitter,
                              );
                            },
                          ),

                        ],
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.email_rounded, color: Colors.white54),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white70),
                            border: InputBorder.none,
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
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            if (widget.onShowForgotPassword != null) {
                              widget.onShowForgotPassword!();
                            }
                          },

                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            _authController.logIn(
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
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 18,
                                child: Icon(Icons.arrow_forward, color: AppColors.mauve),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            _authController.signInAnonymously(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.sapphire,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Use without signing in',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
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
                                  return AppColors.mauve; // Đậm hơn khi nhấn
                                }
                                return AppColors.mauve;
                              },
                            ),
                          ),
                          onPressed: () {
                            if (widget.onShowRegister != null) {
                              widget.onShowRegister!();
                            }
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign up',
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
      floatingActionButton: null,
    );
  }
}
