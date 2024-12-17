import 'package:flutter/material.dart';
import 'InputTxt.dart';
import "CustomBtn.dart";



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool? farmercheck=false;
  bool? officercheck=false;
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
                              margin: EdgeInsets.only(left: 50,right: 50,bottom: 60,top: 40),
                              child:Column(
                                children: [
                                  TxtInput(labelTxt: "Email"),
                                  TxtInput(labelTxt: "Password"),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 5,bottom: 10,top: 20),
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
                                                value: farmercheck,
                                                onChanged: (Value){
                                                  setState(() {
                                                    officercheck=false;
                                                    farmercheck=Value;
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
                                                value:officercheck,
                                                onChanged: (vaue){
                                                  setState(() {
                                                    farmercheck=false;
                                                    officercheck=vaue;
                                                  }
                                                  );

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
                                      ),
                                      CustomBtn(click: (){

                                      },
                                        txt: "Log In",
                                        color: Colors.green,
                                      ),

                                      CustomBtn(click: (){
                                        Navigator.pushNamed(context, '/signUp');
                                      },
                                        txt: "Go to Sign Up",
                                        color: Colors.teal,
                                      ),


                                    ],
                                  ),

                                ],
                              )
                          ),
                        ],
                      )
                  )
              )
            ],
          )),
    );
  }
}






