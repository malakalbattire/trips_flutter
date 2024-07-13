import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import 'package:animation_flutter/models/trips/trip_details.dart';

class SavedStreamBuilder extends StatefulWidget {
  const SavedStreamBuilder({super.key});

  @override
  State<SavedStreamBuilder> createState() => _SavedStreamBuilderState();
}

class _SavedStreamBuilderState extends State<SavedStreamBuilder> {
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        return StreamBuilder(
          stream: _tripsCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            List<Widget> favoriteTrips = snapshot.data!.docs
                .where((document) =>
                    favoritesProvider.favorites[document.id] == true)
                .map((document) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: ListTile(
                  title: Row(
                    children: [
                      Hero(
                        tag: 'img ${document['title']}',
                        child: Image.network(
                          document['img'],
                          height: 50.0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(document['title']),
                          Text('\$${document['price'].toString()}'),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      favoritesProvider.favorites[document.id]!
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoritesProvider.favorites[document.id]!
                          ? Colors.red
                          : null,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(document.id);
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
                ),
              );
            }).toList();

            if (favoriteTrips.isEmpty) {
              return const Center(
                child: Text("Let's add your favorite trips!"),
              );
            } else {
              return ListView(children: favoriteTrips);
            }
          },
        );
      },
    );
  }
}
