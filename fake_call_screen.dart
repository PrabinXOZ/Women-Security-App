import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FakeCallScreen extends StatefulWidget {
  const FakeCallScreen({Key? key}) : super(key: key);

  @override
  _FakeCallScreenState createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  bool _inCall = false;
  Duration _callDuration = Duration.zero;
  Timer? _timer;
  late AudioPlayer _audioPlayer;
  String _callerName = 'Mom';

  final TextEditingController _callerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playRingtone();
  }

  Future<void> _playRingtone() async {
    await _audioPlayer.play(AssetSource('audio/fake_ringtone.mp3'));
  }

  Future<void> _stopRingtone() async {
    await _audioPlayer.stop();
  }

  void _startCall() {
    _stopRingtone();
    setState(() {
      _inCall = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration = Duration(seconds: _callDuration.inSeconds + 1);
      });
    });
  }

  void _endCall() {
    _stopRingtone();
    _timer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _callerNameController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildActionButton(String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blueAccent,
          radius: 40,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))
      ],
    );
  }

  // Function to allow name editing
  void _editCallerName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Caller Name'),
          content: TextField(
            controller: _callerNameController,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _callerName = _callerNameController.text.isEmpty
                      ? _callerName
                      : _callerNameController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _inCall ? _buildActiveCallUI() : _buildIncomingCallUI(),
      ),
    );
  }

  Widget _buildIncomingCallUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.account_circle, size: 120, color: Colors.white),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _editCallerName, // Trigger name editing
          child: Text(
            _callerName,
            style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Incoming Call...', style: TextStyle(color: Colors.white70, fontSize: 18)),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCallControlButton(Icons.call_end, Colors.red, _endCall),
            const SizedBox(width: 60),
            _buildCallControlButton(Icons.call, Colors.green, _startCall),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveCallUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.account_circle, size: 120, color: Colors.white),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _editCallerName, // Trigger name editing
          child: Text(
            _callerName,
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Text(_formatDuration(_callDuration), style: const TextStyle(color: Colors.white70, fontSize: 18)),
        const SizedBox(height: 40),
        // Row 1: Mute, Keypad, Speaker
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton('Mute', Icons.mic_off),
            const SizedBox(width: 40),
            _buildActionButton('Keypad', Icons.dialpad),
            const SizedBox(width: 40),
            _buildActionButton('Speaker', Icons.volume_up),
          ],
        ),
        const SizedBox(height: 30),
        // Row 2: Add Call, FaceTime, Contacts
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton('Add Call', Icons.add_call),
            const SizedBox(width: 40),
            _buildActionButton('FaceTime', Icons.video_call),
            const SizedBox(width: 40),
            _buildActionButton('Contacts', Icons.contacts),
          ],
        ),
        const SizedBox(height: 60),
        _buildCallControlButton(Icons.call_end, Colors.red, _endCall),
      ],
    );
  }

  Widget _buildCallControlButton(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        backgroundColor: color,
        radius: 45,
        child: Icon(icon, color: Colors.white, size: 35),
      ),
    );
  }
}
