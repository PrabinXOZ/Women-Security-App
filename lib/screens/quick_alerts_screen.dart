import 'package:flutter/material.dart';

class QuickAlertsScreen extends StatefulWidget {
  @override
  _QuickAlertsScreenState createState() => _QuickAlertsScreenState();
}

class _QuickAlertsScreenState extends State<QuickAlertsScreen> {
  final List<Map<String, dynamic>> alertOptions = [
    {
      'title': 'Emergency Alert',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.red,
      'message': 'Send your location to emergency contacts'
    },
    {
      'title': 'Fake Call',
      'icon': Icons.phone,
      'color': Colors.blue,
      'message': 'Trigger a fake incoming call'
    },
    {
      'title': 'Share Location',
      'icon': Icons.location_on,
      'color': Colors.green,
      'message': 'Share live location with trusted contacts'
    },
    {
      'title': 'Sound Alarm',
      'icon': Icons.alarm,
      'color': Colors.orange,
      'message': 'Activate loud alarm sound'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
        title: const Text('Quick Alerts'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.9,
          ),
          itemCount: alertOptions.length,
          itemBuilder: (context, index) {
            return _buildAlertCard(
              alertOptions[index]['title'],
              alertOptions[index]['icon'],
              alertOptions[index]['color'],
              alertOptions[index]['message'],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAlertCard(String title, IconData icon, Color color, String message) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _showAlertConfirmation(title, message);
        },
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                message,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertConfirmation(String title, String message) {
    showDialog(
      context: context, // Now context is accessible
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm $title'),
          content: Text('Are you sure you want to $message?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade300,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title activated!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
