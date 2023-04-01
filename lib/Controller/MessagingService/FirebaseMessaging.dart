import 'dart:io';
import 'package:Decon/Controller/MessagingService/random_string.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseMessagingService instance = FirebaseMessagingService._();
  AndroidNotificationChannel channel;
  bool isFlutterLocalNotificationsInitialized = false;
  FirebaseMessagingService._() {
    //initializing setting
    var android = AndroidInitializationSettings('@mipmap/launcher_icon');
    var ios = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    setUpFirebaseMessageListener();
  }



    setUpFlutterNotifications() async{
     
     if (isFlutterLocalNotificationsInitialized) {
        return;
      }
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      isFlutterLocalNotificationsInitialized = true;

    }

    setUpFirebaseMessageListener(){


      FirebaseMessaging.onMessage.listen((RemoteMessage message) { 

        print(message.notification.title);
        print(message.notification.body);

        showNotificationv1(message.notification.title, message.notification.body);
      });
      
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { 
        showNotificationv1(message.notification.title, message.notification.body);
      });


     }

  // TOP-LEVEL or STATIC function to handle background messages

  // static showFlutterNotification(String title, String body, String id) async {
  //   title = title??"";
  //   body = body??"";
  //   id = id??"101";
  //   var android = AndroidNotificationDetails(
  //       title + id,
  //       title + id,
  //       body,
  //       importance: Importance.high,
  //       priority: Priority.high,

  //       );
  //   var iOS = IOSNotificationDetails();
  //   var platform = NotificationDetails(android: android, iOS: iOS);

  //   flutterlocalnotificationplugin.show(
  //       int.parse(id), title, body, platform,
  //       payload: "FLUTTER_NOTIFICATION_CLICK");
  // }



  showNotificationv1(String title, String body) async {
    
    var android = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    new Future.delayed(Duration.zero, () {
      if(body.startsWith("https://firebasestorage.googleapis.com")){
        body = "Notice with content attached";
      }
      flutterLocalNotificationsPlugin.show(
          int.parse(randomNumeric(4)), title, body, platform);
    });
  }

  
}
