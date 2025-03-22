import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'alert_screen.dart';

void main() async {
  // Ensures that Flutter bindings are initialized before using Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase before running the app.
  await Firebase.initializeApp();

  // Runs the Flutter application.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner.
      home: AlertScreen(), // Sets `AlertScreen` as the home screen.
    );
  }
}
