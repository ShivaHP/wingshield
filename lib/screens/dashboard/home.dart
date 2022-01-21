

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:wingshield_assignment/core/provider/appuserprovider.dart';
import 'package:wingshield_assignment/core/utils/helpermethods.dart';
import 'package:wingshield_assignment/core/utils/sharedpref.dart';
import 'package:wingshield_assignment/screens/authentication/login.dart';
import 'package:wingshield_assignment/screens/dashboard/appuserlocations.dart';

class Home extends StatelessWidget {
  static const String route="/home";
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
    
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title:const Text("Home"),
        leading:const IconButton(icon: Icon(Icons.arrow_back,color: Colors.transparent,),onPressed: null,),
        actions: [
          IconButton(icon:const Icon(Icons.logout,color: Colors.white,),onPressed: (){
            logoutuser(context);

          },)
        ],
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: (){
              Navigator.pushNamed(context,AppUserLocations.route);
            },
            elevation: 10,
            
            child: Container(
              margin:const EdgeInsets.symmetric(vertical: 20),
              padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child:Column(
              
                children:const [
                  SizedBox(height: 10,),
                   Icon(Icons.people,color: Colors.black,),
                   
                   Text("Track Users Location"),
                ],
              ) ,
            ),
          ),
        ],
      ),
    );
  }
  logoutuser(BuildContext context){
    SharedPref.preferences?.clear();
    firebaseAuth.signOut();
    googleSignIn.signOut();
    Navigator.pushNamed(context,Login.loginroute);
  }
}