import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:wingshield_assignment/core/firebaseinstances/firestorecollections.dart';
import 'package:wingshield_assignment/screens/authentication/login.dart';

class AppRepository{
  
static updateuserlocation()async{
   Timer.periodic(const Duration(seconds: 5),(value)async{
      //checking the permission
       LocationPermission permissionStatus=await Geolocator.checkPermission();
    
       //update the location if the permission is always or once
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
      //requesting in case denied permission
      LocationPermission permission=await Geolocator.requestPermission();
      if(permission==LocationPermission.denied){

      }
      else{
        updateuserlocation();
      }
    }
  });
   
}
}
