import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class OsmMap extends StatelessWidget {
  double lat;
  double long;
  OsmMap({required this.lat,required this.long});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:Container(
        child:  OSMViewer(
          controller: SimpleMapController(
            initPosition: GeoPoint(
              latitude: lat,
              longitude: long,
            ),
          )
        )
      )
    )
  }
}            