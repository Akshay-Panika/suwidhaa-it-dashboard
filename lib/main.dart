import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suwidhaa_it_service_dashboard/feature/auth/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Suwidhaa IT Service Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter', // optional — remove if font not added
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}