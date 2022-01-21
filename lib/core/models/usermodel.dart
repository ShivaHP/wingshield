import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String id;
  final String displayname;
  final String phonenumber;
  final String devicetoken;
   String location;
  String useraddress;
  UserModel({this.id="",this.displayname="",this.phonenumber="",this.devicetoken="",this.location="",this.useraddress=""});
  factory UserModel.fromJson(Map data){
 
    return UserModel(
      id: data["id"]??"",
      displayname: data["displayname"]??"",
      phonenumber: data["phoneno"]??"",
      devicetoken: data["deviceToken"]??"",
      location: data["location"]??""
    );
  }

  Map<String,String> toJson(){
    return {
      "id": id,
      "displayname":displayname,
      "phoneno":phonenumber,
      "deviceToken":devicetoken,
      "location":location
    };
  }
}