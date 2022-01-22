

import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wingshield_assignment/core/provider/repository.dart';

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
    AppRepository.updateuserlocation();
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
              Colors.purple.shade700,
              Colors.yellow.shade600
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:const [
            Icon(CupertinoIcons.ant_circle_fill,color: Colors.white,size: 100),
           
            Text("Social Finders",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w900,fontStyle: FontStyle.italic),),

          ],
        ),
      ),
    );
  }

  

 }



