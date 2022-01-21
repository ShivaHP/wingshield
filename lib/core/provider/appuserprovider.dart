import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wingshield_assignment/core/firebaseinstances/firestorecollections.dart';
import 'package:wingshield_assignment/core/models/usermodel.dart';
import 'package:wingshield_assignment/core/utils/extensions.dart';

class AppUsersProvider extends ChangeNotifier {
  List<UserModel> users;
  bool isloading;
  Set<Marker> userlocations;
  AppUsersProvider({this.users = const [], this.isloading = false,this.userlocations=const {}});

//creating repository functions to fetch all users of the app
  fetchappusers() async {
    try {
    //  isloading = true;
     // notifyListeners();

      List<UserModel> tempusers = [];
      //getting all users of the app
      QuerySnapshot snapshot = await usercollectionreference.get();
    
      snapshot.docs.forEach((element) async {
        //converting to  user information to model
        UserModel user = UserModel.fromJson(element.data() as Map);

        List<String> location = user.location.split(",");
        print("locatioin:$location");
        //getting user proper addression by reverse geocoding

        List<Placemark> placemarks = await placemarkFromCoordinates(
            location[0].todouble(), location[1].todouble());

        if (placemarks.isNotEmpty) {
          user.useraddress = "${placemarks[0].name},${placemarks[0].street}";
        }
        //adding the user to the users list
        tempusers.add(user);
      });
     getuserlocations();
      //finishing operation and updating the state
      users = tempusers;
      isloading = false;
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw Exception("Some error occured");
      // TODO
    }
  }

//adding custom function to get all user data in the form of markers
   getuserlocations() {
  
    Set<Marker> markers = {};

    users.forEach((element) {
   
      List<String> location = element.location.split(",");

      markers.add(Marker(
        
          markerId: MarkerId(element.hashCode.toString()),
          position: LatLng(location[0].todouble(), location[1].todouble()),
          flat: true,
          infoWindow: InfoWindow(
          
              title: element.displayname, snippet: element.useraddress)));
    });
    
   userlocations=markers;
 
  
  }
 
 
  }
  

