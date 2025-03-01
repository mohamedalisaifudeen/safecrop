import 'package:flutter/material.dart';
import "SignUp.dart";
import "package:safecrop/LogIn.dart";
import "home_page.dart";

void main() {
  runApp(MaterialApp(
    routes: {
      "/signUp": (context) => HomePage(),
      "/Login": (context) => Login(), // Route for HomePage
    },
    home: LoaderPage(),
  ));
}

class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  double loaderValue = 0;

  @override
  void initState() {
    super.initState();

    LoaderIncrementation();
  }

  void LoaderIncrementation() {
    Future.delayed(Duration(seconds: 1), () {
      if (loaderValue <= 1) {
        setState(() {
          loaderValue = loaderValue + 0.1;
        });

        print(loaderValue);
        LoaderIncrementation();
      } else {
        loaderValue = 0;
        Navigator.pushNamed(context, '/Login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/Logo.png"),
            width: 50 * 20,
            height: 50 * 10,
          ),
          LinearProgressIndicator(
            value: loaderValue,
            color: Colors.green,
            minHeight: 5,
            borderRadius: BorderRadius.circular(10),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Copyright © ${DateTime.now().year} all rights reserved",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
