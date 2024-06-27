import 'package:animation_flutter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';

class TripDetailsPage extends StatelessWidget {
  final String tripId;
  TripDetailsPage(this.tripId, {super.key});
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _tripsCollection
              .where(FieldPath.documentId, isEqualTo: tripId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final tripData =
                snapshot.data!.docs.first.data() as Map<String, dynamic>;
            bool isFav = tripData['isFav'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        child: Hero(
                          tag: 'img ${tripData['title']} ',
                          child: Image.network(
                            tripData['img'],
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                kSizedBox30,
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tripData['title'].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : null,
                            ),
                            onPressed: () {
                              _toggleFavorite(tripId, isFav);
                              if (isFav == false) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  text: 'Added To Favorites Successfully!',
                                );
                              } else {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.warning,
                                  text: 'Removed From Favorites!',
                                );
                              }
                              //print('is fav======${isFav}');
                            },
                          ),
                        ],
                      ),
                      kSizedBox20,
                      Text(
                        tripData['description'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggleFavorite(String tripId, bool isCurrentlyFav) async {
    final userDoc = await _usersCollection.doc(user?.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    Map<String, dynamic> favs = userData['favs'] ?? {};

    if (isCurrentlyFav) {
      // Remove from favorites
      favs.remove(tripId);
      await _tripsCollection.doc(tripId).update({
        'isFav': false,
      });
    } else {
      // Add to favorites
      favs[tripId] = true;
      await _tripsCollection.doc(tripId).update({
        'isFav': true,
      });
    }

    await _usersCollection.doc(user?.uid).update({
      'favs': favs,
    });
  }
}
