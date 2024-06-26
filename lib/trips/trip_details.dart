import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TripDetailsPage extends StatelessWidget {
  final String tripId;
  TripDetailsPage(this.tripId);
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _tripsCollection
            .where(FieldPath.documentId, isEqualTo: tripId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tripData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          bool isFav = tripData['isFav'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tripData['description'],
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                  _toggleFavorite(tripId, isFav);
                },
              ),
            ],
          );
        },
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
  // void _toggleFavorite(String tripId, bool isCurrentlyFav) async {
  //   final userDoc = await _usersCollection.doc(user?.uid).get();
  //   final userData = userDoc.data() as Map<String, dynamic>;
  //   Map<String, dynamic> favs = userData['favs'] ?? {};
  //
  //   if (isCurrentlyFav) {
  //     // Remove from favorites
  //     favs.remove(tripId);
  //     await _tripsCollection
  //         .doc(tripId)
  //         .collection('tripDetails')
  //         .doc('info')
  //         .update({
  //       'isFav': false,
  //     });
  //   } else {
  //     // Add to favorites
  //     favs[tripId] = true;
  //     await _tripsCollection
  //         .doc(tripId)
  //         .collection('tripDetails')
  //         .doc('info')
  //         .update({
  //       'isFav': true,
  //     });
  //   }
  //
  //   await _usersCollection.doc(user?.uid).update({
  //     'favs': favs,
  //   });
  // }
}
