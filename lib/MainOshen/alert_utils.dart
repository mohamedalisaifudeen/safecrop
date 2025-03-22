import 'alert_step.dart';

/// Converts a list of `AlertStep` objects into a Firestore-compatible list.
List<Map<String, dynamic>> convertStepsToMap(List<AlertStep> steps) {
  return steps.map((step) => step.toMap()).toList();
}

/// Converts a Firestore list into a list of `AlertStep` objects.
List<AlertStep> convertMapToSteps(List<dynamic> data) {
  return data.map((step) => AlertStep.fromMap(step)).toList();
}
