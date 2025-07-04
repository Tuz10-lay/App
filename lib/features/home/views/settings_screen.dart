import 'package:flutter/material.dart';
import 'package:looninary/core/theme/theme_provider.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:looninary/core/widgets/app_snack_bar.dart';

class SettingsScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;
  const SettingsScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
    }
  }

  void _showLanguagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(widget.currentLanguage == 'en' ? 'Select Language' : 'Chọn ngôn ngữ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                onTap: () {
                  widget.onLanguageChanged('en');
                  Navigator.pop(context);
                  showAppSnackBar(
                    context,
                    'Language changed to English',
                    SnackBarType.success,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Tiếng Việt'),
                onTap: () {
                  widget.onLanguageChanged('vi');
                  Navigator.pop(context);
                  showAppSnackBar(
                    context,
                    'Đã chuyển sang Tiếng Việt',
                    SnackBarType.success,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = AuthController();

    final texts = {
      'general': widget.currentLanguage == 'en' ? 'General' : 'Chung',
      'darkMode': widget.currentLanguage == 'en' ? 'Dark Mode' : 'Chế độ tối',
      'language': widget.currentLanguage == 'en' ? 'Language' : 'Ngôn ngữ',
      'account': widget.currentLanguage == 'en' ? 'Account' : 'Tài khoản',
      'accountInfo': widget.currentLanguage == 'en' ? 'Account Information' : 'Thông tin tài khoản',
      'logout': widget.currentLanguage == 'en' ? 'Log Out' : 'Đăng xuất',
      'about': widget.currentLanguage == 'en' ? 'About' : 'Về ứng dụng',
      'sourceCode': widget.currentLanguage == 'en' ? 'Source Code' : 'Mã nguồn',
      'english': 'English',
      'vietnamese': 'Tiếng Việt',
    };

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      children: [
        // --- GENERAL SETTINGS ---
        _SettingsHeader(title: texts['general']!),
        _SettingsCard(
          children: [
            // Theme Toggle
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return _SettingsTile(
                  icon: themeProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  title: texts['darkMode']!,
                  trailing: Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                      showAppSnackBar(
                        context,
                        widget.currentLanguage == 'en'
                            ? "Theme changed"
                            : "Đã đổi chế độ hiển thị",
                        SnackBarType.success,
                      );
                    },
                  ),
                );
              },
            ),
            const Divider(height: 1),
            // Language
            _SettingsTile(
              icon: Icons.language_outlined,
              title: texts['language']!,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.currentLanguage == 'en'
                        ? texts['english']!
                        : texts['vietnamese']!,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                _showLanguagePicker(context);
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // --- ACCOUNT SETTINGS ---
        _SettingsHeader(title: texts['account']!),
        _SettingsCard(
          children: [
            // Account Information
            _SettingsTile(
              icon: Icons.person_outline,
              title: texts['accountInfo']!,
              onTap: () {
                showAppSnackBar(
                  context,
                  widget.currentLanguage == 'en'
                      ? "Feature coming soon!"
                      : "Tính năng sẽ sớm ra mắt!",
                  SnackBarType.pending,
                );
              },
            ),
            const Divider(height: 1),
            // Log Out
            _SettingsTile(
              icon: Icons.logout,
              iconColor: theme.colorScheme.error,
              title: texts['logout']!,
              textColor: theme.colorScheme.error,
              onTap: () {
                authController.signOut(context);
                // Thông báo sign out sẽ do AuthController xử lý
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // --- ABOUT SECTION ---
        _SettingsHeader(title: texts['about']!),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.code_outlined,
              title: texts['sourceCode']!,
              onTap: () {
                _launchURL('https://github.com/falwyn/looninary');
                showAppSnackBar(
                  context,
                  widget.currentLanguage == 'en'
                      ? "Opening source code..."
                      : "Đang mở mã nguồn...",
                  SnackBarType.pending,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Helper widget for section headers
class _SettingsHeader extends StatelessWidget {
  final String title;
  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

// Helper widget for the card background
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }
}

// Helper widget for a consistent ListTile style
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.arrow_forward_ios, size: 16)
              : null),
      onTap: onTap,
    );
  }
}