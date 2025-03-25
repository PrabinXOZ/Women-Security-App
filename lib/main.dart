import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Import the Welcome Screen

void main() {
  runApp(const MyApp()); // Run the app starting with MyApp()
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(), // Set WelcomeScreen as the first screen
    );
  }
}