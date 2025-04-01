import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

class SafeWalkScreen extends StatefulWidget {
  @override
  _SafeWalkScreenState createState() => _SafeWalkScreenState();
}

class _SafeWalkScreenState extends State<SafeWalkScreen> {
  GoogleMapController? mapController;
  Marker? _userMarker;
  Stream<Position>? _positionStream;
  bool _isTracking = false;
  bool _shareLocation = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    _startTracking();
  }

  void _startTracking() {
    setState(() => _isTracking = true);
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    _positionStream!.listen((Position position) {
      LatLng latLng = LatLng(position.latitude, position.longitude);
      _userMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      );

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
      }

      if (_shareLocation) {
        _sendLiveLocation(position);
      }

      setState(() {});
    });
  }

  void _stopTracking() {
    _positionStream = null;
    setState(() => _isTracking = false);
  }

  Future<void> _sendLiveLocation(Position position) async {
    var status = await Permission.sms.request();
    if (!status.isGranted) return;

    String locationLink = "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    String message = "📍 Live location update: $locationLink";

    List<String> recipients = [
      '+919876543210',
      '+919876543211',
    ];

    try {
      await sendSMS(message: message, recipients: recipients, sendDirect: true);
    } catch (_) {}
  }

  @override
  void dispose() {
    _stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
        title: const Text('Safe Walk'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(28.6139, 77.2090),
                  zoom: 15,
                ),
                markers: _userMarker != null ? {_userMarker!} : {},
                onMapCreated: (controller) => mapController = controller,
                myLocationButtonEnabled: true,
                myLocationEnabled: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Share location",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _shareLocation,
                      onChanged: (value) {
                        setState(() => _shareLocation = value);
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _isTracking ? _stopTracking : _startTracking,
                  icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
                  label: Text(_isTracking ? 'Stop Tracking' : 'Start Safe Walk'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}