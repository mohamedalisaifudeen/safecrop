import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'dart:math';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {
  String? name;
  String? number;
  String? type;
  String? img;

  var images=["Img1.jpg","Img2.jpg","Img3.jpg","Img4.jpg","Img5.jpg","Img6.jpg","Img7.jpg"];
  final db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    db.collection("userDetails").where("uid",isEqualTo: FirebaseAuth.instance.currentUser?.uid).get().then(
          (querySnapshot) {
        print("Successfully completed");
        final read_vals=querySnapshot.docs.first;
        int randomIndex = Random().nextInt(images.length);
        setState(() {
          name=read_vals.get("username");
          number=read_vals.get("mobile");
          type=read_vals.get("type");
          img=images[randomIndex];
        });

      },
      onError: (e) => print("Error completing: $e"),
    );


  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(
            bottomNavigationBar:BottomNavBar(),
            body: Column(

              children: [
                SizedBox(
                  height: 320,
                  child: Stack(
                    children: [
                      CustomPaint(
                          size: const Size(double.infinity, 200),
                          painter: WavePainter()
                      ),
                      Positioned(
                        top:120,
                        left: MediaQuery.of(context).size.width/2-95,
                        child:CircleAvatar(
                          radius: 100,
                          backgroundImage:AssetImage("assets/"+img.toString() ,


                        ),
                      ),
                      )

                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 20,top: 20),
                  child:Text(type.toString(),
                    style:TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),)
                  ,),

                Container(
                  padding: EdgeInsets.all(30),
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0XFFD6EFD9),
                  ),

                  height: MediaQuery.of(context).size.height/3,
                  width: MediaQuery.of(context).size.height/2.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child:Padding(padding: EdgeInsets.only(left: 25),
                          child: Text(
                            "Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),),
                      ),
                      Row(
                        children: [

                          Text("Name: ",
                            style:TextStyle(
                                fontSize: 18
                            ) ,),
                          Text(name.toString(),style:TextStyle(
                              fontSize: 18
                          ) ,)
                        ],
                      ),
                      Row(
                        children: [
                          Text("Mobile Number: ",style:TextStyle(
                              fontSize: 18
                          ) ,),
                          Text(number.toString(),style:TextStyle(
                              fontSize: 18
                          ) ,)
                        ],
                      ),
                      Row(
                        children: [
                          Text("Account type: ",style:TextStyle(
                              fontSize: 18
                          ) ,),
                          Text(type.toString(),style:TextStyle(
                              fontSize: 18
                          ) ,)
                        ],
                      ),
                    ],
                  ),
                )

              ],
            )
        )
    );
  }
}






class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0XFF58D076)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from top-left corner
    path.moveTo(0, 0);

    // Left straight line
    path.lineTo(0, size.height * 0.75);

    // Start of the wave (middle dent)
    path.lineTo(size.width * 0.25, size.height * 0.75);

    path.quadraticBezierTo(
      size.width * 0.5, size.height*.2, // Control point for dent
      size.width * 0.75, size.height * 0.73, // End of dent
    );

    // Right straight line
    path.lineTo(size.width, size.height * 0.73);
    path.lineTo(size.width, 0);

    // Close the path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint for static content
  }
}
