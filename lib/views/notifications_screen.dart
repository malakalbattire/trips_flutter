import 'package:animation_flutter/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animation_flutter/models/trips/trip_details.dart'; // Import the TripDetailsPage

class NotificationScreen extends StatefulWidget {
  static const String id = 'notification_screen';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'There are no notifications',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              final notis = snapshot.data!.docs.reversed.toList();
              List<InkWell> notisWidgets = [];
              for (var noti in notis) {
                final notiWidget = InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripDetailsPage(noti['tripId']),
                      ),
                    );
                  },
                  child: Card(
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
                    ),
                  ),
                );
                notisWidgets.add(notiWidget);
              }

              return ListView(
                children: notisWidgets,
              );
            },
          ),
        ),
      ),
    );
  }
}
