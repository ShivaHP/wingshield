import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wingshield_assignment/core/utils/helpermethods.dart';

class GoogleMapFlutter extends StatefulWidget {
  final double latitude;
  final double longitude;
  static const String route="/googlemap";
const  GoogleMapFlutter({Key? key,required this.latitude,required this.longitude}) : super(key: key);

  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapFlutter> {
  Completer<GoogleMapController> controller=Completer<GoogleMapController>();
  late CameraPosition initialposition;
  Set<Marker> markers={};
 late LatLng userposition;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialposition=CameraPosition(
      target: LatLng(
        widget.latitude,widget.longitude, 
      ),
      zoom: 20
    );
    userposition=LatLng(widget.latitude,widget.longitude);
    markers.add(Marker(markerId: MarkerId(userposition.hashCode.toString()),position: userposition));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.future.then((value) => value.dispose());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialposition,
            onMapCreated: (mapcontroller){
              controller.complete(mapcontroller);
            },
            markers: markers,
            onTap: (latlng){
              markers={};
              markers.add(Marker(markerId: MarkerId(latlng.toString()),position: latlng,));
              userposition=latlng;
              setState(() {
                
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin:const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(onPressed: (){
                saveposition();
              }, child:const Text("Save Position")),
            ),
          )
        ],
      ),
    );
  }
  saveposition(){
    HelperMethods.showsnackbar(context: context,message: "Your Position Saved Successfully");
    Navigator.pop(context,userposition);
    
  }
}