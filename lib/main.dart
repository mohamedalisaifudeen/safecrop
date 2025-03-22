import 'package:flutter/material.dart';
import "SignUp.dart";
import "package:safecrop/LogIn.dart";
import "Profile.dart";
import "Map.dart";
import "Alert.dart";
import 'package:firebase_core/firebase_core.dart';
import "home_page.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:flutter/material.dart'; // Import the generated firebase_options.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import "UserDataProvider.dart";
import "OfficerAlert.dart";
import 'OrricerHome.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();

  String? token = await FirebaseMessaging.instance.getToken();
  print("Firebase Cloud Messaging Token: $token");

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
runApp(
      ChangeNotifierProvider(
        create: (context) => UserDataProvider(),
        child:MaterialApp(
          routes: {
            "/signUp":(context)=>SignUp(),
            "/Login":(context)=>Login(),
            "/map_pg":(context)=> MapPage(),
            "/alert":(context)=>Alert(),
            "/home":(context)=>HomePage(),
            "/officer":(context)=>AlertsApp(),
            "/officer-home":(context)=>OfficerHome(),

          },
          home:LoaderPage(),
        ) ,
      )
  );

}



Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  saveAlertToFirestore(message);
}

Future<void> saveAlertToFirestore(RemoteMessage message) async {
  if (message.notification != null) {
    FirebaseFirestore.instance.collection('notifications').add({
      'title': message.notification!.title ?? 'No Title',
      'body': message.notification!.body ?? 'No Body',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class LoaderPage extends StatefulWidget {

  const LoaderPage({super.key});


  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> with SingleTickerProviderStateMixin {

  double loaderValue=0;
  late AnimationController _controller;
  late Animation<Offset> _safeAnimation;
  late Animation<Offset> _cropAnimation;



  @override
  void initState(){
    super.initState();

      LoaderIncrementation();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      saveAlertToFirestore(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      saveAlertToFirestore(message);
      print('App opened from background: ${message.notification?.title}');
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );


    _safeAnimation = Tween<Offset>(
      begin: Offset(-1.5, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));


    _cropAnimation = Tween<Offset>(
      begin: Offset(1.5, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        Navigator.pushNamed(context, '/Login');

      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center all column children
            children: [
              const Spacer(flex: 2),
              // Logo Container with Circle Border
              Center( // Ensure logo is centered
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(35),
                      child:SpinKitFadingCube(
                        color: Colors.green,
                        size: 50.0,
                          duration: Duration(seconds: 3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child:               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  SlideTransition(
                  position: _safeAnimation,
                  child: Text(
                    'Safe',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3B55),
                    ),
                  ),
                ),
                    SlideTransition(
                      position: _cropAnimation,
                      child: Text(
                        'Crop',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SafeCrop Text

              const SizedBox(height: 8),

              // Initializing System Text
              Text(
                'Initializing System...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),

              // Connecting to sensors Text
              Text(
                'Connecting to sensors...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 32),

              // Status Indicators in a Column
              Center(child:            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(left: 40),child: _buildStatusIndicator('Fence monitoring active')),
                  const SizedBox(height: 12),
                  Padding(padding: EdgeInsets.only(left: 10),child: _buildStatusIndicator('Network connected')),

                  const SizedBox(height: 12),
                  _buildStatusIndicator('GPS signal strong'),
                ],
              )),

              const Spacer(flex: 3),

              // Bottom Text
              const Text(
                'Wildlife Protection Systems',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D3B55),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the row contents
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2D3B55),
          ),
        ),
      ],
    );
  }
}



