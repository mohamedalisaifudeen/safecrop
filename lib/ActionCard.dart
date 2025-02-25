import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  String txt;
  Widget icon;
  AlertCard({required this.txt,required this.icon});

  @override
  Widget build(BuildContext context) {
    return  Padding(padding:EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(right: 10),
            child:icon,),

          Text(txt),
        ],
      ),);
  }
}
