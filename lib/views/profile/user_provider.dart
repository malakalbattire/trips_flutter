import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? userData;

  UserProvider() {
    _loadCurrentUser();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _loadCurrentUser();
      } else {
        userData = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      userData = userDoc.data();
      notifyListeners();
    }
  }
}
