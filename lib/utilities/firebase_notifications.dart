import 'dart:convert';
import 'package:animation_flutter/models/trips/trip_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:animation_flutter/views/notifications_screen.dart';
import 'package:animation_flutter/main.dart';

class FirebaseNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('Device token: $token');
    }
    initPushNotifications();
    initFirestoreListeners();
  }

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;
    final notification = message.notification;
    if (notification == null) return;

    if (navigatorKey.currentState?.mounted ?? false) {
      navigatorKey.currentState?.pushNamed(
        TripDetailsPage.id,
        arguments: message,
      );
    }

    await _storeNotification(
      notification.title ?? 'No Title',
      notification.body ?? 'No Body',
    );
  }

  Future<void> _storeNotification(String title, String body) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
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
        payload: jsonEncode(message.data),
      );
      _showForegroundNotificationDialog(notification);
    });
  }

  Future<void> _showForegroundNotificationDialog(
      RemoteNotification notification) async {
    if (navigatorKey.currentContext != null) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: Text(notification.title ?? 'No Title'),
          content: Text(notification.body ?? 'No Body'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Dismiss'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  context,
                  NotificationScreen.id,
                );
              },
              child: const Text('View'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> initFirestoreListeners() async {
    FirebaseFirestore.instance
        .collection('trips')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          _showLocalNotification(
            change.doc,
            "Let's Discover New Trip",
            "Let's Discover New Trip!",
          );
        } else if (change.type == DocumentChangeType.modified) {
          _showLocalNotification(
            change.doc,
            'There is an Update',
            'There is an Update!',
          );
        }
      }
    });
  }

  void _showLocalNotification(
      DocumentSnapshot doc, String title, String body) async {
    final data = doc.data() as Map<String, dynamic>;
    final title = data.containsKey('title') ? data['title'] : 'Unknown title';

    await _storeNotificationToFirestore(body, ' $title...', doc.id);

    _localNotifications.show(
      doc.hashCode,
      body,
      " Let's see $title Trip.",
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher',
        ),
      ),
      payload: jsonEncode({'tripId': doc.id}),
    );
  }

  Future<void> _storeNotificationToFirestore(
      String title, String body, String tripId) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'body': body,
      'tripId': tripId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
