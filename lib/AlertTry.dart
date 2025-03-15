import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlertScreen(),
    );
  }
}

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ValueNotifier<List<Map<String, dynamic>>> alertStepsNotifier =
  ValueNotifier([]);

  String? alertID;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLatestAlert();
  }

  /// Fetches the most recent alert from Firestore
  void fetchLatestAlert() async {
    try {
      var alertDoc = await _firestore
          .collection('alerts')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (alertDoc.docs.isNotEmpty) {
        var data = alertDoc.docs.first;
        alertID = data.id;
        alertStepsNotifier.value = List<Map<String, dynamic>>.from(data['tasks']);
      } else {
        createNewAlert();
      }
    } catch (e) {
      print("Error fetching alert: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  /// Creates a new alert with an initial set of tasks
  void createNewAlert() async {
    alertID = generateRandomID();
    List<Map<String, dynamic>> initialTasks = [
      {"title": "Alert Received to team", "status": false, "timestamp": null},
      {"title": "Assign task to team", "status": false, "timestamp": null},
      {"title": "Leave office to field", "status": false, "timestamp": null},
      {"title": "Arrived to the field", "status": false, "timestamp": null},
      {"title": "Take action", "status": false, "timestamp": null},
      {"title": "Finished task", "status": false, "timestamp": null},
    ];

    alertStepsNotifier.value = initialTasks;

    await _firestore.collection('alerts').doc(alertID).set({
      "alertID": alertID,
      "tasks": initialTasks,
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  /// Generates a random 6-digit alert ID
  String generateRandomID() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  /// Toggles the status of a task and updates Firestore
  void toggleTaskStatus(int index) async {
    List<Map<String, dynamic>> steps = List.from(alertStepsNotifier.value);
    steps[index]["status"] = !steps[index]["status"];

    if (steps[index]["status"]) {
      steps[index]["timestamp"] = DateTime.now().toIso8601String();
    } else {
      steps[index]["timestamp"] = null;
    }

    alertStepsNotifier.value = steps;

    if (alertID != null) {
      await _firestore.collection('alerts').doc(alertID).update({
        "tasks": steps,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Alert ID: ${alertID ?? 'Loading...'}",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(thickness: 1),
                      ValueListenableBuilder<List<Map<String, dynamic>>>(
                        valueListenable: alertStepsNotifier,
                        builder: (context, alertSteps, child) {
                          return Column(
                            children: List.generate(alertSteps.length, (index) {
                              return ListTile(
                                title: Text(
                                  alertSteps[index]["title"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: alertSteps[index]["timestamp"] != null
                                    ? Text(
                                    "Completed at: ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(alertSteps[index]["timestamp"]))}",
                                    style: TextStyle(color: Colors.blueAccent))
                                    : null,
                                trailing: GestureDetector(
                                  onTap: () => toggleTaskStatus(index),
                                  child: Icon(
                                    alertSteps[index]["status"]
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: alertSteps[index]["status"]
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
