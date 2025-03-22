class AlertStep {
  String title;
  bool isCompleted;

  AlertStep({required this.title, this.isCompleted = false});

  /// Converts the `AlertStep` object into a map for storing in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  /// Creates an `AlertStep` object from a Firestore map.
  factory AlertStep.fromMap(Map<String, dynamic> map) {
    return AlertStep(
      title: map['title'],
      isCompleted: map['isCompleted'],
    );
  }
}
