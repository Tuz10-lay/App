import 'package:flutter/material.dart';
import 'package:looninary/features/auth/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final AuthController _authController = AuthController();

  final User? user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Looninary"),
        actions: [
          IconButton(
            onPressed: () {
              _authController.signOut(context);
            },
            icon: Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: Center(
        child: Text(
          user != null
              ? "Welcome back, ${user!.email ?? "Adventure without the email!"}"
              : "Welcom to Looninary",
        ),
      ),
    );
  }
}
