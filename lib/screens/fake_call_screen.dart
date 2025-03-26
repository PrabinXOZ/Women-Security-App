import 'package:flutter/material.dart';

class FakeCallScreen extends StatefulWidget {
  @override
  _FakeCallScreenState createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  bool _isCallActive = false;
  String _callerName = 'Mom';
  String _callTime = '00:00';
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Fake Call'),
              centerTitle: true,
            ),
            Expanded(
              child: Center(
                child: _isCallActive
                    ? _buildActiveCallUI()
                    : _buildCallOptions(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Trigger a fake call when you feel unsafe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.pink.shade300,
            minimumSize: Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            setState(() {
              _isCallActive = true;
              _startTimer();
            });
          },
          child: Text(
            'Start Fake Call',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Customize caller name in settings',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveCallUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 60,
            color: Colors.pink.shade300,
          ),
        ),
        SizedBox(height: 20),
        Text(
          _callerName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          _callTime,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                setState(() {
                  _isCallActive = false;
                  _seconds = 0;
                });
              },
              child: Icon(Icons.call_end),
            ),
          ],
        ),
      ],
    );
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_isCallActive) {
        setState(() {
          _seconds++;
          _callTime = '${(_seconds ~/ 60).toString().padLeft(2, '0')}:'
              '${(_seconds % 60).toString().padLeft(2, '0')}';
        });
        _startTimer();
      }
    });
  }
}