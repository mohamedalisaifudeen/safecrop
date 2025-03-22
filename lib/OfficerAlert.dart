import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "UserDataProvider.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:intl/intl.dart";
import "OfficerNav.dart";
class AlertsApp extends StatefulWidget {
  const AlertsApp({super.key});

  @override
  State<AlertsApp> createState() => _AlertsAppState();
}

class _AlertsAppState extends State<AlertsApp> {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Alerts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AlertsScreen(),
    );
  }
}




class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedTab = 'All';

  List<Object?> data=[];


  Future<void> fetchOfficerAlert() async {
    var dataNew  = await Provider.of<UserDataProvider>(context, listen: false).OfficerAlert();
    setState(() {
      data=dataNew;
    });
    print(data);

  }

  @override
  void initState() {
    super.initState();
    fetchOfficerAlert();


  }

  String _getTimeAgo(DateTime timestamp) {
    Duration difference = DateTime.now().difference(timestamp);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes} minutes ago";
    if (difference.inHours < 24) return "${difference.inHours} hours ago";
    return DateFormat("dd MMM yyyy, hh:mm a").format(timestamp); // e.g., "12 Mar 2025, 3:45 PM"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:const Officernav(),
      appBar: AppBar(
        title: const Text(
          'Alerts',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFEEEEEE),
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildFilterTab('All', Colors.blue),
                  const SizedBox(width: 16),
                  //_buildFilterTab('High Priority', Colors.red),
                  //const SizedBox(width: 16),
                  //_buildFilterTab('Medium', Colors.orange),
                  //const SizedBox(width: 16),
                  //_buildFilterTab('Low', Colors.yellow),
                ],
              ),
            ),
          ),

          // Alerts List
          Expanded(
child:data.isEmpty?Center(child:Text("No data")):
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:data.length ,
              itemBuilder: (context,index){
                var data_new=data[index] as Map<String,dynamic>;
                var title=data_new["title"];
                var description=data_new["body"];
                var timeAgo=data_new["timestamp"];

                return _buildAlertItem(
                  title: title,
                  timeAgo: timeAgo,
                  description:description,
                  status: null,
                  location: "",
                  priorityColor: Colors.red,
                );
              }

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, Color dotColor) {
    bool isSelected = _selectedTab == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = text;
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                if (text != 'All')
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.blue : Colors.grey[600],
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              height: 3,
              color: Colors.blue,
              width: text == 'All'
                  ? 30
                  : text == 'High Priority'
                  ? 100
                  : text == 'Medium'
                  ? 70
                  : 40,
            ),
        ],
      ),
    );
  }

  Widget _buildAlertItem({
    required String title,
    required Timestamp timeAgo,
    required String location,
    required String description,
    required Color priorityColor,
    String? status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (status != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              // decoration: BoxDecoration(
                              //   color: status == 'Active'
                              //       ? Colors.grey[200]
                              //       : Colors.grey[100],
                              //   borderRadius: BorderRadius.circular(16),
                              // ),
                              // child: Text(
                              //   status,
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     color: status == 'Active'
                              //         ? Colors.black
                              //         : Colors.grey[600],
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            _getTimeAgo(timeAgo.toDate()),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '•',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}