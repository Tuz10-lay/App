import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_colors.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthController _authController = AuthController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16.0), children: []);
  }
}

Widget _buildSettingsCard({
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: Colors.blue)]),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: Colors.blue)),
        ],
      ),
    ),
  );
}
