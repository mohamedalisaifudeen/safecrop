import 'package:flutter/material.dart';

void main() {
  runApp(const UpdateApp());
}

class UpdateApp extends StatelessWidget {
  const UpdateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UpdateScreen(),
    );
  }
}

class UpdateScreen extends StatelessWidget {
  final List<Map<String, String>> steps = [
    {"title": "Alert Received to team", "time": "10:30 AM", "status": "done"},
    {"title": "Assign task to team", "time": "10:32 AM", "status": "done"},
    {"title": "Leave team from team", "time": "10:35 AM", "status": "done"},
    {
      "title": "Arrived to the field",
      "time": "Pending...",
      "status": "pending"
    },
    {"title": "Take action", "time": "Pending...", "status": "pending"},
    {"title": "Finished task", "time": "Pending...", "status": "pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {},
              ),
              const Center(
                child: Text(
                  "Alert Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
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
                            "Alert ID : 000XXXXX",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "In Progress",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Created at 10:30 AM",
                        style: TextStyle(color: Colors.grey),
                      ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepTile extends StatelessWidget {
  final String title, time, status;
  final bool isLast;

  const StepTile({
    super.key,
    required this.title,
    required this.time,
    required this.status,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              status == "done"
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: status == "done" ? Colors.green : Colors.grey,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: status == "done" ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              time,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
