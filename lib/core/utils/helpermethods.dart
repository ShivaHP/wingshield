import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wingshield_assignment/main.dart';

class HelperMethods {
  static void showsnackbar(
      {required BuildContext context,
      Duration duration = const Duration(milliseconds: 800),
      Color color = Colors.green,
      String message = ""}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: duration,
    ));
  }

  static shownotification(String title, String message) {
    flutterLocalNotificationsPlugin.show(
        message.hashCode,
        title,
        message,
        
        NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannel.id,
              notificationChannel.name,
              styleInformation: BigTextStyleInformation(message,summaryText: "Notifications",contentTitle: title)
            ),
            iOS:const IOSNotificationDetails()));
  }
}
