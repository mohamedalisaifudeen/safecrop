import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'bottom_nav_bar.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


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
              Row(
                children: [
                  Text(
                    'Safe',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Crop',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 80,
                child: Card(

                  surfaceTintColor: Colors.grey.shade100,
                  color: Colors.grey.shade100,
                  child: Row(
                    children: [
                      Padding(padding:EdgeInsets.only(right: 20,left: 20) ,
                        child:Icon(Icons.check_circle,
                          size: 30,
                          color: Colors.green,) ,),
                      Text(
                        "System Active ",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Recent Activities",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where("UUID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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
                          shadowColor: Colors.blueGrey.shade700,
                          color: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.symmetric(vertical: 13),
                          child: ListTile(
                            minVerticalPadding: 17,

                            leading:Icon(
                              Icons.warning_sharp,
                              size: 30,
                              color: Colors.red,
                            ),
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



