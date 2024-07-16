import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesProvider with ChangeNotifier {
  final CollectionReference _tripsCollection =
      FirebaseFirestore.instance.collection('trips');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  User? user = FirebaseAuth.instance.currentUser;

  Map<String, bool> _favorites = {};

  Map<String, bool> get favorites => _favorites;

  FavoritesProvider() {
    _fetchFavorites();
    FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
      user = newUser;
      _fetchFavorites();
    });
  }

  void _fetchFavorites() async {
    if (user == null) return;

    final userDoc = await _usersCollection.doc(user!.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>?;

    if (userData != null && userData.containsKey('favs')) {
      _favorites = Map<String, bool>.from(userData['favs']);
    } else {
      _favorites = {};
    }

    notifyListeners();
  }

  void toggleFavorite(String tripId) async {
    if (user == null) return;

    if (_favorites.containsKey(tripId) && _favorites[tripId]!) {
      _favorites.remove(tripId);
      await _tripsCollection.doc(tripId).update({'isFav': false});
    } else {
      _favorites[tripId] = true;
      await _tripsCollection.doc(tripId).update({'isFav': true});
    }

    await _usersCollection.doc(user!.uid).update({'favs': _favorites});
    notifyListeners();
  }
}
