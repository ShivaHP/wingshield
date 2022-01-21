import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wingshield_assignment/core/firebaseinstances/firestorecollections.dart';
import 'package:wingshield_assignment/core/utils/helpermethods.dart';
import 'package:wingshield_assignment/screens/authentication/signup.dart';

FirebaseAuth firebaseAuth=FirebaseAuth.instance;
class Login extends StatefulWidget {
  static const String loginroute="/login";
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignIn _googleSignIn=GoogleSignIn();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((message) {

    });
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title:const Text("Login"),
        
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         const Text("Welcome to the WingShield App/n We are happy to move with you forward",style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),),
          ElevatedButton(onPressed: (){}, child:const Text("Login with Google"))
        ],
      ),
    );
  }
  loginwithgoogle()async{
   try {
     GoogleSignInAccount? googleSignInAccount =await _googleSignIn.signIn();
     GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount!.authentication;
     OAuthCredential googleAuthProvider=GoogleAuthProvider.credential(
       idToken: googleSignInAuthentication.idToken,
       accessToken: googleSignInAuthentication.accessToken
     );
       await firebaseAuth.signInWithCredential(googleAuthProvider);
       checkuserexist();
   } on Exception catch (e) {
     print(e);
     HelperMethods.showsnackbar(context: context,message: "Some error occured",color: Colors.red);
     // TODO
   }

  }

  checkuserexist(){
    usercollectionreference.where("id",isEqualTo: firebaseAuth.currentUser?.uid).get().then((value) async{
      if(value.docs.isEmpty){
        Navigator.pushNamed(context,SignUp.route);
      }
      else{
        String devicetoken=await FirebaseMessaging.instance.getToken()??"";
        value.docs[0].reference.update({
          "deviceToken":devicetoken
        });
      }
    });

  }



}