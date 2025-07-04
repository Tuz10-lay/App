import 'package:flutter/material.dart';
import 'package:looninary/core/theme/app_theme.dart';
import 'package:looninary/core/theme/theme_provider.dart';
import 'package:looninary/core/utils/language_provider.dart';
import 'package:looninary/features/auth/views/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Ensure that Flutter widgets are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase for backend services.
  await Supabase.initialize(
    url: 'https://tzwuzjvpzrikxmmiltqy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6d3V6anZwenJpa3htbWlsdHF5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk4NzUxMDEsImV4cCI6MjA2NTQ1MTEwMX0.PVnj3ldngFVCUztGv90DiZ_LqTrE7AHcRFbJ4ppHgeA',
  );

  // We wrap our app with ChangeNotifierProvider.
  // This makes the ThemeProvider instance available to the entire widget tree.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a Consumer widget to listen to changes in our ThemeProvider.
    // The 'builder' function will re-run whenever notifyListeners() is called in the provider.
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Looninary',
          // Set the light theme data.
          theme: AppTheme.lightTheme,
          // Set the dark theme data.
          darkTheme: AppTheme.darkTheme,
          // The themeMode determines which theme to use.
          // We get this value from our themeProvider.
          themeMode: themeProvider.themeMode,
          // The entry point of your app's UI.
          home: const AuthGate(),
          // Hide the debug banner in the top-right corner.
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
