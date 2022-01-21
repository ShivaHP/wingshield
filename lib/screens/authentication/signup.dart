import 'dart:html';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wingshield_assignment/core/firebaseinstances/firestorecollections.dart';
import 'package:wingshield_assignment/core/utils/customwidgets.dart';
import 'package:wingshield_assignment/core/utils/helpermethods.dart';
import 'package:wingshield_assignment/core/utils/sharedpref.dart';
import 'package:wingshield_assignment/screens/authentication/login.dart';
import 'package:wingshield_assignment/screens/maps/googlemap.dart';

class SignUp extends StatefulWidget {
  static const String route="/signup";
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
 late TextEditingController namecontroller;
 late TextEditingController phonecontroller;
 late TextEditingController locationcontroller;
 GlobalKey<FormState> formkey=GlobalKey<FormState>();
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namecontroller=TextEditingController();
  }
 @override
 void dispose() {
   namecontroller.dispose();
   phonecontroller.dispose();
   super.dispose();
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text("Sign Up"),
      ),
      body: Container(
        child: Form(
          child: Column(
            children: [
            const  Text("Display Name"),
              const SizedBox(height: 20,),
              CustomTextField(
                controller: namecontroller,
                hinttext: "Enter your name",
                errormessage: "Enter a valid name",
              ),
              const SizedBox(height: 20,),
              CustomTextField(
                controller: phonecontroller,
                isphone: true,
              ),
           const   Text("Your Location"),
              CustomTextField(
                controller: locationcontroller,
                hinttext: "Enter your location",
                icon: Icons.pin_drop,
                enabled: false,
                callback: (){
                  getuserlocation();
                },
              ),
              ElevatedButton(onPressed: (){
                createuser();
              }, child:const Text("Create Account")),


            ],
          ),
        ),
      ),
    );
  }


  createuser()async{
    String deviceToken=await FirebaseMessaging.instance.getToken()??"";
    if(formkey.currentState!.validate()){
       usercollectionreference.add({
      "id":firebaseAuth.currentUser?.uid,
      "displayname":namecontroller.text,
      "phoneno":phonecontroller.text,
      "deviceToken":deviceToken,
      "location":locationcontroller.text
    }).then((value) {
      HelperMethods.showsnackbar(context: context,message: "Welcome to WingShield");
      SharedPref.preferences?.setBool("isLoggedIn", true);
     
    }).catchError((err){
      HelperMethods.showsnackbar(context: context,message: "Some error occured");
    });
    }
   
  }

  getuserlocation()async{
    LocationPermission permissionStatus=await Geolocator.checkPermission();
    if(permissionStatus ==LocationPermission.always||permissionStatus==LocationPermission.whileInUse){
      Position position=await Geolocator.getCurrentPosition();
      Navigator.pushNamed(context,GoogleMapFlutter.route,arguments:{
        "latitude":position.latitude,
        "longitude":position.longitude
      } ).then((value) {
        if(value!=null){
          LatLng latLng=value as LatLng;
          locationcontroller.text="${value.latitude},${value.longitude}";
          setState(() {
            
          });
        }
      });
    
    }
    else if(permissionStatus==LocationPermission.denied){
      permissionStatus=await Geolocator.requestPermission();
      if(permissionStatus==LocationPermission.denied){
        HelperMethods.showsnackbar(context: context,message: "Permission Denied",color: Colors.red);
      }
      else{
        getuserlocation();
      }
    }

  }

}

