// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

class QuickAlertsScreen extends StatefulWidget {
  @override
  _QuickAlertsScreenState createState() => _QuickAlertsScreenState();
}

class _QuickAlertsScreenState extends State<QuickAlertsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, dynamic>> alertOptions = [
    {'title': 'Emergency Alert', 'icon': Icons.warning_amber_rounded, 'color': Colors.red, 'action': 'sos'},
    {'title': 'Fake Call', 'icon': Icons.phone, 'color': Colors.blue, 'action': 'fake_call'},
    {'title': 'Share Location', 'icon': Icons.location_on, 'color': Colors.green, 'action': 'location'},
    {'title': 'Sound Alarm', 'icon': Icons.alarm, 'color': Colors.orange, 'action': 'alarm'},
  ];

  void _handleAction(String action) {
    switch (action) {
      case 'sos':
        sendSOSMessage();
        break;
      case 'fake_call':
        Navigator.pushNamed(context, '/fake-call');
        break;
      case 'location':
        shareLocation();
        break;
      case 'alarm':
        playAlarm();
        break;
      default:
        break;
    }
  }

  Future<void> playAlarm() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔊 Alarm activated!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play alarm: $e')),
      );
    }
  }

  Future<String?> getCurrentLocationLink() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
  }

  Future<void> sendSOSMessage() async {
    var status = await Permission.sms.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SMS permission denied')),
      );
      return;
    }

    String? locationLink = await getCurrentLocationLink();
    if (locationLink == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to get location')),
      );
      return;
    }

    String message = "🚨 Emergency! I need help. Here's my location:\n$locationLink";

    List<String> recipients = [
      '+919876543210',
      '+919876543211',
    ];

    try {
      await sendSMS(message: message, recipients: recipients, sendDirect: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🚨 SOS sent to contacts!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send SMS: $e')),
      );
    }
  }

  Future<void> shareLocation() async {
    String? locationLink = await getCurrentLocationLink();
    if (locationLink != null) {
      final uri = Uri.parse(locationLink);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open location: $locationLink')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Quick Alerts',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: alertOptions.length,
          itemBuilder: (context, index) {
            final alert = alertOptions[index];
            return GestureDetector(
              onTap: () => _handleAction(alert['action']),
              child: Container(
                decoration: BoxDecoration(
                  color: alert['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: alert['color'], width: 1.5),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(alert['icon'], size: 40, color: alert['color']),
                    const SizedBox(height: 12),
                    Text(
                      alert['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}