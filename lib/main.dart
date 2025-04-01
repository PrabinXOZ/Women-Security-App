import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_security_app/screens/home_screen.dart';
import 'package:women_security_app/screens/profile_screen.dart' as profile;
import 'package:women_security_app/screens/quick_alerts_screen.dart';
import 'package:women_security_app/screens/fake_call_screen.dart' as fake;
import 'package:women_security_app/screens/emergency_contacts_screen.dart' as emergency;
import 'package:women_security_app/screens/trusted_contacts_screen.dart' as trusted;
import 'package:women_security_app/screens/safe_walk_screen.dart' as walk;
import 'package:women_security_app/screens/emergency_protocols_screen.dart' as protocols;
import 'package:women_security_app/screens/history_log_screen.dart' as history;
import 'package:women_security_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(); // Make sure NotificationService is imported correctly and has a static init() method

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CREEP ZAP',
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => profile.ProfileScreen(),
        '/quick-alerts': (context) => QuickAlertsScreen(),
        '/fake-call': (context) => fake.FakeCallScreen(),
        '/emergency-contacts': (context) => emergency.EmergencyContactsScreen(),
        '/trusted-contacts': (context) => trusted.TrustedContactsScreen(),
        '/safe-walk': (context) => walk.SafeWalkScreen(),
        '/emergency-protocols': (context) => protocols.EmergencyProtocolsScreen(),
        '/history': (context) => history.HistoryLogScreen(),
      },
    );
  }
}
