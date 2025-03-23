import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'OrricerHome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp_new());
}

class MyApp_new extends StatelessWidget {
  const MyApp_new({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alert Details',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AlertDetailsScreen(alertId: '000XXXXX'), // Sample Alert ID
    );
  }
}

class AlertDetailsScreen extends StatefulWidget {
  final String alertId;

  const AlertDetailsScreen({Key? key, required this.alertId}) : super(key: key);

  @override
  _AlertDetailsScreenState createState() => _AlertDetailsScreenState();
}

class _AlertDetailsScreenState extends State<AlertDetailsScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> alertStream;

  @override
  void initState() {
    super.initState();
    setState(() {
      alertStream = getAlertStream();
    });

  }

  // Stream to fetch alert data
  Stream<QuerySnapshot<Map<String, dynamic>>> getAlertStream() {
    return FirebaseFirestore.instance
        .collection('userDetails')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .asyncExpand((userSnapshot) {
      if (userSnapshot.docs.isEmpty) {
        debugPrint("No user found with the given UID");
        return Stream.error("No user found");
      }
      var officerId = userSnapshot.docs.first["OfficerId"];
      debugPrint("Officer ID: $officerId");

      // Fetching alerts based on OfficerId
      return FirebaseFirestore.instance
          .collection('alerts')
          .where('alertID', isEqualTo: officerId)
          .snapshots();  // This returns a Stream<QuerySnapshot<Map<String, dynamic>>>
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OfficerHome()),
            );
          },
        ),
        backgroundColor: Colors.green,
        title: const Text("Alert Details"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: alertStream, // Use the stream here
        builder: (context, snapshot) {
          debugPrint("StreamBuilder State: ${snapshot.connectionState}");

          if (snapshot.hasError) {
            debugPrint("Error: ${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            debugPrint("No data available");
            return const Center(child: Text("No alert data found"));
          }

          // Get the first document from the query snapshot
          var alertData = snapshot.data!.docs.first.data() as Map<String, dynamic>? ?? {};
          debugPrint("UI Received Alert Data: $alertData");

          String status = alertData['status'] ?? 'Pending';
          List<dynamic> tasks = alertData['tasks'] ?? [];

          int completedTasks = tasks.where((t) => t['status'] == true).length;
          double progress = tasks.isNotEmpty ? (completedTasks / tasks.length) * 100 : 0;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Alert ID: ${alertData['alertID'].toString().substring(0,10) ?? 'Unknown'}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == 'In Progress' ? Colors.green.shade200 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(status),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Created at ${alertData['createdAt'].toDate()}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      return ListTile(
                        leading: Icon(
                          task['status'] == true ? Icons.check_circle : Icons.circle,
                          color: task['status'] == true ? Colors.green : Colors.grey,
                        ),
                        title: Text(task['title']),
                        subtitle: Text(
                          task['timestamp'] ?? 'Pending...',
                          style: TextStyle(color: task['status'] == true ? Colors.green : Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                LinearProgressIndicator(
                  value: tasks.isNotEmpty ? (completedTasks / tasks.length) : 0.0,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.green,
                ),
                const SizedBox(height: 5),
                Center(child: Text("${progress.toStringAsFixed(0)}% Completed")),
              ],
            ),
          );
        },
      ),
    );
  }
}
