import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animation_flutter/Notification/notifications_screen.dart';
import 'package:animation_flutter/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'dd',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print('Device token:============= $token=======');
    initPushNotifications();
  }

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(
      NotificationScreen.id,
      arguments: message,
    );

    print('message ====== ${message.notification!.body}=====');
    await _storeNotification(
      message.notification!.title ?? 'No Title',
      message.notification!.body ?? 'No Body',
    );
  }

  Future<void> _storeNotification(String title, String body) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future initLocalNotifications() async {
    // const android = AndroidInitializationSettings('@drawable/ic_launcher');
    //const settings = InitializationSettings(android: android);
    // await _localNotifications.initialize(settings,
    //     onDidReceiveNotificationResponse: (payload) {
    //   final message = RemoteMessage.fromMap(jsonDecode(payload!));
    //   handleMessage(message);
    // });
  }

  Future initPushNotifications() async {
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessages);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification == null) return;

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  // Future<void> handleBackgroundMessages(RemoteMessage message) async {
  //   print('title: ${message.notification?.title}');
  //   print('body: ${message.notification?.body}');
  //   print('message: ${message.data}');
  // }
}
