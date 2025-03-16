import 'package:flutter/material.dart';
import "OsmFooter.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  double lat = 6.9271;
  double long = 79.8612;

  void backend() async {
    final response =
        await http.get(Uri.parse('http://your-flask-ip:5000/get-location'));
    if (response.statusCode == 200) {
      setState(() {
        lat = jsonDecode(response.body)["latitude"];
        long = jsonDecode(response.body)["longitude"];
      });
    } else {
      throw Exception('Failed to load location');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backend();
  }

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
        body: OsmFooter(lat: lat, long: long),
      ),
    );
  }
}
