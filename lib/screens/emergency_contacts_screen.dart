import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatefulWidget {
  @override
  _EmergencyContactsScreenState createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final List<Map<String, String>> _contacts = [
    {'name': 'Police', 'number': '100'},
    {'name': 'Women Helpline', 'number': '1091'},
    {'name': 'Ambulance', 'number': '102'},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
        title: const Text('Emergency Contacts'),
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
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  return _buildContactCard(
                    _contacts[index]['name']!,
                    _contacts[index]['number']!,
                    index,
                  );
                },
              ),
            ),
          ),
          _buildAddContactButton(),
        ],
      ),
    );
  }

  Widget _buildContactCard(String name, String number, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.pink.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: Colors.pink.shade300),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(number),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.call, color: Colors.pink.shade300),
              onPressed: () => _makePhoneCall(number),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteContact(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddContactButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink.shade200,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => _showAddContactDialog(),
        child: const Text(
          'Add Emergency Contact',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Contact Name',
                  prefixIcon: Icon(Icons.person, color: Colors.pink.shade300),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: Colors.pink.shade300),
                ),
              ),
            ],
          ),
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
                if (_nameController.text.isNotEmpty && _numberController.text.isNotEmpty) {
                  setState(() {
                    _contacts.add({
                      'name': _nameController.text,
                      'number': _numberController.text,
                    });
                  });
                  _nameController.clear();
                  _numberController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch phone call'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
