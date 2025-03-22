import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "InputTxt.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool? checkfarmer = true;
  bool? checkOfficer = false;
  String? username;
  String emial = "";
  String? mobile;
  String password = "";
  String option = "";
  bool emailErrorTxt = false;
  bool passwordError = false;
  String? uid = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var db = FirebaseFirestore.instance;

  void addDatabase(String? uid, String? username, bool? checkfarmer,String? mobile) {
    final user = <String, dynamic>{
      "uid": uid,
      "username": username,
      "type": (checkfarmer ?? false) ? "Farmer" : "Officer",
      "mobile":mobile,
    };

    db
        .collection("userDetails")
        .add(user)
        .then((DocumentReference doc) => print("Added with ID: ${doc.id}"));
  }

  Future<void> createUser(String password, String email) async {
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      uid = cred.user?.uid;
      print(username);

      addDatabase(uid, username, checkfarmer,mobile);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        print("The password provided is too weak");
        setState(() {
          passwordError = true;
        });
      } else if (e.code == "email-already-in-use") {
        print("The account already exists with the above email id");
        setState(() {
          emailErrorTxt = true;
        });
      }
    } catch (e) {
      print(e);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image(image: AssetImage("assets/Logo.png")),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          left: 50, right: 50, bottom: 30, top: 30),
                      child: Column(
                        children: [
                          TxtInput(
                            labelTxt: "Username",
                            password: false,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                            value: (value) {
                              setState(() {
                                username = value;
                              });
                            },
                          ),
                          TxtInput(
                            labelTxt: "Email",
                            password: false,
                            validator: (String? value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains("@") ||
                                  !value.contains(".com")) {
                                return "Enter a valid email id";
                              } else if (emailErrorTxt) {
                                return "Email already in use";
                              }
                              return null;
                            },
                            number: TextInputType.emailAddress,
                            value: (value) {
                              setState(() {
                                emial = value;
                              });
                            },
                          ),
                          TxtInput(
                            labelTxt: "Mobile Number",
                            password: false,
                            number: TextInputType.number,
                            formatter: [FilteringTextInputFormatter.digitsOnly],
                            validator: (String? value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length != 10) {
                                return "Please enter a valid number ";
                              }
                              return null;
                            },
                            value: (value) {
                              setState(() {
                                mobile = value;
                              });
                            },
                          ),
                          TxtInput(
                            labelTxt: "Password",
                            password: true,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter some text";
                              } else if (passwordError) {
                                return "The password provided is too weak";
                              }
                              return null;
                            },
                            value: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                        ],
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 60, bottom: 5),
                        child: Text(
                          "I am a,",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.green,
                                side: BorderSide(color: Colors.green, width: 3),
                                value: checkfarmer,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkOfficer = false;
                                    checkfarmer = newValue;
                                  });
                                },
                              ),
                              Text(
                                "Farmer",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.green,
                                side: BorderSide(color: Colors.green, width: 3),
                                value: checkOfficer,
                                onChanged: (vaue) {
                                  setState(() {
                                    checkfarmer = false;
                                    checkOfficer = vaue;
                                  });
                                },
                              ),
                              Text(
                                "Officer",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              )
                            ],
                          )
                        ],
                      ),
                      Center(
                        child: Text(
                          (checkfarmer == false && checkOfficer == false)
                              ? "Please select an option"
                              : option,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width - 80,
                      child: TextButton(
                        onPressed: () {
                          final bool isvalid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isvalid ||
                              (checkfarmer == false && checkOfficer == false)) {
                            return;
                          }
                            createUser(password, emial).then((_){
                              _formKey.currentState?.reset();
                            });



                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
