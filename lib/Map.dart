import 'package:flutter/material.dart';
import "OsmFooter.dart";
import 'home_page.dart';
import "UserDataProvider.dart";
import 'package:provider/provider.dart';
import 'OrricerHome.dart';

class MapPage extends StatefulWidget {
  final double lat;
  final double long;

  const MapPage({super.key,this.long=0.0,this.lat=0.0});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isLoading = true;

  // Future<void> fetchDataMap() async {
  //   var data  = await Provider.of<UserDataProvider>(context, listen: false).fetchDataMap();
  //   setState(() {
  //     lat=data["lat"];
  //     long=data["long"];
  //     isLoading=false;
  //
  //   });
  //
  // }

  @override
  void initState() {
    super.initState();
    isLoading=false;

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Locate the Field",
            style: TextStyle(
                fontWeight: FontWeight.w600
            ),
          ),
          toolbarHeight: 80,
          leading: GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OfficerHome()),
              );
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 35,
              weight: 80,

            ),
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12)
              )
          ),
        ),
        body:isLoading ? const Center(child: CircularProgressIndicator()):
        Stack(
          children: [
            Positioned(child: OsmFooter(lat: widget.lat, long: widget.long)),
          ],

        ),


      ),
    );
  }
}



