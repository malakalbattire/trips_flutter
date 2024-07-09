import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? userData;
  User? _user;

  UserProvider() {
    _loadCurrentUser();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _loadCurrentUser();
      } else {
        _user = null;
        userData = null;
        notifyListeners();
      }
    });
  }

  User? get user => _user;

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _user = user;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      userData = userDoc.data();
      notifyListeners();
    }
  }

  void signOut() {
    _user = null;
    userData = null;
    notifyListeners();
  }
}
