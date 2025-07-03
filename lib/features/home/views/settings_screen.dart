import 'package:flutter/material.dart';
import 'package:looninary/core/theme/theme_provider.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authController = AuthController();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      children: [
        // --- GENERAL SETTINGS ---
        _SettingsHeader(title: 'General'),
        _SettingsCard(
          children: [
            // Theme Toggle
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return _SettingsTile(
                  icon: themeProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                );
              },
            ),
            const Divider(height: 1),
            // Language (Placeholder)
            _SettingsTile(
              icon: Icons.language_outlined,
              title: 'Language',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'English',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                // Non-functional for now
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // --- ACCOUNT SETTINGS ---
        _SettingsHeader(title: 'Account'),
        _SettingsCard(
          children: [
            // Account Information (Placeholder)
            _SettingsTile(
              icon: Icons.person_outline,
              title: 'Account Information',
              onTap: () {
                // Non-functional for now
              },
            ),
            const Divider(height: 1),
            // Log Out
            _SettingsTile(
              icon: Icons.logout,
              iconColor: theme.colorScheme.error,
              title: 'Log Out',
              textColor: theme.colorScheme.error,
              onTap: () {
                authController.signOut(context);
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // --- ABOUT SECTION ---
        _SettingsHeader(title: 'About'),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.code_outlined,
              title: 'Source Code',
              onTap: () {
                // REMINDER: Replace with your actual GitHub repository URL
								_launchURL('https://github.com/falwyn/looninary');
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Helper widget for section headers (e.g., "General", "Account")
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
