import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/trips/trip_details.dart';

class ColumnStreamBuilder extends StatefulWidget {
  const ColumnStreamBuilder({super.key});

  @override
  State<ColumnStreamBuilder> createState() => _ColumnStreamBuilderState();
}

class _ColumnStreamBuilderState extends State<ColumnStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('trips').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final trips = snapshot.data?.docs.reversed.toList();
        List<Widget> tripsWidgets = [];
        for (var trip in trips!) {
          final tripWidget = Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              trailing: Text('\$${trip['price']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDetailsPage(trip.id),
                  ),
                );
              },
              contentPadding: const EdgeInsets.all(10),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${trip['nights']} nights',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[300],
                    ),
                  ),
                  Text(
                    trip['title'].toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Hero(
                  tag: 'img ${trip['title']}',
                  child: Image.network(
                    trip['img'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
          tripsWidgets.add(tripWidget);
        }

        return Column(
          children: tripsWidgets,
        );
      },
    );
  }
}
