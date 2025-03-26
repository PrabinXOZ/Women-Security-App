import 'package:flutter/material.dart';

class EmergencyProtocolsScreen extends StatelessWidget {
  final List<Map<String, String>> protocols = [
    {
      'title': 'If You Feel Followed',
      'steps': '1. Head to a crowded area\n'
               '2. Call a trusted contact\n'
               '3. Use the Fake Call feature\n'
               '4. Activate emergency alert'
    },
    {
      'title': 'If Harassed in Public',
      'steps': '1. Make noise to attract attention\n'
               '2. Use the loud alarm feature\n'
               '3. Take photo/video if safe\n'
               '4. Report to authorities immediately'
    },
    {
      'title': 'If In Vehicle Danger',
      'steps': '1. Share live location with contacts\n'
               '2. Note vehicle details\n'
               '3. Ask to be let out in crowded area\n'
               '4. Use emergency call button'
    },
    {
      'title': 'Home Invasion',
      'steps': '1. Lock yourself in a safe room\n'
               '2. Silently call emergency number\n'
               '3. Use panic alert in app\n'
               '4. Don\'t confront the intruder'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
        title: Text('Emergency Protocols'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: protocols.length,
          itemBuilder: (context, index) {
            return _buildProtocolCard(
              protocols[index]['title']!,
              protocols[index]['steps']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildProtocolCard(String title, String steps) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade300,
              ),
            ),
            SizedBox(height: 15),
            Text(
              steps,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade100,
                foregroundColor: Colors.pink.shade800,
              ),
              onPressed: () {
                // Could link to relevant features
              },
              child: Text('Show Related Safety Features'),
            ),
          ],
        ),
      ),
    );
  }
}