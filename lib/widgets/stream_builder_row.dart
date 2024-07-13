import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/trips/trip_details.dart';

class StreamBuilderRow extends StatefulWidget {
  const StreamBuilderRow({super.key});

  @override
  StreamBuilderRowState createState() => StreamBuilderRowState();
}

class StreamBuilderRowState extends State<StreamBuilderRow> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('trips').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final trips = snapshot.data?.docs.reversed.toList();
            List<Widget> tripsWidgets = trips!.map((trip) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsPage(trip.id),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 220,
                          margin: const EdgeInsets.all(10),
                          child: Image.network(
                            trip['img'],
                            height: 220.0,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Positioned(
                        //     top: 20,
                        //     right: 15,
                        //     width: 40,
                        //     height: 40,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: const Color.fromARGB(150, 255, 255, 255),
                        //         borderRadius: BorderRadius.circular(50),
                        //       ),
                        //       child: IconButton(
                        //         icon: const Icon(Icons.favorite_border),
                        //         onPressed: () {},
                        //       ),
                        //     )),
                        Positioned(
                          bottom: 25,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(150, 255, 255, 255),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip['title'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    Text(
                                      '${trip['nights'].toString()} nights',
                                    ),
                                  ],
                                ),
                                Text('\$${trip['price'].toString()}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList();

            return Row(
              children: tripsWidgets,
            );
          },
        ),
      ),
    );
  }
}
