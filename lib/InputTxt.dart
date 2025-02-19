import 'package:flutter/material.dart';

class TxtInput extends StatelessWidget {
  String labelTxt;
  TxtInput({super.key, required this.labelTxt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(labelTxt),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
                width: 3.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          enabledBorder:OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
                width: 2.0,

              ),
              borderRadius: BorderRadius.circular(10)
          ) ,

        ),
      ),
    );
  }
}