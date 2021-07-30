import 'dart:io';
import 'package:Decon/Controller/MessagingService/random_string.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FlutterLocalNotificationsPlugin flutterlocalnotificationplugin =
      new FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FirebaseMessagingService() {
    //initializing setting
    var android = AndroidInitializationSettings('@mipmap/launcher_icon');
    var ios = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: android, iOS: ios);
    flutterlocalnotificationplugin.initialize(initializationSettings);
  }

  sendNotification() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        String title = "${message['notification']['title']}";
        String body = "${message['notification']['body']}";
        showNotification(title , body);
        return;
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) {
        if (Platform.isIOS) {
        String title = "${message['notification']['title']}";
        String body = "${message['notification']['body']}";
        showNotification(title , body);
        }
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        return;
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  // TOP-LEVEL or STATIC function to handle background messages
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
        String title = "${message['notification']['title']}";
        String body = "${message['notification']['body']}";
        showNotification(title , body);
    return Future<void>.value();
  }

  static showNotification(String title, String body) async {
    FlutterLocalNotificationsPlugin flutterlocalnotificationplugin =
        new FlutterLocalNotificationsPlugin();
    var androidinit = AndroidInitializationSettings('@mipmap/launcher_icon');
    var ios = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidinit, iOS: ios);
    flutterlocalnotificationplugin.initialize(initializationSettings);

    var android = AndroidNotificationDetails(
        title + randomNumeric(4).toString(),
        title + randomNumeric(4).toString(),
        body);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    new Future.delayed(Duration.zero, () {
      if(body.startsWith("https://firebasestorage.googleapis.com")){
        body = "Notice with content attached";
      }
      flutterlocalnotificationplugin.show(
          int.parse(randomNumeric(4)), title, body, platform);
    });
  }

  
}
