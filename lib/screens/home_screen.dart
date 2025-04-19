import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'emergency_contacts_screen.dart';
import 'signin_screen.dart';  // Import the SignInScreen for logout navigation

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _sosClickCount = 0;
  late Telephony telephony;
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    telephony = Telephony.instance;
    _getLiveLocation();
  }

  Future<void> _getLiveLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
    }
  }

  void _sendSosMessage() async {
    await _getLiveLocation();

    if (userLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location not available. Please enable location services.")),
      );
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('emergencyContacts')
        .get();

    for (var doc in snapshot.docs) {
      String phoneNumber = doc['phoneNumber'];
      telephony.sendSms(
        to: phoneNumber,
        message:
        'SOS! I need help. My live location is: https://maps.google.com/?q=${userLocation!.latitude},${userLocation!.longitude}',
      );
    }

    if (await Vibrate.canVibrate) {
      final Iterable<Duration> pauses = [Duration(milliseconds: 500), Duration(milliseconds: 1000)];
      Vibrate.vibrateWithPauses(pauses);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SOS messages sent successfully!")),
      );
    }
  }

  void _handleSosTap() async {
    setState(() {
      _sosClickCount++;
    });

    // 1-time vibration after each click
    if (await Vibrate.canVibrate) {
      Vibrate.vibrate();
    }

    // After 5th click, send the SOS message and vibrate for 3 quick intervals of 0.5 seconds
    if (_sosClickCount >= 5) {
      _sendSosMessage();
      setState(() {
        _sosClickCount = 0;
      });

      if (await Vibrate.canVibrate) {
        // Quick 3 vibrations with 0.5-second intervals
        Vibrate.vibrate();
        await Future.delayed(Duration(milliseconds: 500)); // Wait for 0.5 seconds
        Vibrate.vibrate();
        await Future.delayed(Duration(milliseconds: 500)); // Wait for another 0.5 seconds
        Vibrate.vibrate();
      }
    }
  }


  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.contact_page),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmergencyContactsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,  // Logout action
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _handleSosTap,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.6),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _sosClickCount < 5
                  ? 'Press ${5 - _sosClickCount} more times to send SOS'
                  : 'Sending SOS...',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
