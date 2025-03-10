import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting time

void main() {
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
  final ValueNotifier<List<Map<String, dynamic>>> alertStepsNotifier =
  ValueNotifier([
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
    alertID = generateRandomID(); // Generate random Alert ID
  }

  String generateRandomID() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString(); // Generates a 6-digit ID
  }

  String getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now()); // Example: 03:45 PM
  }

  void toggleTaskStatus(int index) {
    List<Map<String, dynamic>> steps = List.from(alertStepsNotifier.value);
    steps[index]["status"] = !steps[index]["status"];

    if (steps[index]["status"]) {
      steps[index]["timestamp"] = getCurrentTime(); // Save timestamp when checked
    } else {
      steps[index]["timestamp"] = null; // Remove timestamp when unchecked
    }

    alertStepsNotifier.value = steps; // Update UI
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
                        "Alert ID : $alertID", // Display generated Alert ID
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: alertSteps[index]["timestamp"] != null
                                    ? Text(
                                  "Completed at: ${alertSteps[index]["timestamp"]}",
                                  style: TextStyle(
                                      color: Colors.green.shade700, // Updated color
                                      fontWeight: FontWeight.w500),
                                )
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
