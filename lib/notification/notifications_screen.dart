import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static const String id = 'notification_screen';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Map payload = {};
  @override
  Widget build(BuildContext context) {
    // final data = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    //  print(data.toString());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('data')
            // Text(message.notification!.title.toString()),
            // Text('body: ${message.notification!.body.toString()}'),
            // Text('${message.data}'),
          ],
        ),
      ),
    );
  }
}
