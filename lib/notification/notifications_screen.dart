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
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 150.0,
            padding: const EdgeInsets.all(15.0),
            color: Colors.grey.shade200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  message.notification!.title.toString(),
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  message.notification!.body.toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                // Text('${message.data}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
