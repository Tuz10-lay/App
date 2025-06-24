import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthController _authController = AuthController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _currentPasswordController = TextEditingController();

  bool _passwordEditAllowed = false;

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSettingsCard(
          title: 'Change Email',
          icon: Icons.email,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'New Email',
                  hintText: 'Enter your new email address',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_emailController.text.isNotEmpty) {
                    _authController.updateUserEmail(
                      context,
                      _emailController.text.trim(),
                    );
                    _emailController.clear();
                  }
                },
                child: const Text('Update Email'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSettingsCard(
          title: 'Change Password',
          icon: Icons.lock,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current password',
                  hintText: 'Enter current password',
                ),
                onChanged: (value) {
                  setState(() {
                    _passwordEditAllowed = value.isNotEmpty;
                  });
                },

              ),
              const SizedBox(height: 20),
              TextFormField(
                enabled: _passwordEditAllowed,
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _passwordEditAllowed && _passwordController.text.isNotEmpty
                    ? () {
                        // Gửi cả mật khẩu cũ và mới cho controller xử lý
                        _authController.updateUserPassword(
                          context,
                          _passwordController.text.trim(),
                          currentPassword: _currentPasswordController.text.trim(),
                        );
                        _passwordController.clear();
                        _currentPasswordController.clear();
                        setState(() {
                          _passwordEditAllowed = false;
                        });
                      }
                    : null,

                child: const Text('Update Password'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildSettingsCard({
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.sapphire),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.sapphire,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );
}
