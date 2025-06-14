import 'package:flutter/material.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text("Hi there!"),
      )
    );
  }
}
