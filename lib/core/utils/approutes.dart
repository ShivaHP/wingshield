import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wingshield_assignment/core/provider/appuserprovider.dart';
import 'package:wingshield_assignment/screens/authentication/login.dart';
import 'package:wingshield_assignment/screens/authentication/signup.dart';
import 'package:wingshield_assignment/screens/dashboard/appuserlocations.dart';
import 'package:wingshield_assignment/screens/dashboard/home.dart';
import 'package:wingshield_assignment/screens/maps/googlemap.dart';
import 'package:wingshield_assignment/screens/splashscreen.dart';


class AppRoute{
  
static Route approutes(RouteSettings settings){
  Map arguments={};
  print("setting $arguments");
  if(settings.arguments!=null){
    arguments=settings.arguments as Map;
  }

  switch(settings.name){
    case GoogleMapFlutter.route:
    return MaterialPageRoute(builder: (context)=>GoogleMapFlutter(latitude: arguments["latitude"],longitude: arguments["longitude"],));
    case SignUp.route:
    return MaterialPageRoute(builder: (context)=>SignUp());
    case Home.route:
    return MaterialPageRoute(builder: (context)=>const Home());
    case Login.loginroute:
    return MaterialPageRoute(builder: (context)=>Login());
    case AppUserLocations.route:
    return MaterialPageRoute(builder: (context)=>AppUserLocations());
    case SplashScreen.route:
     return MaterialPageRoute(builder: (context)=>const SplashScreen());
    default:
    return MaterialPageRoute(builder: (context)=>const SplashScreen());
  }
}
}
