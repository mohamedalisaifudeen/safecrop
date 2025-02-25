import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                      ),
                    ),


                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 20,top: 20),
                child:Text("Farmer",
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

                        Text("Farm Location:-",
                          style:TextStyle(
                            fontSize: 18
                          ) ,),
                        Text("Spencer building iit ",style:TextStyle(
                            fontSize: 18
                        ) ,)
                      ],
                    ),
                    Row(
                      children: [
                        Text("Farm Type",style:TextStyle(
                            fontSize: 18
                        ) ,),
                        Text("Farm land",style:TextStyle(
                            fontSize: 18
                        ) ,)
                      ],
                    ),
                    Row(
                      children: [
                        Text("Land Size",style:TextStyle(
                            fontSize: 18
                        ) ,),
                        Text("250x250 ",style:TextStyle(
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
      size.width * 0.75, size.height * 0.75, // End of dent
    );

    // Right straight line
    path.lineTo(size.width, size.height * 0.75);
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
