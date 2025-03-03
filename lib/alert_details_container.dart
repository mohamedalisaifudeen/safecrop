import 'package:flutter/material.dart';
import 'step_tile.dart';

class AlertDetailsContainer extends StatelessWidget {
  const AlertDetailsContainer({super.key});

  final List<Map<String, String>> steps = const [
    {"title": "Alert Received to team", "time": "10:30 AM", "status": "done"},
    {"title": "Assign task to team", "time": "10:32 AM", "status": "done"},
    {"title": "Leave team from team", "time": "10:35 AM", "status": "done"},
    {"title": "Arrived to the field", "time": "Pending...", "status": "pending"},
    {"title": "Take action", "time": "Pending...", "status": "pending"},
    {"title": "Finished task", "time": "Pending...", "status": "pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Alert ID : 0000XXXXX",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "In Progress",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Text("Created at 10:30 AM", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: steps.length,
              itemBuilder: (context, index) {
                return StepTile(
                  title: steps[index]['title']!,
                  time: steps[index]['time']!,
                  status: steps[index]['status']!,
                  isLast: index == steps.length - 1,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text("50% Completed", textAlign: TextAlign.center),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.grey.shade300,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
