import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BmiApp());
}

class BmiApp extends StatelessWidget {
  const BmiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Tracker',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 0, 0),
        scaffoldBackgroundColor: const Color(0xFFFFF8E8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB8E0D2),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF444444)),
          bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF666666)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC1A1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
