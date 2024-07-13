import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:provider/provider.dart';
import 'package:animation_flutter/providers/favorites_provider.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailsPage extends StatefulWidget {
  static const String id = 'trip_details_page';
  final String tripId;

  const TripDetailsPage(this.tripId, {super.key});

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');
  LocationData? _currentLocation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();
    LocationData locationData;

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    setState(() {
      _currentLocation = locationData;
    });
  }

  static const LatLng _currentLoc = LatLng(37.4219983, -122.084);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            return StreamBuilder<QuerySnapshot>(
              stream: _tripsCollection
                  .where(FieldPath.documentId, isEqualTo: widget.tripId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Trip not found or data is not available.',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  );
                }

                final tripData =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                bool isFav =
                    favoritesProvider.favorites[widget.tripId] ?? false;

                double? latitude = tripData['latitude'];
                double? longitude = tripData['longitude'];

                if (latitude == null || longitude == null) {
                  return const Center(
                    child: Text(
                      'Location data not available for this trip.',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  );
                }

                LatLng tripLocation = LatLng(latitude, longitude);

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
                                fit: BoxFit.cover,
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
                                  favoritesProvider
                                      .toggleFavorite(widget.tripId);
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
                          _buildDescription(tripData['description']),
                          const SizedBox(height: 20),
                          _currentLocation == null
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  height: 300,
                                  child: GoogleMap(
                                    initialCameraPosition: const CameraPosition(
                                      target: _currentLoc,
                                      zoom: 10,
                                    ),
                                    markers: {
                                      if (_currentLocation != null)
                                        Marker(
                                          markerId:
                                              const MarkerId('currentLocation'),
                                          icon: BitmapDescriptor.defaultMarker,
                                          position: LatLng(
                                            _currentLocation!.latitude!,
                                            _currentLocation!.longitude!,
                                          ),
                                        ),
                                      Marker(
                                        markerId:
                                            const MarkerId('tripLocation'),
                                        icon: BitmapDescriptor.defaultMarker,
                                        position: tripLocation,
                                      ),
                                    },
                                    polylines: _createLine(
                                      _currentLocation != null
                                          ? LatLng(
                                              _currentLocation!.latitude!,
                                              _currentLocation!.longitude!,
                                            )
                                          : _currentLoc,
                                      tripLocation,
                                    ),
                                    onMapCreated:
                                        (GoogleMapController controller) {},
                                  ),
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

  Set<Polyline> _createLine(LatLng currentLocation, LatLng tripLocation) {
    return {
      Polyline(
        polylineId: const PolylineId('line'),
        visible: true,
        points: [currentLocation, tripLocation],
        color: Colors.black,
        width: 5,
      ),
    };
  }

  Widget _buildDescription(String description) {
    final words = description.split(' ');
    final previewText = words.length > 30
        ? '${words.sublist(0, 30).join(' ')}...'
        : description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isExpanded ? description : previewText,
          style: const TextStyle(fontSize: 16),
        ),
        if (words.length > 30)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'See Less' : 'See More',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
