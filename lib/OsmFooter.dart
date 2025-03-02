import 'package:flutter/material.dart';
import "OsmMap.dart";
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class OsmFooter extends StatelessWidget {
  double lat;
  double long;
  OsmFooter({required this.lat,required this.long});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OsmMap(
            lat: lat,
            long: long
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30)
              )
    ))]      ),
    }}