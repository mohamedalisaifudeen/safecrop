import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataProvider with ChangeNotifier {
  String voltage = '0.0V';
  double lat=0.0;
  double long=0.0;
  String status="active";

  Future<String> fetchData() async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("userDetails").where("uid",isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots().listen(
              (querySnapshot) {
                print("Successfully completed");
                final read_vals = querySnapshot.docs.first;
                  this.voltage = read_vals.get("voltage").toString();
                notifyListeners();

              });
      return voltage;
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> fetchDataMap() async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("userDetails").where("uid",isEqualTo: FirebaseAuth.instance.currentUser?.uid).get().then(
              (querySnapshot) {
            print("Successfully completed");
            final read_vals = querySnapshot.docs.first;
            this.lat = read_vals.get("latitude").toDouble();
            this.long = read_vals.get("longitude").toDouble();
            notifyListeners();

          });
      return {"lat":lat,"long":long};
    } catch (error) {
      throw error;
    }
  }



  void listenToVoltage(Function(String) updateVoltage) {
    FirebaseFirestore.instance
        .collection("userDetails")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final read_vals = querySnapshot.docs.first;
        voltage = read_vals.get("voltage").toString();
        updateVoltage(voltage); // Update voltage in the UI using the callback function
      }
    });
  }

}
