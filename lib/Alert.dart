import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import "ActionCard.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import 'dart:async';



class Alert extends StatefulWidget {

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  double lat=6.9271;
  double long=79.8612;
  int voltage=0;

  Future<void> getData()async{
    final response =await http.get(Uri.parse("http://10.0.2.2:5001/getVoltage"));
    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      setState(() {
        voltage=data["Voltage"];
      });
      print(voltage);

    }else{
      throw Exception("Failed to load the data");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    Timer.periodic(Duration(seconds: 3),(Timer t){
      getData();
    });
  }

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

                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 20,bottom: 30),
                  child:Row(
                    children: [
                      Icon(Icons.access_time_rounded,color: Colors.grey,),
                      Text("2 minutes ago")
                    ],
                  ) ,
                ),

              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/22),
            child:           Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: OSMViewer(
                    controller: SimpleMapController(
                      initPosition: GeoPoint(
                        latitude:lat ,
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
                  height: 220,
                ),
                Padding(padding: EdgeInsets.only(bottom: 8),
                  child:Row(
                    children: [
                      Icon(Icons.location_on,color: Colors.red,),
                      Text("Sector B7 Colombo"),
                    ],
                  ),),
                Row(
                  children: [
                    Icon(Icons.navigation_rounded,color: Colors.grey,),
                    Text("2.3km from the base station"),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(bottom: 20),
                  child:Text("Alert Details",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                    ),),
                ),
                Row(
                  children: [
                    Icon(Icons.stacked_bar_chart_rounded,color: Colors.amber,),
                    Padding(padding: EdgeInsets.only(left:10,right: MediaQuery.of(context).size.width/4.7),
                      child: Text("Voltage Reading"),),
                    Text(voltage.toString()+"V"+ " (Normal: 5V)"),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 13,bottom: 13),
                  child: Row(
                    children: [
                      Icon(Icons.warning_sharp,color: Colors.red,),
                      Padding(padding: EdgeInsets.only(left:10,right: MediaQuery.of(context).size.width/5.4),
                        child: Text("Wire Break Type"),),
                      Text("Wire break detected"),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Icon(Icons.warning_sharp,color: Colors.red,),
                    Padding(padding: EdgeInsets.only(left:10,right: MediaQuery.of(context).size.width/2.3),
                      child: Text("Security Level"),),
                    Text("High",style: TextStyle(
                        color: Colors.red
                    ),),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(bottom: 10),
                  child:  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(right: 6),
                        child:Icon(Icons.warning_sharp,color: Colors.amber) ,),

                      Text("Immediate Action Required",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20
                      ),)
                    ],
                  ),),

                AlertCard(txt: "Deploy response team to location",icon: Icon(Icons.circle,color: Colors.amber,),),
                AlertCard(txt: "Verify fence integrity",icon: Icon(Icons.circle,color: Colors.amber,),),
                AlertCard(txt: "Contact local authorities if needed",icon: Icon(Icons.circle,color: Colors.amber,),),


                Text("Emergency Contact: +94-742668716",style: TextStyle(
                  color: Colors.amber,
                ),),


              ],
            ),
          ),
          Row(
            children: [
              Container(
                height: 65,
                margin: EdgeInsets.all(MediaQuery.of(context).size.width/22),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child:TextButton(onPressed: (){
                }, child: Text("Deploy Respnse Team",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                  ),)),
              ),

              Container(
                height: 65,
                margin: EdgeInsets.all(MediaQuery.of(context).size.width/20),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child:TextButton(onPressed: (){
                }, child: Text("Mark as False Alarm",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15
                  ),)),
              ),


            ],
          ),
          Container(

            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(bottom: 10),
                  child:  Row(
                    children: [

                      Text("Recent Activity",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20
                      ),)
                    ],
                  ),),

                AlertCard(txt: "Deploy response team to location",icon: Icon(Icons.check_circle,color: Colors.green,size: 15)),
                AlertCard(txt: "Deploy response team to location",icon: Icon(Icons.check_circle,color: Colors.green,size: 15)),
                AlertCard(txt: "Deploy response team to location",icon: Icon(Icons.check_circle,color: Colors.green,size: 15)),





              ],
            ),
          ),
        ],
      ),
    ));
  }
}



