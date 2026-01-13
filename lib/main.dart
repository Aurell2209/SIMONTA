import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SimontaApp());
}

class SimontaApp extends StatelessWidget {
  const SimontaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMONTA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
