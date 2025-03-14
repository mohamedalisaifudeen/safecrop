class AlertStep {
  String title;
  bool status;
  String? timestamp;

  AlertStep({required this.title, this.status = false, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "status": status,
      "timestamp": timestamp,
    };
  }

  factory AlertStep.fromMap(Map<String, dynamic> map) {
    return AlertStep(
      title: map["title"],
      status: map["status"],
      timestamp: map["timestamp"],
    );
  }
}
