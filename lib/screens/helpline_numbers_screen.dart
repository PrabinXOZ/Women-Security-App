import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelplineNumbersScreen extends StatelessWidget {
  const HelplineNumbersScreen({Key? key}) : super(key: key);

  static const platform = MethodChannel('com.example.dialer'); // Channel name

  void _launchDialer(String number) async {
    try {
      await platform.invokeMethod('openDialer', {'number': number});
    } on PlatformException catch (e) {
      debugPrint("Failed to open dialer: '${e.message}'.");
    }
  }

  Widget _buildContactCard(String name, String number, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.indigoAccent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        title: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(number, style: const TextStyle(fontSize: 16, color: Colors.white70)),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.white),
          tooltip: 'Call $name',
          onPressed: () => _launchDialer(number),
        ),
        leading: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpline Numbers'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildContactCard('Police', '100', Icons.local_police),
          _buildContactCard('Fire Department', '101', Icons.local_fire_department),
          _buildContactCard('Ambulance', '102', Icons.local_hospital),
          _buildContactCard('Women Helpline', '1149', Icons.support),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
