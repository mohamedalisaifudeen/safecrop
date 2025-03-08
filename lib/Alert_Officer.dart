import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void toggleTaskStatus(String docId, bool currentStatus) {
    _firestore.collection('alerts').doc(docId).update({
      "status": !currentStatus, // Toggle status (true/false)
    });
  }

  void markNextTaskDone() async {
    var tasks = await _firestore.collection('alerts').get();
    for (var doc in tasks.docs) {
      if (!(doc.data()["status"] ?? false)) {
        _firestore.collection('alerts').doc(doc.id).update({"status": true});
        break; // Mark only one task at a time
      }
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
                        "Alert ID : 000XXXXX",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(thickness: 1),
                      StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('alerts').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          var alertSteps = snapshot.data!.docs;

                          return Column(
                            children: alertSteps.map((doc) {
                              var data = doc.data() as Map<String, dynamic>;
                              return ListTile(
                                title: Text(
                                  data["title"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: GestureDetector(
                                  onTap: () => toggleTaskStatus(doc.id, data["status"]),
                                  child: Icon(
                                    data["status"]
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: data["status"] ? Colors.green : Colors.grey,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: markNextTaskDone,
                        child: Text("Mark Next Task Done"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        ),
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
