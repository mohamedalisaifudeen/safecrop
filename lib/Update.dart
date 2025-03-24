import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  late Stream<DocumentSnapshot> alertStream;

  @override
  void initState() {
    super.initState();
    alertStream = FirebaseFirestore.instance
        .collection('alerts')
        .doc('mwTh34nAyp3P33gHxd51') // need to chnage with real parameter
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            print('hello world');
          },
        ),
        backgroundColor: Colors.green,
        title: const Text("Alert Details"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: alertStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
// fetch alert data from Firestore document
          var alertData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          String status = alertData['status'] ?? 'Pending';
          List<dynamic> steps = (alertData['steps'] as List<dynamic>?) ?? [];

          int completedSteps =
              steps.where((s) => s['completed'] == true).length;

          // Ensure no division by zero
          double progress =
              steps.isNotEmpty ? (completedSteps / steps.length) * 100 : 0;

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
                      "Alert ID: ${widget.alertId}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == 'In Progress'
                            ? Colors.green.shade200
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(status),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Created at ${alertData['createdAt'] ?? 'N/A'}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      var step = steps[index];
                      return ListTile(
                        leading: Icon(
                          step['completed'] ? Icons.check_circle : Icons.circle,
                          color: step['completed'] ? Colors.green : Colors.grey,
                        ),
                        title: Text(step['title']),
                        subtitle: Text(
                          step['completed']
                              ? step['time'] ?? 'Completed'
                              : 'Pending...',
                          style: TextStyle(
                              color: step['completed']
                                  ? Colors.green
                                  : Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                LinearProgressIndicator(
                  value:
                      steps.isNotEmpty ? (completedSteps / steps.length) : 0.0,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.green,
                ),
                const SizedBox(height: 5),
                Center(
                    child: Text("${progress.toStringAsFixed(0)}% Completed")),
              ],
            ),
          );
        },
      ),
    );
  }
}
