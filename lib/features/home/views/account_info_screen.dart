import 'package:flutter/material.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:looninary/core/widgets/app_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountInfoScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged; // Không dùng nữa, nhưng có thể giữ để đồng bộ callback
  const AccountInfoScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final texts = _getTexts();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authController.updateUserPassword(
        context,
        _newPasswordController.text,
        currentPassword: _oldPasswordController.text,
      );
      showAppSnackBar(
        context,
        texts['passwordChanged']!,
        SnackBarType.success,
      );
    } catch (e) {
      showAppSnackBar(
        context,
        texts['passwordChangeFailed']!,
        SnackBarType.failure,
      );
    }
    setState(() => _isLoading = false);
  }

  Map<String, String> _getTexts() {
    final isEn = widget.currentLanguage == 'en';
    return {
      'title': isEn ? 'Account Information' : 'Thông tin tài khoản',
      'email': isEn ? 'Email' : 'Email',
      'changePassword': isEn ? 'Change Password' : 'Đổi mật khẩu',
      'oldPassword': isEn ? 'Current Password' : 'Mật khẩu hiện tại',
      'newPassword': isEn ? 'New Password' : 'Mật khẩu mới',
      'confirmPassword': isEn ? 'Confirm Password' : 'Xác nhận mật khẩu',
      'save': isEn ? 'Save' : 'Lưu',
      'cancel': isEn ? 'Cancel' : 'Hủy',
      'passwordChanged': isEn ? 'Password changed successfully!' : 'Đổi mật khẩu thành công!',
      'passwordChangeFailed': isEn ? 'Password change failed!' : 'Đổi mật khẩu thất bại!',
      'language': isEn ? 'Language' : 'Ngôn ngữ',
      'emptyPassword': isEn ? 'Please enter password' : 'Vui lòng nhập mật khẩu',
      'matchPassword': isEn ? 'Passwords do not match' : 'Mật khẩu không khớp',
    };
  }

  @override
  Widget build(BuildContext context) {
    final texts = _getTexts();
    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(texts['title']!),
        // ĐÃ BỎ NÚT CHUYỂN NGÔN NGỮ
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(texts['email']!),
              subtitle: Text(userEmail),
            ),
            const Divider(height: 32),
            Text(
              texts['changePassword']!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: texts['oldPassword']),
                    validator: (v) =>
                        v == null || v.isEmpty ? texts['emptyPassword'] : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: texts['newPassword']),
                    validator: (v) =>
                        v == null || v.isEmpty ? texts['emptyPassword'] : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: texts['confirmPassword']),
                    validator: (v) =>
                        v != _newPasswordController.text ? texts['matchPassword'] : null,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _changePassword,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(texts['save']!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}