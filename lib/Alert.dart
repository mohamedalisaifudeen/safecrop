import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
//import "ActionCard.dart";
class Alert extends StatelessWidget {
  double lat=6.9271;
  double long=79.8612;

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      bottomNavigationBar: Container(
       height: MediaQuery.sizeOf(context).height/16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_filled,color: Colors.grey.shade700,),
                Text("Home",style: TextStyle(
                  color: Colors.grey.shade700,
                ),),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_alert,color: Colors.grey.shade700,),
                Text("Alert",style: TextStyle(
                  color: Colors.grey.shade700,
                ),),
              ],
            ),
          ]
        )
      )
    ))
  }
}              