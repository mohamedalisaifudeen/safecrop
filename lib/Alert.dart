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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_rounded,color: Colors.grey.shade700,),
                Text("Map",style: TextStyle(
                  color: Colors.grey.shade700,
                ),),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings,color: Colors.grey.shade700,),
                Text("Settings",style: TextStyle(
                  color: Colors.grey.shade700,
                ),),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow:[
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  spreadRadius: 5,
                  blurRadius: 7,

                )
              ]
            ),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(20),
                  child:Row(
                    children: [
                      Padding(padding:EdgeInsets.only(right: 19) ,
                      child: Icon(Icons.warning,color: Colors.red,size: 50),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("FENCE BREACH ",style: TextStyle(
                              color: Colors.red,
                              fontSize:28,
                              fontWeight: FontWeight.w700
                          ),),
                          Text("DETECTED",style: TextStyle(
                              color: Colors.red,
                              fontSize:28,
                              fontWeight: FontWeight.w700
                          ),)
                        ],
                      )
                    ]
                  )
                )
              ]
            )
          )
        ]
      )
    ))
  }
}                      
             