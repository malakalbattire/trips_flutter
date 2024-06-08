import 'package:animation_flutter/Notification/notifications_screen.dart';
import 'package:animation_flutter/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print('Device token: $token');
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(
      NotificationScreen.id,
      arguments: message,
    );
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
  }

  // Future<void> handleBackgroundMessages(RemoteMessage message) async {
  //   print('title: ${message.notification?.title}');
  //   print('body: ${message.notification?.body}');
  //   print('message: ${message.data}');
  // }
}
