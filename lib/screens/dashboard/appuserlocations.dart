import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wingshield_assignment/core/models/usermodel.dart';
import 'package:wingshield_assignment/core/provider/appuserprovider.dart';
import 'package:wingshield_assignment/core/utils/extensions.dart';
import 'package:wingshield_assignment/core/utils/helpermethods.dart';
import 'package:wingshield_assignment/core/utils/sharedpref.dart';

class AppUserLocations extends StatefulWidget {
  static const String route="/userslocation";
  AppUserLocations({Key? key}) : super(key: key);

  @override
  _AppUserLocationsState createState() => _AppUserLocationsState();
}

class _AppUserLocationsState extends State<AppUserLocations> {
  late CameraPosition cameraPosition;
  Completer<GoogleMapController> mapcontroller = Completer();
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializedata();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapcontroller.future.then((value) => value.dispose());
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
       body: Stack(
         children: [  
           Selector<AppUsersProvider,Set<Marker>>(
             selector: (context,state)=>state.userlocations,
             builder: (context,markers,child) {
              
               return GoogleMap(
                   initialCameraPosition: cameraPosition,
                   markers:markers,
                   onMapCreated: (controller) {
                     mapcontroller.complete(controller);
                   });
             }
           ),
           Selector<AppUsersProvider,bool>(builder: (context,isloading,child){
             return Visibility(visible: isloading,child: Container(
               alignment: Alignment.center,
               padding:const EdgeInsets.all(10),
               child:const CircularProgressIndicator(),
             ),);
           }, selector:(context,value)=>value.isloading),
             Container(
               margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top+20,left:20),

             decoration: BoxDecoration(
               color: Colors.blue.shade300,
               borderRadius: BorderRadius.circular(10)
             ),
             child: IconButton(icon:const Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
               Navigator.pop(context);
             },),
           ),
         ],
       ),
     );
  }
  initializedata(){
    context.read<AppUsersProvider>().fetchappusers();
    String currentuser=SharedPref.preferences?.getString("user")??"";
    UserModel user=UserModel();
    if(currentuser.isNotEmpty){
       user=UserModel.fromJson(jsonDecode(currentuser));
    }
    List<String> location=user.location.split(",");
    cameraPosition = CameraPosition(target: LatLng(location[0].todouble(), location[1].todouble()),zoom: 15);
    futurecallback();
  }
  //in case map is not loaded quickly 
  futurecallback(){
    Future.delayed(const Duration(seconds: 3),(){
      if(mapcontroller.isCompleted){
        HelperMethods.showsnackbar(context: context,message: "Tap on Pins to get details");
          context.read<AppUsersProvider>().fetchappusers();
      }
    });
  }

}
