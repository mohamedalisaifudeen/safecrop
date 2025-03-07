import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import the generated firebase_options.dart
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'LogIn.dart';
import 'home_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the configuration from firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request permission to send notifications on iOS (necessary for iOS)
  await FirebaseMessaging.instance.requestPermission();

  // Get the Firebase Cloud Messaging token
  String? token = await FirebaseMessaging.instance.getToken();
  print("Firebase Cloud Messaging Token: $token");

  // Initialize background message handler (this is required to handle messages when the app is in the background or terminated)
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(MyApp());
}

// Background message handler
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  print(
      'Background message: ${message.notification?.title}, ${message.notification?.body}');
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

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message in foreground: ${message.notification?.title}');
      // You can handle the notification here (e.g., show a dialog, navigate, etc.)
    });

    // Handle when the app is opened from a background message
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from background: ${message.notification?.title}');
      // Navigate or perform any other actions as needed
    });
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
          ),
        ],
      ),
    );
  }
}
