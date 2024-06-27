import 'package:animation_flutter/shared/constants.dart';
import 'package:animation_flutter/trips/trip_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:animation_flutter/auth/login/login_screen.dart';
import 'package:quickalert/quickalert.dart';

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
        title: const Text('Saved'),
      ),
      body: StreamBuilder(
        stream: _tripsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Builder(
            builder: (context) {
              List<Widget> favoriteTrips = snapshot.data!.docs
                  .map((document) {
                    if (document['isFav'] == true) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: ListTile(
                          title: Row(
                            children: [
                              Hero(
                                tag: 'img ${document['title']} ',
                                child: Image.network(
                                  document['img'],
                                  height: 50.0,
                                ),
                              ),
                              // Image.network(document['img']),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    document['title'],
                                  ),
                                  Text(
                                    '\$${document['price'].toString()}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              document['isFav']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: document['isFav'] ? Colors.red : null,
                            ),
                            onPressed: () {
                              if (document['isFav'] == true) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.warning,
                                  text: 'Removed From Favorites!',
                                );
                              }
                              _toggleFavorite(document.id, document['isFav']);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TripDetailsPage(document.id),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return null;
                  })
                  .where((element) => element != null)
                  .toList()
                  .cast<Widget>();

              if (favoriteTrips.isEmpty) {
                return const Center(
                    child: Text("Let's add you favorite trips! "));
              } else {
                return ListView(children: favoriteTrips);
              }
            },
          );

          // return ListView(
          //   children: snapshot.data!.docs
          //       .map((document) {
          //         Widget? getData() {
          //           if (document['isFav'] == true) {
          //             return ListTile(
          //               title: Text(document['title']),
          //               trailing: IconButton(
          //                 icon: Icon(
          //                   document['isFav']
          //                       ? Icons.favorite
          //                       : Icons.favorite_border,
          //                   color: document['isFav'] ? Colors.red : null,
          //                 ),
          //                 onPressed: () {
          //                   _toggleFavorite(document.id, document['isFav']);
          //                 },
          //               ),
          //               onTap: () {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) =>
          //                         TripDetailsPage(document.id),
          //                   ),
          //                 );
          //               },
          //             );
          //           }
          //           return null;
          //         }
          //
          //         return getData();
          //       })
          //       .where((element) => element != null)
          //       .toList()
          //       .cast<Widget>(),
          // );
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
