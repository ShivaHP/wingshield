import 'dart:convert';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:wingshield_assignment/core/firebaseinstances/firestorecollections.dart';
import 'package:wingshield_assignment/core/models/usermodel.dart';
import 'package:wingshield_assignment/core/provider/userprovider.dart';
import 'package:wingshield_assignment/core/utils/customwidgets.dart';
import 'package:wingshield_assignment/core/utils/helpermethods.dart';
import 'package:wingshield_assignment/core/utils/sharedpref.dart';
import 'package:wingshield_assignment/screens/authentication/login.dart';
import 'package:wingshield_assignment/screens/dashboard/home.dart';
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
 bool isloading=false;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namecontroller=TextEditingController();
    phonecontroller=TextEditingController();
    locationcontroller=TextEditingController();
    getuserlocation(launchmap: false);
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
        title:const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Container(
            padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Visibility(
                visible: firebaseAuth.currentUser!=null,
                child: Container(
                  alignment: Alignment.center,
                  margin:const EdgeInsets.only(bottom: 20),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(firebaseAuth.currentUser?.photoURL??""),
                  ),
                ),
              ),
              const  Text("Display Name",style: TextStyle(fontWeight: FontWeight.bold),),
                
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: CustomTextField(
                    controller: namecontroller,
                    hinttext: "Enter your name",
                    errormessage: "Enter a valid name",
                  ),
                ),
             
                const Text("Enter your mobile number",style: TextStyle(fontWeight: FontWeight.bold)),
            
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: CustomTextField(
                    controller: phonecontroller,
                    isphone: true,
                    hinttext: "Enter your mobile number",
                    errormessage: "Enter a valid phone number",
                  ),
                ),
                const   Text("Your Location",style:  TextStyle(fontWeight: FontWeight.bold),),
                   
                InkWell(
                  onTap: (){
                    getuserlocation();
                  },
                  child: Container(
                    margin:const EdgeInsets.symmetric(vertical: 20),
                    child: CustomTextField(
                      controller: locationcontroller,
                      hinttext: "Enter your location",
                      icon: Icons.pin_drop,
                      errormessage: "Select a valid location",
                      enabled: false,
                     
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade900,
                    padding: EdgeInsets.symmetric(horizontal:isloading? 60:40,vertical: 10)
                  ),onPressed: (){
                    createuser();
                  }, child:isloading?const SizedBox(width: 20,height: 20,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),): const Text("Create Account")),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }


  createuser()async{
   //if user validated
    if(formkey.currentState!.validate()){
      HelperMethods.showsnackbar(context: context,message: "Creating your account");
      setState(() {
        isloading=true;
      });

      //getting the device token from firebase
       String deviceToken=await FirebaseMessaging.instance.getToken()??"";

       //creating userobject for database storing purpose
       UserModel userModel=UserModel.fromJson({
      "id":firebaseAuth.currentUser?.uid,
      "displayname":namecontroller.text,
      "phoneno":phonecontroller.text,
      "deviceToken":deviceToken,
      "location":locationcontroller.text
    });
    //adding the user to the database
       usercollectionreference.add(userModel.toJson()).then((value) {

      HelperMethods.showsnackbar(context: context,message: "Welcome to WingShield");
      //updating the currentuser provider
      context.read<CurrentUserProvider>().updateuser(userModel);

      //storing locally user also
      SharedPref.preferences?.setString("user", jsonEncode(userModel.toJson()));

      //storing the userlogged in session
      SharedPref.preferences?.setBool("isLoggedIn", true);
      HelperMethods.shownotification("Authentication Update","Signed Up Successfully");
      Navigator.pushNamed(context, Home.route);

    }).catchError((err){
      HelperMethods.shownotification("Authentication Status", "Failed SignUp");
      HelperMethods.showsnackbar(context: context,message: "Some error occured");
      setState(() {
        isloading=false;
      });
    });
    }
   
  }

  getuserlocation({bool launchmap=true})async{
    //checking permission
    LocationPermission permissionStatus=await Geolocator.checkPermission();

    if(permissionStatus ==LocationPermission.always||permissionStatus==LocationPermission.whileInUse){
      //getting the nearest position points
      Position position=await Geolocator.getCurrentPosition();
      locationcontroller.text="${position.latitude},${position.longitude}";
      if(launchmap){
          Navigator.pushNamed(context,GoogleMapFlutter.route,arguments:{
        "latitude":position.latitude,
        "longitude":position.longitude
      } ).then((value) {
        if(value!=null){
           value as LatLng; 
          locationcontroller.text="${value.latitude},${value.longitude}";
          setState(() {
            
          });
        }
      });
      }
    
    
    }
    else if(permissionStatus==LocationPermission.denied){
      //in case of permission denied requesting permission
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

