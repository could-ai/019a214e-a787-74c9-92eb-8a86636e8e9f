import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BirthdayWishApp());
}

class BirthdayWishApp extends StatelessWidget {
  const BirthdayWishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cute Birthday Wishes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
    );
  }
}