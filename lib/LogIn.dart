import 'package:flutter/material.dart';
import 'InputTxt.dart';
import "CustomBtn.dart";
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool? farmercheck = false;
  bool? officercheck = false;
  String email="";
  String password="";
  bool emailError=false;
  bool passError=false;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> signInUser(String email, String password) async {
    try {
      final credencial = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Login Sucess");
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
        setState(() {
          emailError=true;
        });
      } else if (e.code == "wrong-password") {
        print("Wrong password provided for that user.");
        setState(() {
          passError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Center(
            child: Image(image: AssetImage("assets/Logo.png")),
          ),
          Expanded(
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                              left: 50, right: 50, bottom: 60, top: 40),
                          child: Column(
                            children: [
                              TxtInput(
                                labelTxt: "Email",
                                password: false,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty||
                                      !value.contains("@") ||
                                      !value.contains(".com")) {
                                    return "Please enter a valid email id ";
                                  }else if(emailError){
                                    return "No user found for that email";
                                  }
                                  return null;
                                },
                                value: (value) {
                                  email=value;
                                },
                              ),
                              TxtInput(
                                labelTxt: "Password",
                                password: true,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter some text";
                                  }else if(passError){
                                    return "Wrong password provided for that user.";
                                  }
                                  return null;
                                },
                                value: (value) {
                                  password=value;
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 5, bottom: 10, top: 20),
                                    child: Text(
                                      "I am a,",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Colors.green,
                                            side: BorderSide(
                                                color: Colors.green, width: 3),
                                            value: farmercheck,
                                            onChanged: (Value) {
                                              setState(() {
                                                officercheck = false;
                                                farmercheck = Value;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Farmer",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Colors.green,
                                            side: BorderSide(
                                                color: Colors.green, width: 3),
                                            value: officercheck,
                                            onChanged: (vaue) {
                                              setState(() {
                                                farmercheck = false;
                                                officercheck = vaue;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Officer",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  CustomBtn(
                                    click: () {
                                      final bool isvalid =
                                          _formKey.currentState?.validate() ??
                                              false;
                                      if (!isvalid) {
                                        return;
                                      };
                                      signInUser(email, password);
                                    },

                                    txt: "Log In",
                                    color: Colors.green,

                                  ),
                                  CustomBtn(
                                    click: () {
                                      Navigator.pushNamed(context, '/signUp');
                                    },
                                    txt: "Go to Sign Up",
                                    color: Colors.teal,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ))))
        ]),
      ),
    );
  }
}
