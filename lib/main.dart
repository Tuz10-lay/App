import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:looninary/core/theme/app_theme.dart';
import 'package:looninary/core/theme/theme_provider.dart';
import 'package:looninary/core/utils/language_provider.dart';
import 'package:looninary/features/auth/views/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://glcpntqyofxlrnscilqk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdsY3BudHF5b2Z4bHJuc2NpbHFrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIzMjI3MDAsImV4cCI6MjA2Nzg5ODcwMH0.UPLpZJNJg4ECjlTv8IBJdiLq61EQBmgtK9v1nevHdRs',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'Looninary',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const AuthGate(),
          debugShowCheckedModeBanner: false,

          // ---- THÊM 2 DÒNG NÀY ----
          supportedLocales: const [
            Locale('en'),
            Locale('vi'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}