import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:provider/provider.dart';
import 'package:animation_flutter/views/saved/favorites_provider.dart';

class TripDetailsPage extends StatelessWidget {
  final String tripId;
  TripDetailsPage(this.tripId, {super.key});
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            return StreamBuilder<QuerySnapshot>(
              stream: _tripsCollection
                  .where(FieldPath.documentId, isEqualTo: tripId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tripData =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                bool isFav = favoritesProvider.favorites[tripId] ?? false;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: Hero(
                              tag: 'img ${tripData['title']}',
                              child: Image.network(
                                tripData['img'],
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
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
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav ? Colors.red : null,
                                ),
                                onPressed: () {
                                  favoritesProvider.toggleFavorite(tripId);
                                  if (isFav) {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      text: 'Removed From Favorites!',
                                    );
                                  } else {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      text: 'Added To Favorites Successfully!',
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
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
            );
          },
        ),
      ),
    );
  }
}
