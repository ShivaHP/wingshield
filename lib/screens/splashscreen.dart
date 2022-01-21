import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wingshield_assignment/core/firebaseinstances/firestorecollections.dart';
import 'package:wingshield_assignment/core/utils/helpermethods.dart';
import 'package:wingshield_assignment/core/utils/sharedpref.dart';
import 'package:wingshield_assignment/screens/authentication/login.dart';
import 'package:wingshield_assignment/screens/dashboard/home.dart';

class SplashScreen extends StatefulWidget {
  static const String route="/";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      bool isloggedin=SharedPref.preferences?.getBool("isLoggedIn")??false;
      if(isloggedin){
        updateuserlocation();
        Navigator.pushNamed(context, Home.route);
      }
      else{
        Navigator.pushNamed(context, Login.loginroute);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade900
            ]
          )
        ),
        child:const Text("Welcome to Wingshield",style: TextStyle(color: Colors.white),),
      ),
    );
  }

  updateuserlocation()async{
    LocationPermission permissionStatus=await Geolocator.checkPermission();
    if(permissionStatus==LocationPermission.always||permissionStatus==LocationPermission.whileInUse){
      Position position=await Geolocator.getCurrentPosition();
      usercollectionreference.where("id",isEqualTo: firebaseAuth.currentUser?.uid).get().then((value){
        if(value.docs.isNotEmpty){
          value.docs[0].reference.update({
            "location":"${position.latitude},${position.longitude}"
          });
        }
      });
    }
    else {
      permissionStatus=await Geolocator.requestPermission();
      if(permissionStatus==LocationPermission.denied){
        HelperMethods.showsnackbar(context: context,message: "Permission Denied",color: Colors.red);
      }
      else{
        updateuserlocation();
      }

    }

  }
}