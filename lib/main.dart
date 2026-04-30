import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:handsingdetection/screens/splash_screen.dart';
import 'package:handsingdetection/theme/app_theme.dart';
import 'package:handsingdetection/theme/theme_provider.dart';
import 'package:handsingdetection/theme/haptic_provider.dart';

void main() {
  print("DEBUG: App execution started (main.dart)");
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HapticProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("DEBUG: Building MyApp");
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GestureAI',
      theme:     AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
