import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripsPage extends StatefulWidget {
  static const String id = 'trips_page';
  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final CollectionReference _tripsRef =
      FirebaseFirestore.instance.collection('trips');

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
