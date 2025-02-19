import 'package:flutter/material.dart';
class CustomBtn extends StatelessWidget {
  VoidCallback click;
  String txt;
  Color color;
  CustomBtn({super.key, required this.click,required this.txt,required this.color});

  @override
  Widget build(BuildContext context) {
    return     SizedBox(
      child:Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10)
        ),
        width: MediaQuery.of(context).size.width-80,
        child:TextButton(onPressed: click,
          child: Text(
            txt,
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700
            ),
          ),

        ),
      ),

    );
  }
}