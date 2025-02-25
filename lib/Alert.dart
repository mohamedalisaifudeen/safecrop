import 'dart:js_interop';

import 'package:flutter/material.dart';

void main() {
  runApp(Alert());
}

class Alert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlertScreen(),
    );
  }
}

class AlertScreen extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>> alertStepsNotifier =
  ValueNotifier([
    {"title": "Alert Received ", "status": false},
    {"title": "Assign task to a team", "status": false},
    {"title": "Leave office to relevant field", "status": false},
    {"title": "Arrived to the field", "status": false},
    {"title": "Take necessary action", "status": false},
    {"title": "Finished task", "status": false},
  ]);

  void toggleTaskStatus(int index) {
    List<Map<String, dynamic>> steps = List.from(alertStepsNotifier.value);
    steps[index]["status"] = !steps[index]["status"]; // Toggle status
    alertStepsNotifier.value = steps;
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
                        "Alert ID : 000XXXXX",
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        alertSteps[index]["status"]
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: alertSteps[index]["status"]
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      onPressed: () => toggleTaskStatus(index), // Toggle task status
                                    ),
                                    ElevatedButton(
                                      onPressed: () => toggleTaskStatus(index),
                                      child: Text(alertSteps[index]["status"]
                                          ? "Undo"
                                          : "Mark Done"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: alertSteps[index]["status"]
                                            ? Colors.red
                                            : Colors.orange,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                      ),
                                    ),
                                  ],
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
