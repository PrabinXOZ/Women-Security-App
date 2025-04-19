import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telephony/telephony.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  _EmergencyContactsScreenState createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();
  final Telephony telephony = Telephony.instance;

  void _addContact() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final phone = _phoneController.text;
    final name = _contactController.text;

    if (phone.isNotEmpty && name.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('emergencyContacts')
          .add({
        'name': name,
        'phoneNumber': phone,
      });
      _contactController.clear();
      _phoneController.clear();
    }
  }

  void _deleteContact(String contactId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('emergencyContacts')
        .doc(contactId)
        .delete();
  }

  void _sendSOS(String phoneNumber) {
    final String message = "This is an emergency. Please help!";

    telephony.sendSms(
      to: phoneNumber,
      message: message,
      statusListener: (SendStatus status) {
        if (status == SendStatus.SENT) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SOS message sent successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send SOS message!')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      body: user == null
          ? const Center(
        child: Text('Please login to manage emergency contacts.'),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _contactController,
              decoration:
              const InputDecoration(labelText: 'Contact Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _phoneController,
              decoration:
              const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ),
          ElevatedButton(
            onPressed: _addContact,
            child: const Text('Add Contact'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('emergencyContacts')
                  .snapshots(),
              builder:
                  (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                var contacts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    var contact = contacts[index];
                    return ListTile(
                      title: Text(contact['name']),
                      subtitle: Text(contact['phoneNumber']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteContact(contact.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () =>
                                _sendSOS(contact['phoneNumber']),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
