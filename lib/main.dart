import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/otp_success_screen.dart';
import 'screens/home_screen.dart';
import 'screens/emergency_contacts_screen.dart';
import 'screens/fake_call_screen.dart';
import 'screens/safe_walk_screen.dart';
import 'screens/quick_alerts_screen.dart';
import 'screens/trusted_contacts_screen.dart';
import 'screens/emergency_protocols_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink.shade300,
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink.shade300,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade200,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(10),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  WelcomeScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/login': (context) =>  LoginScreen(),
        '/otp': (context) =>  OtpVerificationScreen(),
        '/otp-success': (context) =>  OtpSuccessScreen(),
        '/home': (context) =>  HomeScreen(),
        '/emergency-contacts': (context) =>  EmergencyContactsScreen(),
        '/fake-call': (context) =>  FakeCallScreen(),
        '/safe-walk': (context) =>  SafeWalkScreen(),
        '/quick-alerts': (context) =>  QuickAlertsScreen(),
        '/trusted-contacts': (context) =>  TrustedContactsScreen(),
        '/emergency-protocols': (context) =>  EmergencyProtocolsScreen(),
      },
    );
  }
}