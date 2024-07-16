import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  FirebaseNotifications() {
    initializeLocalNotifications();
  }

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(initializationSettings);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    initFirestoreListeners();
  }

  Future<void> initFirestoreListeners() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> addedTripIds = prefs.getStringList('addedTripIds') ?? [];

    FirebaseFirestore.instance
        .collection('trips')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added &&
            !addedTripIds.contains(change.doc.id)) {
          addedTripIds.add(change.doc.id);
          prefs.setStringList('addedTripIds', addedTripIds);
          _showLocalNotification(
            change.doc,
            'New Trip Added',
            'A new trip has been added! Check it out.',
          );
        } else if (change.type == DocumentChangeType.modified &&
            addedTripIds.contains(change.doc.id)) {
          _showLocalNotification(
            change.doc,
            'Trip Updated',
            'An existing trip has been updated. See what\'s new!',
          );
        }
      }
    });
  }

  void _showLocalNotification(
      DocumentSnapshot doc, String title, String body) async {
    final data = doc.data() as Map<String, dynamic>;
    final tripTitle = data['title'] ?? 'Unknown title';

    await _storeNotificationToFirestore(title, body, doc.id);

    _localNotifications.show(
      doc.hashCode,
      title,
      "$body Trip: $tripTitle",
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
