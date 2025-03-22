import 'package:flutter/material.dart';
import 'home_page.dart';
import 'Alert.dart';
import "Map.dart";
import "Profile.dart";
import 'OfficerAlert.dart';
import 'OrricerHome.dart';
import "AlertNew.dart";

class Officernav extends StatefulWidget {
  const Officernav({super.key});

  @override
  _Officernav createState() => _Officernav();
}

class _Officernav extends State<Officernav> {
  int _selectedIndex = 0;

  final List<Widget> _pages=[
    OfficerHome(),
    AlertsApp(),
    MyApp(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[_selectedIndex]),
    );

    // Handle navigation here if necessary
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped, // Add this
      items: const [

        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: 'Alerts'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
