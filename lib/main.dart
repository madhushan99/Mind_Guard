import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth/splash_screen.dart';
import 'theme/app_theme.dart';
import 'services/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const MindGuardApp());
}

class MindGuardApp extends StatefulWidget {
  const MindGuardApp({super.key});

  static _MindGuardAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MindGuardAppState>();
  }

  @override
  State<MindGuardApp> createState() => _MindGuardAppState();
}

class _MindGuardAppState extends State<MindGuardApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Guard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: const SplashScreen(),
    );
  }
}