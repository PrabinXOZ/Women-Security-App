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
               '2. Stay quiet and call police\n'
               '3. Do not confront the intruder\n'
               '4. Keep phone on silent with alerts off'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Emergency Protocols',
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
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: protocols.length,
          itemBuilder: (context, index) {
            final item = protocols[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield, color: Colors.pink, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['steps']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
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
