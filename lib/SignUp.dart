import 'package:flutter/material.dart';
import "InputTxt.dart";

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool? checkfarmer=false;
  bool? checkOfficer=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Center(
                child:Image(image: AssetImage(
                    "assets/Logo.png"
                )
                ),
              ),
              Expanded(
                  child: Form(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 50,right: 50,bottom: 30,top: 30),
                              child:Column(
                                children: [
                                  TxtInput(labelTxt: "Username"),
                                  TxtInput(labelTxt: "Email"),
                                  TxtInput(labelTxt: "Mobile Number"),
                                  TxtInput(labelTxt: "Password"),

                                ],
                              )
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 60,bottom: 5),
                                child: Text("I am a,",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        activeColor: Colors.green,
                                        side: BorderSide(
                                            color: Colors.green,
                                            width: 3
                                        ),
                                        value: checkfarmer,
                                        onChanged: (newValue){
                                          setState(() {
                                            checkOfficer=false;
                                            checkfarmer=newValue;
                                          });
                                        },

                                      ),
                                      Text(
                                        "Farmer",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400
                                        ),
                                      )
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Checkbox(
                                        activeColor: Colors.green,
                                        side: BorderSide(
                                            color: Colors.green,
                                            width: 3
                                        ),
                                        value: checkOfficer,
                                        onChanged: (vaue){
                                          setState(() {
                                            checkfarmer=false;
                                            checkOfficer=vaue;
                                          });

                                        },

                                      ),
                                      Text(
                                        "Officer",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400
                                        ),
                                      )
                                    ],
                                  )

                                ],
                              )
                            ],
                          ),

                          SizedBox(
                            child:Container(
                            margin: EdgeInsets.only(top: 20),
                           decoration: BoxDecoration(
                               color: Colors.green,
                             borderRadius: BorderRadius.circular(10)
                           ),
                            width: MediaQuery.of(context).size.width-80,
                            child:TextButton(onPressed: (){

                            },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700
                                ),
                              ),

                            ),
                          ),

                          ),


                        ],
                      ),
                  ),
              ),
            ],

          ),
      ),
    );
  }
}



