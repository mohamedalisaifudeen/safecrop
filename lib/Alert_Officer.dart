import 'package:flutter/material.dart';

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

class AlertScreen extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>> alertStepsNotifier =
  ValueNotifier([
    {"title": "Alert Received to team", "status": false},
    {"title": "Assign task to team", "status": false},
    {"title": "Leave office to field", "status": false},
    {"title": "Arrived to the field", "status": false},
    {"title": "Take action", "status": false},
    {"title": "Finished task", "status": false},
  ]);

  void markNextAsDone() {
    List<Map<String, dynamic>> steps = List.from(alertStepsNotifier.value);
    for (int i = 0; i < steps.length; i++) {
      if (!steps[i]["status"]) {
        steps[i]["status"] = true;
        break; // Mark only the first "pending" step and stop
      }
    }
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
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: alertSteps.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      alertSteps[index]["title"],
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    trailing: alertSteps[index]["status"]
                                        ? Icon(Icons.check_circle, color: Colors.green)
                                        : Text(
                                      "Pending.....",
                                      style: TextStyle(
                                          color: Colors.grey, fontStyle: FontStyle.italic),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: markNextAsDone,
                                child: Text("Mark Next Task Done"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                ),
                              ),
                            ],
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
