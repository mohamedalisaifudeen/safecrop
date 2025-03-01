import 'package:flutter/material.dart';
//import "OsmFooter.dart";

class MapPage extends StatelessWidget {
  double lat = 6.9271;
  double long = 79.8612;

  MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
        ),
        //body: OsmFooter(lat: lat, long: long),
      ),
    );
  }
}
