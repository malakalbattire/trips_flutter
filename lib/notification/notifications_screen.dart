import 'package:animation_flutter/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .snapshots(),
              builder: (context, snapshot) {
                List<Card> notisWidgets = [];
                if (snapshot.hasData) {
                  final notis = snapshot.data?.docs.reversed.toList();
                  for (var noti in notis!) {
                    final notiWidget = Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            noti['title'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          kSizedBox20,
                          Text(
                            noti['body'],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ));
                    notisWidgets.add(notiWidget);
                  }
                }

                return ListView(
                  children: notisWidgets,
                );
              },
            )),
      ),
    );
  }
}
