

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelperMethods{
  static void showsnackbar({required BuildContext context,Duration duration=const Duration(milliseconds: 800),Color color=Colors.green,String message=""}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),backgroundColor: color,duration: duration,));

  }

  static shownotification(String message){
    
  }

}