import 'package:flutter/material.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:looninary/core/utils/language_provider.dart';

// --- Language enum & Text Map ---
enum AppLanguage { en, vi }

final Map<String, Map<AppLanguage, String>> localizedText = {
  'forgotPassword': {
    AppLanguage.en: 'Forgot Password',
    AppLanguage.vi: 'Quên mật khẩu',
  },
  'email': {
    AppLanguage.en: 'Email',
    AppLanguage.vi: 'Email',
  },
  'sendReset': {
    AppLanguage.en: 'Send Password Reset Email',
    AppLanguage.vi: 'Gửi email đặt lại mật khẩu',
  },
  'backToSignIn': {
    AppLanguage.en: 'Back to Sign in',
    AppLanguage.vi: 'Quay lại đăng nhập',
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
                        localizedText['forgotPassword']![_currentLanguage]!,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: localizedText['email']![_currentLanguage]!,
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide:
                                BorderSide(color: Colors.white70, width: 1.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide:
                                BorderSide(color: Colors.white70, width: 2.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
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
                          backgroundColor: AppColors.sapphire,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          localizedText['sendReset']![_currentLanguage]!,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24.0),
                          child: TextButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 0)),
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
                            child: Text(
                              localizedText['backToSignIn']![_currentLanguage]!,
                              style: const TextStyle(
                                color: Colors.white,
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
      ),
    );
  }
}