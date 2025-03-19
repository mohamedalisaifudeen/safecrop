import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'alert_step.dart';

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches alerts from Firestore.
  Stream<QuerySnapshot> getAlertsStream() {
    return _firestore.collection('alerts').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alert Screen'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAlertsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Shows a loading indicator.
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No alerts available')); // Shows a message if no alerts exist.
          }

          // Builds a list of alerts.
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text('Alert ID: ${doc['alertID']}'),
                subtitle: Text('Tasks: ${doc['tasks'].length}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
