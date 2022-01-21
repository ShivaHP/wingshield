import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:wingshield_assignment/core/models/usermodel.dart';
import 'package:wingshield_assignment/core/provider/appuserprovider.dart';
import 'package:wingshield_assignment/core/provider/userprovider.dart';
import 'package:wingshield_assignment/core/utils/approutes.dart';
import 'package:wingshield_assignment/core/utils/sharedpref.dart';
//creating global instance of flutter local notification for further updation and initialization
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


//creating the notification channel for inapp notification
AndroidNotificationChannel notificationChannel =
    const AndroidNotificationChannel(
        "wingshieldchannel", "wingshieldnotification",
        description: "this is wingshield notification", playSound: true);
Future<void> backgroundmessagehandler(RemoteMessage message)async{


}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //intializing the firebase
  await Firebase.initializeApp();
  //initializing the local notification
  flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,)));

          //creating the notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

//initializing the sharedpreference to use throughout the app
  SharedPref.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    //while user quit the app
    FirebaseMessaging.instance.getInitialMessage().then((value){

    });

    //while the user is active in the background and user opens it from the notification stack trace
    FirebaseMessaging.onMessageOpenedApp.listen((remotemessage) {

    });

    //onbackground message
    FirebaseMessaging.onBackgroundMessage(backgroundmessagehandler);

    //while the user in the app
    FirebaseMessaging.onMessage.listen((remotemesage) {
      RemoteNotification notification =
          remotemesage.notification ??const RemoteNotification();
          

          //showing the inapp notification
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(notificationChannel.id,
                  notificationChannel.name),iOS: const IOSNotificationDetails()));
    });

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //defining the global user provide to use it anywhere in the app set to lazy
    return MultiProvider(
      
      providers:[
        ChangeNotifierProvider(
        create: (context)=>CurrentUserProvider(UserModel())),
        ChangeNotifierProvider(create: (context)=>AppUsersProvider())
      ],
        child:const MaterialApp(
      initialRoute: "/",
          title: 'Flutter Demo',
          onGenerateRoute: AppRoute.approutes,// generating the dynamic
        ),
      );
  }
}
