import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import "ActionCard.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import 'dart:async';
import 'bottom_nav_bar.dart';
import "UserDataProvider.dart";
import 'package:provider/provider.dart';
import 'alert_item.dart';
import 'package:geocoding/geocoding.dart';
import 'OfficerNav.dart';
import "Map.dart";

class OfficerHome extends StatefulWidget {



  @override
  State<OfficerHome> createState() => _OfficerHome();
}

class _OfficerHome extends State<OfficerHome> {
  var voltage="";
  bool isLoading = true;
  List<Object?> data=[];
  String address='';
  late MapController mapcontroller;
  bool isMapInitialized = false;
  Future<void> fetchData() async {
    var data_new  = await Provider.of<UserDataProvider>(context, listen: false).OfficerAlert();
    setState(() {
      data=data_new;
      print(data);
      isLoading=false;
    });
    addData();




  }

  Future<void> addData() async{
    if (!isMapInitialized) return;
    for(var item in data){
      var mapItem = item as Map<String, dynamic>;
      print("Map Item: $mapItem");
      double lat=mapItem["lat"].toDouble();
      double long=mapItem["long"].toDouble();

      await mapcontroller.addMarker(
        GeoPoint(latitude: lat, longitude: long),
        markerIcon:MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.red, size: 50),
      ),
      );
    };


  }



  @override
  void initState() {
    super.initState();
    mapcontroller = MapController(
// Correct the parameter type
      initPosition: GeoPoint(latitude: 6, longitude: 7),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });

  }




  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      bottomNavigationBar:const Officernav(),
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
                  Text("Safe ",style: TextStyle(
                              color: Colors.black,
                              fontSize:28,
                              fontWeight: FontWeight.w700
                          ),),


      Text("Crop ",style: TextStyle(
          color: Colors.green,
          fontSize:28,
          fontWeight: FontWeight.w700
      ))

                    ],
                  ),
                ),

              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/22),
            child:           Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child:isLoading?Center(child: CircularProgressIndicator(),):
                  OSMFlutter(
                    controller: mapcontroller, // ✅ Use the same mapcontroller
                    osmOption: OSMOption( // ✅ Required parameter
                      zoomOption: const ZoomOption(
                        initZoom: 16,
                        minZoomLevel: 5,
                      ),
                      userLocationMarker: UserLocationMaker(
                        personMarker: MarkerIcon(
                          icon: Icon(Icons.person, color: Colors.blue, size: 50),
                        ),
                        directionArrowMarker: MarkerIcon(
                          icon: Icon(Icons.navigation, color: Colors.blue, size: 50),
                        ),
                      ),


                    ),
                  ),
                  height: 220,
                ),

                Padding(padding: EdgeInsets.only(top: 20,bottom: 20),
                  child:                Text(
                    "Recent Incidents",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ) ,),



              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height:MediaQuery.of(context).size.height * 0.4,
                child:data.isEmpty?Center(child:Text("No data")):

                ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount:data.length ,
                    itemBuilder: (context,index){
                      var data_new=data[index] as Map<String,dynamic>;
                      var title=data_new["title"];
                      var description=data_new["body"];
                      var timeAgo=data_new["timestamp"];
                      var lat=data_new["lat"];
                      var long=data_new["long"];


                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapPage(lat: lat, long: long),
                            ),
                          );
                        },
                        child:Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(10),
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                            ),
                            child:
                            Row(

                              children: [
                                Padding(padding: EdgeInsets.only(right:20,left: 2),
                                  child:Icon(Icons.warning_sharp,color: Colors.red,size: 30,)
                                  ,),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Padding(padding: EdgeInsets.only(bottom: 2)
                                      ,child:Text("Alert",style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,

                                      ),) ,),

                                    Text("Elephant entered the paddy field"),
                                    Text("2hours ago")

                                  ],
                                )
                              ],
                            )
                        ) ,
                      );
                    }

                ),
              ),
            ],
          )

        ],

      ),

    ));
  }
}

