import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: Text(
            'Welcome back, User!',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.black87),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black87),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'FEED'),
                Tab(text: 'COMMUNITY'),
                Tab(text: 'DISCOVER'),
              ],
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black54,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // FEED Tab
                  Center(child: Text('Feed Content')),
                  // COMMUNITY Tab
                  Center(child: Text('Community Content')),
                  // DISCOVER Tab
                  Center(child: Text('Discover Content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
