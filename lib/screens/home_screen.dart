import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      appBar: AppBar(
        title: const Text('CREEP ZAP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          children: [
            _buildFeatureCard(context, 'Emergency\nContacts', Icons.contacts, Colors.red, '/emergency-contacts'),
            _buildFeatureCard(context, 'Fake Call', Icons.phone, Colors.blue, '/fake-call'),
            _buildFeatureCard(context, 'Safe Walk', Icons.directions_walk, Colors.green, '/safe-walk'),
            _buildFeatureCard(context, 'Quick\nAlerts', Icons.warning, Colors.orange, '/quick-alerts'),
            _buildFeatureCard(context, 'Trusted\nContacts', Icons.contact_emergency, Colors.purple, '/trusted-contacts'),
            _buildFeatureCard(context, 'Emergency\nProtocols', Icons.security, Colors.amber, '/emergency-protocols'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade200,
        onPressed: () => _showEmergencyOptions(context),
        child: const Icon(Icons.emergency),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, String route) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmergencyOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Emergency Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),
              _buildEmergencyOption('Call Police', Icons.local_police, Colors.red, () {}),
              _buildEmergencyOption('Alert Trusted Contacts', Icons.contact_emergency, Colors.purple, () {}),
              _buildEmergencyOption('Sound Alarm', Icons.alarm, Colors.orange, () {}),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildEmergencyOption(String title, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}