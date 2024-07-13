import 'package:animation_flutter/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animation_flutter/models/trips/trip_details.dart';

class UserDetailsScreen extends StatelessWidget {
  final String uid;

  const UserDetailsScreen({super.key, required this.uid});

  Future<DocumentSnapshot> getUserData() async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found!'));
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          List<String> favs = [];
          if (data['favs'] != null && data['favs'] is Map) {
            favs = (data['favs'] as Map<String, dynamic>).keys.toList();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${data['name']}',
                    style: const TextStyle(fontSize: 24)),
                kSizedBox10,
                Text('Email: ${data['email']}',
                    style: const TextStyle(fontSize: 18)),
                kSizedBox10,
                if (favs.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Favorite trips:',
                          style: TextStyle(fontSize: 18)),
                      for (var fav in favs)
                        GestureDetector(
                          onTap: () {
                            if (kDebugMode) {
                              print(fav);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripDetailsPage(fav),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('trips')
                                  .doc(fav)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot>
                                      tripSnapshot) {
                                if (tripSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (!tripSnapshot.hasData ||
                                    !tripSnapshot.data!.exists) {
                                  return const Text(' not exist');
                                }

                                var tripData = tripSnapshot.data!.data()
                                    as Map<String, dynamic>;

                                if (!tripData.containsKey('title')) {
                                  return const Text('title field is missing ');
                                }

                                var title = tripData['title'];

                                return Text(title);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
