import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class NotificationScreen extends StatefulWidget {
  static const String id = 'notification_screen';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
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
                const Text('there is no notifications!'),

                // Text(
                //   message.notification!.title.toString(),
                //   style: const TextStyle(
                //     fontSize: 30.0,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                // Text(
                //   message.notification!.body.toString(),
                //   style: const TextStyle(
                //     fontSize: 20.0,
                //   ),
                // ),
                // Text('${message.data}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
