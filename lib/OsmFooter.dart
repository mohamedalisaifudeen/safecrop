import 'package:flutter/material.dart';
import "OsmMap.dart";
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class OsmFooter extends StatelessWidget {
  double lat;
  double long;
  OsmFooter({required this.lat, required this.long});

  Future<void> openGoogleMaps(double latitude, double longitude) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not open Google Maps.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OsmMap(lat: lat, long: long),
        Container(
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Alert ID: 0001XXXXXXXX",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () async {
                openGoogleMaps(lat, long);
              },
              child: Padding(
                padding: EdgeInsets.all(11),
                child: Text(
                  "Navigate",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                  ),
                ),
              ),
              style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(color: Colors.white, width: 3))),
            )
          ]),
        )
      ],
    );
  }
}
