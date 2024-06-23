import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animation_flutter/auth/login/login_screen.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:animation_flutter/fav/fav.dart';
Map<String, bool> fav = {};

class TripsPage extends StatefulWidget {
  static const String id = 'trips_page';
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final CollectionReference _tripsRef =
      FirebaseFirestore.instance.collection('trips');

  // Future<void> update(String email, String item) async {
  //   Map<String, bool> bookmark = {};
  //
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("email", isEqualTo: email)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var element in querySnapshot.docs) {
  //       bookmark = Map.from(element["bookmarks"]);
  //       print(bookmark);
  //     }
  //   });
  //
  //   for (var element in bookmark.keys) {
  //     if (element == item) {
  //       bookmark[item] = bookmark[item]! ? false : true;
  //     }
  //   }
  //
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("email", isEqualTo: email)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var element in querySnapshot.docs) {
  //       element.reference.update({"fav": bookmark});
  //     }
  //   });
  //
  //  // await getitmeslogin();
  // }

  // Future<void> getitmeslogin() async {
  //   Map<String, bool> bookmarks = {};
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var element in querySnapshot.docs) {
  //       bookmarks = Map.from(element["fav"]);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _tripsRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final trips = snapshot.data!.docs;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];

              return ListTile(
                trailing: Text('\$${trip['price']}'),
                //title: Text(trip['title']),
                contentPadding: const EdgeInsets.all(25),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsPage(trip.id),
                    ),
                  );
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${trip['nights']} nights'.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[300]),
                    ),
                    Text(trip['title'].toString(),
                        style:
                            TextStyle(fontSize: 20, color: Colors.grey[600])),
                  ],
                ),

                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Hero(
                    tag: 'location-img',
                    child: Image.network(
                      trip['img'],
                      height: 50.0,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

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
        title: Text('Trip Details'),
      ),
      body: StreamBuilder(
        stream: _subcollectionRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
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
                        print('======= pressed =========');
                        Future<void> update(String email, String trip) async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .get()
                              .then(
                            (QuerySnapshot querySnapshot) {
                              for (var element in querySnapshot.docs) {
                                fav = Map.from(element["favs"]);
                                print(fav);
                              }
                              ;
                            },
                          );
                          for (var element in fav.keys) {
                            if (element == trip) {
                              fav[trip] = fav[trip]! ? false : true;
                            }
                          }
                          await FirebaseFirestore.instance
                              .collection("users")
                              .where("email", isEqualTo: email)
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            for (var element in querySnapshot.docs) {
                              element.reference.update({"favs": fav});
                            }
                          });

                          await getItemsLogin();
                        }

                        print(update.toString());
                      },
                      icon: Icon(
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
