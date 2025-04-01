import 'package:flutter/material.dart';

class HistoryLogScreen extends StatelessWidget {
  final List<Map<String, String>> historyLogs = [
    {
      'title': 'SOS Triggered',
      'time': '2025-03-30 14:42',
      'details': 'Location shared with 2 contacts.'
    },
    {
      'title': 'Safe Walk Started',
      'time': '2025-03-30 13:20',
      'details': 'Live tracking for 15 minutes.'
    },
    {
      'title': 'Alarm Activated',
      'time': '2025-03-29 20:14',
      'details': 'Loud alarm played for 5 seconds.'
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
          'History Log',
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
          itemCount: historyLogs.length,
          itemBuilder: (context, index) {
            final log = historyLogs[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: ListTile(
                title: Text(
                  log['title']!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${log['time']}\n${log['details']}',
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                isThreeLine: true,
                leading: const Icon(Icons.history, color: Colors.pink),
              ),
            );
          },
        ),
      ),
    );
  }
}
