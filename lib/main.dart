import 'package:flutter/material.dart';
import "SignUp.dart";
import "package:safecrop/LogIn.dart";
import "Profile.dart";
import "Map.dart";
import "Alert.dart";
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(


    routes: {
      "/signUp":(context)=>SignUp(),
      "/Login":(context)=>Login(),
      "/map_pg":(context)=> MapPage(),
      "/alert":(context)=>Alert(),
    },
    home:LoaderPage(),
  )
  );
}

class Abc extends StatelessWidget {
  const Abc({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        "Hello World",
      style: TextStyle(
        color: Colors.teal,
      ),
    );
  }
}


class LoaderPage extends StatefulWidget {

  const LoaderPage({super.key});


  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  double loaderValue=0;




  @override
  void initState(){
    super.initState();

      LoaderIncrementation();


  }

  void LoaderIncrementation(){
    Future.delayed(Duration(seconds: 1),(){
      if(loaderValue<=1){
        setState(() {
          loaderValue=loaderValue+0.1;
        });

        print(loaderValue);
        LoaderIncrementation();
      }else{
        loaderValue=0;
        Navigator.pushNamed(context, '/alert');

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
          Image(image:AssetImage(
                  "assets/Logo.png"
              ),
            width: 50*20,
            height: 50*10,

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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),

          )
        ],
        
        
      ),
    );
  }
}



