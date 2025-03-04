import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String alertId = "000XXXXX"; // Unique alert ID

  @override
  void initState() {
    super.initState();
    _initializeAlertSteps();
  }

  // Initialize alert steps in Firestore if they don't exist
  Future<void> _initializeAlertSteps() async {
    DocumentReference docRef = _firestore.collection('alerts').doc(alertId);

    DocumentSnapshot docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      await docRef.set({
        "steps": [
          {"title": "Alert Received", "status": false},
          {"title": "Assign task to a team", "status": false},
          {"title": "Leave office to relevant field", "status": false},
          {"title": "Arrived to the field", "status": false},
          {"title": "Take necessary action", "status": false},
          {"title": "Finished task", "status": false},
        ]
      });
    }
  }

  // Toggle task status in Firestore
  void toggleTaskStatus(int index) async {
    DocumentReference docRef = _firestore.collection('alerts').doc(alertId);

    DocumentSnapshot docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      List<dynamic> steps = List.from(docSnapshot.get("steps"));
      steps[index]["status"] = !steps[index]["status"]; // Toggle status

      await docRef.update({"steps": steps});
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
                        "Alert ID : $alertId",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(thickness: 1),
                      StreamBuilder<DocumentSnapshot>(
                        stream: _firestore.collection('alerts').doc(alertId).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          List<dynamic> alertSteps = snapshot.data!.get("steps");

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
                                      onPressed: () => toggleTaskStatus(index),
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
