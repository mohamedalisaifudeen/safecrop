import 'package:flutter/material.dart';
import 'alert_step.dart';
import 'firestore_service.dart';
import 'alert_utils.dart';

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final ValueNotifier<List<AlertStep>> alertStepsNotifier = ValueNotifier([
    AlertStep(title: "Alert Received to team"),
    AlertStep(title: "Assign task to team"),
    AlertStep(title: "Leave office to field"),
    AlertStep(title: "Arrived to the field"),
    AlertStep(title: "Take action"),
    AlertStep(title: "Finished task"),
  ]);

  late String alertID;

  @override
  void initState() {
    super.initState();
    alertID = AlertUtils.generateRandomID();
    _firestoreService.saveAlert(alertID, alertStepsNotifier.value);
  }

  void toggleTaskStatus(int index) async {
    List<AlertStep> steps = List.from(alertStepsNotifier.value);
    steps[index].status = !steps[index].status;
    steps[index].timestamp = steps[index].status ? AlertUtils.getCurrentTime() : null;
    alertStepsNotifier.value = steps;

    await _firestoreService.updateAlert(alertID, steps);
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
                      ValueListenableBuilder<List<AlertStep>>(
                        valueListenable: alertStepsNotifier,
                        builder: (context, alertSteps, child) {
                          return Column(
                            children: List.generate(alertSteps.length, (index) {
                              return ListTile(
                                title: Text(
                                  alertSteps[index].title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: alertSteps[index].timestamp != null
                                    ? Text("Completed at: ${alertSteps[index].timestamp}",
                                    style: TextStyle(color: Colors.blueAccent))
                                    : null,
                                trailing: GestureDetector(
                                  onTap: () => toggleTaskStatus(index),
                                  child: Icon(
                                    alertSteps[index].status
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: alertSteps[index].status
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
