import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization for web and mobile
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyD62EWymo2h2E2460X6TG96_ffChJW5gWQ",
        authDomain: "safecrop-c426d.firebaseapp.com",
        projectId: "safecrop-c426d",
        storageBucket: "safecrop-c426d.firebasestorage.app",
        messagingSenderId: "481531315929",
        appId: "1:481531315929:web:34b4f5a8e0f08f256be0c8",
        measurementId: "G-H4Z3ZF4L25"
    ),
  );

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
  final ValueNotifier<List<Map<String, dynamic>>> alertStepsNotifier = ValueNotifier([
    {"title": "Alert Received to team", "status": false, "timestamp": null},
    {"title": "Assign task to team", "status": false, "timestamp": null},
    {"title": "Leave office to field", "status": false, "timestamp": null},
    {"title": "Arrived to the field", "status": false, "timestamp": null},
    {"title": "Take action", "status": false, "timestamp": null},
    {"title": "Finished task", "status": false, "timestamp": null},
  ]);

  late String alertID;

  @override
  void initState() {
    super.initState();
    alertID = generateRandomID();
    saveAlertToFirestore();
  }

  String generateRandomID() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  String getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  void saveAlertToFirestore() async {
    try {
      await _firestore.collection('alerts').doc(alertID).set({
        "alertID": alertID,
        "tasks": alertStepsNotifier.value,
        "createdAt": DateTime.now(),
      });
    } catch (e) {
      print("Error saving alert: $e");
    }
  }

  void toggleTaskStatus(int index) async {
    try {
      List<Map<String, dynamic>> steps = List.from(alertStepsNotifier.value);
      steps[index]["status"] = !steps[index]["status"];

      if (steps[index]["status"]) {
        steps[index]["timestamp"] = getCurrentTime();
      } else {
        steps[index]["timestamp"] = null;
      }

      alertStepsNotifier.value = steps;

      await _firestore.collection('alerts').doc(alertID).update({
        "tasks": steps,
      });
    } catch (e) {
      print("Error updating task status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
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
                        "Alert ID : $alertID",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: alertSteps[index]["timestamp"] != null
                                    ? Text("Completed at: ${alertSteps[index]["timestamp"]}",
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
