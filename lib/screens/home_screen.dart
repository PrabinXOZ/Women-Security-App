import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'emergency_contacts_screen.dart';
import 'fake_call_screen.dart';
import 'protocol_screen.dart';
import 'signin_screen.dart';
import 'helpline_numbers_screen.dart';

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
        message: 'SOS! I need help. Location: https://maps.google.com/?q=${userLocation!.latitude},${userLocation!.longitude}',
      );
    }

    if (await Vibrate.canVibrate) {
      Vibrate.vibrate();
      await Future.delayed(const Duration(milliseconds: 400));
      Vibrate.vibrate();
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

    if (await Vibrate.canVibrate) {
      Vibrate.vibrate();
    }

    if (_sosClickCount >= 5) {
      _sendSosMessage();
      setState(() {
        _sosClickCount = 0;
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed, double width) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 22, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.indigoAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Women Security App', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _logout,
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double buttonWidth = constraints.maxWidth * 0.85;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _handleSosTap,
                  child: Container(
                    width: screenWidth * 0.45,
                    height: screenWidth * 0.45,
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          spreadRadius: 6,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'SOS',
                      style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _sosClickCount < 5
                      ? 'Tap ${5 - _sosClickCount} more times to activate SOS'
                      : 'Sending SOS...',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 35),
                _buildActionButton('Fake Incoming Call', Icons.phone_in_talk, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FakeCallScreen()));
                }, buttonWidth),
                const SizedBox(height: 20),
                _buildActionButton('View Safety Protocols', Icons.shield_moon, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProtocolScreen()));
                }, buttonWidth),
                const SizedBox(height: 20),
                _buildActionButton('Manage Emergency Contacts', Icons.contacts, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()));
                }, buttonWidth),
                const SizedBox(height: 20),
                _buildActionButton('Helpline Numbers', Icons.support_agent, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HelplineNumbersScreen()));
                }, buttonWidth),
              ],
            ),
          );
        },
      ),
    );
  }
}
