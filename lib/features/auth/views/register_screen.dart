import 'package:flutter/material.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:looninary/core/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:looninary/core/utils/language_provider.dart';

// --- Language enum & Text Map ---
enum AppLanguage { en, vi }

final Map<String, Map<AppLanguage, String>> localizedText = {
  'createAccount': {
    AppLanguage.en: 'Create Account',
    AppLanguage.vi: 'Tạo Tài Khoản',
  },
  'email': {
    AppLanguage.en: 'Email',
    AppLanguage.vi: 'Email',
  },
  'password': {
    AppLanguage.en: 'Password',
    AppLanguage.vi: 'Mật khẩu',
  },
  'confirmPassword': {
    AppLanguage.en: 'Confirm Password',
    AppLanguage.vi: 'Nhập lại mật khẩu',
  },
  'register': {
    AppLanguage.en: 'Register',
    AppLanguage.vi: 'Đăng ký',
  },
  'alreadyHaveAccount': {
    AppLanguage.en: 'Already have an account?',
    AppLanguage.vi: 'Đã có tài khoản?',
  },
  'signIn': {
    AppLanguage.en: 'Sign in',
    AppLanguage.vi: 'Đăng nhập',
  },
  'emptyEmail': {
    AppLanguage.en: 'Email cannot be empty',
    AppLanguage.vi: 'Không được để trống email',
  },
  'emptyPassword': {
    AppLanguage.en: 'Password cannot be empty',
    AppLanguage.vi: 'Không được để trống mật khẩu',
  },
  'emptyConfirm': {
    AppLanguage.en: 'Confirm Password cannot be empty',
    AppLanguage.vi: 'Không được để trống xác thực mật khẩu',
  },
  'notMatch': {
    AppLanguage.en: 'Passwords do not match',
    AppLanguage.vi: 'Mật khẩu không khớp',
  },
  'languageSwitchedEn': {
    AppLanguage.en: 'Language switched to English',
    AppLanguage.vi: 'Đã chuyển sang tiếng Anh',
  },
  'languageSwitchedVi': {
    AppLanguage.en: 'Language switched to Vietnamese',
    AppLanguage.vi: 'Đã chuyển sang tiếng Việt',
  },
};

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
    final languageProvider = Provider.of<LanguageProvider>(context);
    final _currentLanguage = languageProvider.language == 'vi' ? AppLanguage.vi : AppLanguage.en;

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
                      // Nút chuyển ngôn ngữ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.language, color: Colors.white),
                            onPressed: () {
                              final nextLang = _currentLanguage == AppLanguage.en ? 'vi' : 'en';
                              languageProvider.setLanguage(nextLang);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    nextLang == 'en'
                                        ? localizedText['languageSwitchedEn']![AppLanguage.en]!
                                        : localizedText['languageSwitchedVi']![AppLanguage.vi]!,
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        localizedText['createAccount']![_currentLanguage]!,
                        style: const TextStyle(
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
                          labelText: localizedText['email']![_currentLanguage]!,
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
                          labelText: localizedText['password']![_currentLanguage]!,
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
                          labelText: localizedText['confirmPassword']![_currentLanguage]!,
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
                            showAppSnackBar(
                              context,
                              localizedText['emptyEmail']![_currentLanguage]!,
                              SnackBarType.failure,
                            );
                            return;
                          }
                          if (_passwordController.text.isEmpty) {
                            showAppSnackBar(
                              context,
                              localizedText['emptyPassword']![_currentLanguage]!,
                              SnackBarType.failure,
                            );
                            return;
                          }
                          if (_confirmPasswordController.text.isEmpty) {
                            showAppSnackBar(
                              context,
                              localizedText['emptyConfirm']![_currentLanguage]!,
                              SnackBarType.failure,
                            );
                            return;
                          }
                          if (_passwordController.text != _confirmPasswordController.text) {
                            showAppSnackBar(
                              context,
                              localizedText['notMatch']![_currentLanguage]!,
                              SnackBarType.failure,
                            );
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
                        child: Text(
                          localizedText['register']![_currentLanguage]!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                                AppColors.mauve.withOpacity(0.1)),
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return AppColors.mauve;
                                }
                                return Colors.white;
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
                              text:
                                  localizedText['alreadyHaveAccount']![_currentLanguage]! +
                                      ' ',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                  text:
                                      localizedText['signIn']![_currentLanguage]!,
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