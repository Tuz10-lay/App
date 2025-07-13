import 'package:flutter/material.dart';
import 'package:looninary/core/widgets/social_icon_button.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:looninary/features/home/views/home_page.dart';
import 'package:provider/provider.dart';
import 'package:looninary/core/utils/language_provider.dart';

// --- Language enum & Text Map ---
enum AppLanguage { en, vi }

final Map<String, Map<AppLanguage, String>> localizedText = {
  'signIn': {
    AppLanguage.en: 'Sign in',
    AppLanguage.vi: 'Đăng nhập',
  },
  'signInWithSocial': {
    AppLanguage.en: 'Sign in with a social account',
    AppLanguage.vi: 'Đăng nhập bằng tài khoản mạng xã hội',
  },
  'email': {
    AppLanguage.en: 'Email',
    AppLanguage.vi: 'Email',
  },
  'password': {
    AppLanguage.en: 'Password',
    AppLanguage.vi: 'Mật khẩu',
  },
  'forgotPassword': {
    AppLanguage.en: 'Forgot password?',
    AppLanguage.vi: 'Quên mật khẩu?',
  },
  'signUp': {
    AppLanguage.en: 'Sign up',
    AppLanguage.vi: 'Đăng ký',
  },
  'useWithoutSigningIn': {
    AppLanguage.en: 'Use without signing in',
    AppLanguage.vi: 'Dùng mà không cần đăng nhập',
  },
  'dontHaveAccount': {
    AppLanguage.en: "Don't have an account?",
    AppLanguage.vi: "Chưa có tài khoản?",
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
    final languageProvider = Provider.of<LanguageProvider>(context);

    // Luôn đồng bộ ngôn ngữ với Provider
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
                    mainAxisSize: MainAxisSize.min,
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
                              // Hiện thông báo chuyển ngôn ngữ
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
                      const SizedBox(height: 24),
                      Text(
                        localizedText['signIn']![_currentLanguage]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizedText['signInWithSocial']![_currentLanguage]!,
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
                            labelText: localizedText['email']![_currentLanguage]!,
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
                            labelText: localizedText['password']![_currentLanguage]!,
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
                          child: Text(
                            localizedText['forgotPassword']![_currentLanguage]!,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                          onPressed: () async {
                            final success = await _authController.logIn(
                              context,
                              _emailController.text,
                              _passwordController.text,
                            );
                            // Khi đăng nhập thành công
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    initialLanguage: languageProvider.language,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mauve,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                localizedText['signIn']![_currentLanguage]!,
                                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              const CircleAvatar(
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
                          child: Text(
                            localizedText['useWithoutSigningIn']![_currentLanguage]!,
                            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
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
                                  return AppColors.mauve;
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
                              text: localizedText['dontHaveAccount']![_currentLanguage]! + " ",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: localizedText['signUp']![_currentLanguage]!,
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