import 'package:cloud_firestore/cloud_firestore.dart';
import 'alert_step.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveAlert(String alertID, List<AlertStep> alertSteps) async {
    await _firestore.collection('alerts').doc(alertID).set({
      "alertID": alertID,
      "tasks": alertSteps.map((e) => e.toMap()).toList(),
      "createdAt": DateTime.now(),
    });
  }

  Future<void> updateAlert(String alertID, List<AlertStep> alertSteps) async {
    await _firestore.collection('alerts').doc(alertID).update({
      "tasks": alertSteps.map((e) => e.toMap()).toList(),
    });
  }
}
