import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';

import 'package:wingshield_assignment/core/firebaseinstances/firestorecollections.dart';
import 'package:wingshield_assignment/core/models/usermodel.dart';
import 'package:wingshield_assignment/core/provider/repository.dart';
import 'package:wingshield_assignment/core/provider/userprovider.dart';
import 'package:wingshield_assignment/core/utils/helpermethods.dart';
import 'package:wingshield_assignment/core/utils/sharedpref.dart';
import 'package:wingshield_assignment/screens/authentication/signup.dart';
import 'package:wingshield_assignment/screens/dashboard/home.dart';
import 'package:wingshield_assignment/screens/splashscreen.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class Login extends StatefulWidget {
  static const String loginroute = "/login";
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text("Login"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.blue.shade900,
          onPressed: null,
        ),
      ),
      body: Container(
        margin:const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          children: [
        
            const Text(
              "Welcome to the WingShield App",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Login to find your nearby",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Icon(
              CupertinoIcons.person_crop_circle_fill,
              size: 40,
              color: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade900,
                    padding: EdgeInsets.symmetric(
                        horizontal: isloading ? 60 : 40, vertical: 10)),
                onPressed: () {
                  loginwithgoogle();
                },
                child: isloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ))
                    : const Text("Login with Google"))
          ],
        ),
      ),
    );
  }

  loginwithgoogle() async {
    try {
      setState(() {
        isloading=true;
      });
      //using instance signin the user
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if(googleSignInAccount==null){
        HelperMethods.shownotification("Authentication Status", "Login Neglected by User");
        HelperMethods.showsnackbar(context: context,message: "Login Neglected by User");
        setState(() {
          isloading=false;
        });
      }
      //getting the authentication for creater googleauthprovider
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      //creating credential from GoogleAuthProvider to signin user to firebase
      OAuthCredential googleAuthProvider = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      //signin the user into the firebase
      await firebaseAuth.signInWithCredential(googleAuthProvider);

      //check if user exist then login him in with updating his device token
      checkuserexist();
    } on Exception catch (e) {
      setState(() {
        isloading=false;
      });
      print("Error:$e");
      HelperMethods.showsnackbar(
          context: context, message: "Some error occured", color: Colors.red);
    }
  }

  checkuserexist() {
    //checking user with the userid
    usercollectionreference
        .where("id", isEqualTo: firebaseAuth.currentUser?.uid)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        setState(() {
          isloading=false;
        });
        Navigator.pushNamed(context, SignUp.route);
      } else {
        //storing user and updating our currentuser provider
        UserModel userModel = UserModel.fromJson(value.docs[0].data() as Map);
        SharedPref.preferences?.setBool("isLoggedIn", true);
        SharedPref.preferences
            ?.setString("user", jsonEncode(userModel.toJson()));
        context.read<CurrentUserProvider>().updateuser(userModel);

        //getting the device token from firebase
        String devicetoken = await FirebaseMessaging.instance.getToken() ?? "";

        //updating user
        value.docs[0].reference.update({"deviceToken": devicetoken});
        HelperMethods.shownotification("Account Verified","Welcome to the WingShield");
       AppRepository.updateuserlocation();
        Navigator.pushNamed(context, Home.route);
      }
    }).catchError((er){
      setState(() {
        isloading=false;
      });
    });
  }
}
