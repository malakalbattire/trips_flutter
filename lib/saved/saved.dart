import 'package:animation_flutter/trips/trip_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:animation_flutter/auth/login/login_screen.dart';

class SavedScreen extends StatelessWidget {
  static const String id = 'saved_screen';
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved'),
      ),
      body: StreamBuilder(
        stream: _tripsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(
                title: Text(document['title']),
                trailing: IconButton(
                  icon: Icon(
                    document['isFav'] ? Icons.favorite : Icons.favorite_border,
                    color: document['isFav'] ? Colors.red : null,
                  ),
                  onPressed: () {
                    _toggleFavorite(document.id, document['isFav']);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsPage(document.id),
                    ),
                  );
                },
              );
            }).toList(),
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
}
