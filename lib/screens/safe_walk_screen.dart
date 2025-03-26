import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SafeWalkScreen extends StatefulWidget {
  @override
  _SafeWalkScreenState createState() => _SafeWalkScreenState();
}

class _SafeWalkScreenState extends State<SafeWalkScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  LatLng currentLocation = LatLng(28.6139, 77.2090); // Default to Delhi
  bool _isSharing = false;
  int _fakeDuration = 15; // minutes

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
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLocation,
                      zoom: 15,
                    ),
                    markers: markers,
                    polylines: polylines,
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                        _addMarkers();
                      });
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                  if (_isSharing)
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sharing Live Location',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pink.shade300,
                              ),
                            ),
                            Text(
                              'Estimated time: $_fakeDuration min',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSharing ? Colors.red : Colors.pink.shade200,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                setState(() {
                  _isSharing = !_isSharing;
                  if (_isSharing) {
                    _startFakeTimer();
                  }
                });
              },
              child: Text(
                _isSharing ? 'Stop Sharing' : 'Start Safe Walk',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addMarkers() {
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: currentLocation,
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRose,
          ),
        ),
      );
    });
  }

  void _startFakeTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return; // Prevents state updates when the widget is removed
      if (_isSharing && _fakeDuration > 0) {
        setState(() {
          _fakeDuration--;
        });
        _startFakeTimer();
      } else if (_fakeDuration == 0) {
        setState(() {
          _isSharing = false;
          _fakeDuration = 15;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have reached your destination safely!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
