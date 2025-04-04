import 'package:flutter/material.dart';
import 'home_page.dart';
import 'Alert.dart';
import "Map.dart";
import "Profile.dart";
import "OfficerAlert.dart";
import 'OrricerHome.dart';
import "AlertNew.dart";
import "alert_details_container.dart";
import "Update.dart";

class BottomNavBar extends StatefulWidget {
  final String data;
  const BottomNavBar({super.key,this.data=""});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  late List<Widget>     _pages = [
    HomePage(),
    Alert(),
    MyApp_new(),
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
  void initState() {
    super.initState();
    print(widget.data);
    print("Contains 'Farmer'? ${widget.data.contains("Farmer")}");

    // Initialize _pages inside initState() where `widget` is accessible

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
