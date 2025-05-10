import 'package:flutter/material.dart';

class ProtocolScreen extends StatelessWidget {
  const ProtocolScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> protocols = [
      "Stay calm and aware of your surroundings.",
      "Use the SOS button if you feel threatened.",
      "Call emergency contacts or police immediately.",
      "Avoid dark or isolated areas if possible.",
      "Share your live location with someone you trust.",
      "Never confront the suspect alone.",
      "Use public spaces for safety if pursued.",
      "Keep your mobile phone fully charged when traveling.",
      "Inform family or friends before leaving late at night.",
      "Trust your instincts — if something feels off, act cautiously.",
      "Avoid wearing headphones or being distracted while walking alone.",
      "Carry a whistle or personal safety alarm.",
      "Use trusted transportation and share ride details with someone.",
      "Have emergency helpline numbers saved and accessible.",
      "If approached by a stranger, maintain distance and stay alert.",
      "Take self-defense training if possible.",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Protocols'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "In case of emergency, follow these steps to stay safe:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: protocols.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ),
                      title: Text(
                        protocols[index],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
