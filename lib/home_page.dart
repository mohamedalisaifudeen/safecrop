import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SafeCrop',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Recent Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong.'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No recent alerts.'));
                    }

                    var alerts = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        var alert =
                            alerts[index].data() as Map<String, dynamic>;
                        String title = alert['title'] ?? 'No Title';
                        String body = alert['body'] ?? 'No Body';
                        Timestamp? timestamp = alert['timestamp'];
                        String formattedTime = timestamp != null
                            ? formatTimestamp(timestamp)
                            : 'Unknown Time';

                        return Card(
                          color: Colors.yellow.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(title,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(body),
                            trailing: Text(formattedTime,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
