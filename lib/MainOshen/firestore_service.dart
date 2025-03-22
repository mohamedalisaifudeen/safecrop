import 'package:cloud_firestore/cloud_firestore.dart';
import 'alert_step.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves a new alert to Firestore.
  /// Each alert has a unique `alertID`, a list of tasks (`alertSteps`), and a timestamp.
  Future<void> saveAlert(String alertID, List<AlertStep> alertSteps) async {
    await _firestore.collection('alerts').doc(alertID).set({
      "alertID": alertID,
      "tasks": alertSteps.map((e) => e.toMap()).toList(),
      "createdAt": DateTime.now(),
    });
  }

  /// Updates an existing alert in Firestore.
  /// Only the list of tasks (`alertSteps`) is updated.
  Future<void> updateAlert(String alertID, List<AlertStep> alertSteps) async {
    await _firestore.collection('alerts').doc(alertID).update({
      "tasks": alertSteps.map((e) => e.toMap()).toList(),
    });
  }
}
