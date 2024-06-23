import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:animation_flutter/auth/login/login_screen.dart';

Map<String, bool> fav = {};

class TripDetailsPage extends StatelessWidget {
  final String tripId;

  TripDetailsPage(this.tripId);

  @override
  Widget build(BuildContext context) {
    final CollectionReference _subcollectionRef = FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .collection('tripDetails'); // Replace with your subcollection name
    // print('trip id =======${tripId}========');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: StreamBuilder(
        stream: _subcollectionRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final details = snapshot.data!.docs;

          return ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              final detail = details[index];
              //print('detail====${detail.id}');
              return Column(
                children: [
                  IconButton(
                      onPressed: () async {
                        // print('======= pressed =========');
                        //  Future<void> update(String email, String trip) async {
                        //    await FirebaseFirestore.instance
                        //        .collection('users')
                        //        .get()
                        //        .then(
                        //      (QuerySnapshot querySnapshot) {
                        //        for (var element in querySnapshot.docs) {
                        //          fav = Map.from(element["favs"]);
                        //         // print(fav);
                        //        }
                        //      },
                        //    );
                        //    for (var element in fav.keys) {
                        //      if (element == trip) {
                        //        fav[trip] = fav[trip]! ? false : true;
                        //      }
                        //    }
                        //    await FirebaseFirestore.instance
                        //        .collection("users")
                        //        .where("email", isEqualTo: email)
                        //        .get()
                        //        .then((QuerySnapshot querySnapshot) {
                        //      for (var element in querySnapshot.docs) {
                        //        element.reference.update({"favs": fav});
                        //      }
                        //    });
                        //
                        //    await getItemsLogin();
                        //  }
                      },
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      )),
                  ListTile(
                    title: Text(
                      detail['description'],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
