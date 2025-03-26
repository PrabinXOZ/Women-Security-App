import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrustedContactsScreen extends StatefulWidget {
  @override
  _TrustedContactsScreenState createState() => _TrustedContactsScreenState();
}

class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
  final List<Map<String, String>> _contacts = [
    {'name': 'Mom', 'number': '+919876543210', 'isSharing': 'false'},
    {'name': 'Dad', 'number': '+919876543211', 'isSharing': 'false'},
    {'name': 'Sister', 'number': '+919876543212', 'isSharing': 'false'},
  ];

  bool _isSharingLocation = false;
  String _shareDuration = "15"; // minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
        title: Text('Trusted Contacts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddContactDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSharingLocation)
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.pink.shade200,
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Sharing live location for $_shareDuration minutes',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  TextButton(
                    child: Text('STOP', style: TextStyle(color: Colors.white)),
                    onPressed: _stopSharing,
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)),
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  return _buildContactCard(
                    _contacts[index]['name']!,
                    _contacts[index]['number']!,
                    _contacts[index]['isSharing'] == 'true',
                    index,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink.shade200,
        icon: Icon(Icons.location_on),
        label: Text('Share My Location'),
        onPressed: _toggleLocationSharing,
      ),
    );
  }

  Widget _buildContactCard(String name, String number, bool isSharing, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isSharing 
              ? Colors.pink.shade100.withOpacity(0.5)
              : Colors.pink.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: Colors.pink.shade300),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(number),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.message, color: Colors.pink.shade300),
              onPressed: () => _sendEmergencyMessage(number),
            ),
            IconButton(
              icon: Icon(Icons.call, color: Colors.pink.shade300),
              onPressed: () => _makePhoneCall(number),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Trusted Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Contact Name',
                  prefixIcon: Icon(Icons.person, color: Colors.pink.shade300),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: numberController,
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
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade300),
              onPressed: () {
                if (nameController.text.isNotEmpty && 
                    numberController.text.isNotEmpty) {
                  setState(() {
                    _contacts.add({
                      'name': nameController.text,
                      'number': numberController.text,
                      'isSharing': 'false'
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _toggleLocationSharing() {
    if (!_isSharingLocation) {
      showDialog(
        context: context,
        builder: (context) {
          TextEditingController durationController = 
            TextEditingController(text: _shareDuration);
          
          return AlertDialog(
            title: Text('Share Location'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select contacts to share with:'),
                SizedBox(height: 20),
                ..._contacts.map((contact) => CheckboxListTile(
                  title: Text(contact['name']!),
                  value: contact['isSharing'] == 'true',
                  onChanged: (value) {
                    setState(() {
                      contact['isSharing'] = value.toString();
                    });
                  },
                )).toList(),
                SizedBox(height: 20),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Duration (minutes)',
                    prefixIcon: Icon(Icons.timer, color: Colors.pink.shade300),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade300),
                onPressed: () {
                  setState(() {
                    _isSharingLocation = true;
                    _shareDuration = durationController.text;
                  });
                  Navigator.pop(context);
                  _startSharingTimer();
                },
                child: Text('Start Sharing'),
              ),
            ],
          );
        },
      );
    } else {
      _stopSharing();
    }
  }

  void _stopSharing() {
    setState(() {
      _isSharingLocation = false;
      for (var contact in _contacts) {
        contact['isSharing'] = 'false';
      }
    });
  }

  void _startSharingTimer() {
    // In a real app, this would connect to your backend to share location
    // For demo, we'll just show a countdown
    int duration = int.tryParse(_shareDuration) ?? 15;
    Future.delayed(Duration(minutes: duration), () {
      if (_isSharingLocation) {
        _stopSharing();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location sharing has ended'),
            backgroundColor: Colors.pink.shade300,
          ),
        );
      }
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> _sendEmergencyMessage(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': 'HELP! I need assistance. My current location is: [LIVE_LOCATION_LINK]'},
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }
}