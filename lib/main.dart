import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wingshield_assignment/core/utils/approutes.dart';
import 'package:wingshield_assignment/core/utils/sharedpref.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

AndroidNotificationChannel androidNotificationChannel=const AndroidNotificationChannel(
  "wingshieldchannel",
  "wingshieldnotification",
description: "this is wingshield notification"
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  flutterLocalNotificationsPlugin.initialize(InitializationSettings(
    android:const AndroidInitializationSettings("@mipmap/ic_launcher")
  ));
  
  await Firebase.initializeApp();
  SharedPref.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: AppRoute.approutes,
    );
  }
}
