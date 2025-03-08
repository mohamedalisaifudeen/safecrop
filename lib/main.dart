import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import the generated firebase_options.dart
import 'package:firebase_messaging/firebase_messaging.dart'; // Firebase Messaging
import 'LogIn.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();

  String? token = await FirebaseMessaging.instance.getToken();
  print("Firebase Cloud Messaging Token: $token");

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(MyApp());
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/signUp": (context) => HomePage(),
        "/Login": (context) => Login(),
      },
      home: LoaderPage(),
    );
  }
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      saveAlertToFirestore(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from background: ${message.notification?.title}');
    });
  }

  void LoaderIncrementation() {
    Future.delayed(Duration(seconds: 1), () {
      if (loaderValue <= 1) {
        setState(() {
          loaderValue += 0.1;
        });
        LoaderIncrementation();
      } else {
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
          Image.asset("assets/Logo.png", width: 1000, height: 500),
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
          ),
        ],
      ),
    );
  }
}
