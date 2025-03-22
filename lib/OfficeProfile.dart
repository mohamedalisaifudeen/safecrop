import 'package:flutter/material.dart';
import "Profile.dart";
import "OfficerNav.dart";
class Officeprofile extends StatelessWidget {
  const Officeprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Profile(bottombar:Officernav(),);
  }
}
