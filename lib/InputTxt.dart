import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class TxtInput extends StatelessWidget {
  String labelTxt;
  String? Function(String?)? validator;
  bool password=false;
  void Function(String)? value;
  TextInputType? number=TextInputType.text;
  List<TextInputFormatter>? formatter;
  TxtInput({required this.labelTxt,required this.validator,required this.value,this.number,this.formatter,required this.password});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        obscureText:password ,
        keyboardType:number ,
        inputFormatters: formatter,
        onChanged:value ,
        decoration:  InputDecoration(
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
        validator: validator,
      ),
    );
  }
}