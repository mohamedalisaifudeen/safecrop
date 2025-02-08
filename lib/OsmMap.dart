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
            markerHome: const MarkerIcon(
              icon: Icon(Icons.location_on,color: Colors.red,size: 50,),
            ),

          ),
          zoomOption: const ZoomOption(
            initZoom: 16,
            minZoomLevel: 2,
          ),
        ),
        height: 200,
      ),
    );
  }
}
