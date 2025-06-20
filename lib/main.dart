import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_theme.dart';
import 'package:looninary/features/auth/views/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tzwuzjvpzrikxmmiltqy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6d3V6anZwenJpa3htbWlsdHF5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk4NzUxMDEsImV4cCI6MjA2NTQ1MTEwMX0.PVnj3ldngFVCUztGv90DiZ_LqTrE7AHcRFbJ4ppHgeA',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Looninary',
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

