import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? userData;
  User? _user;
  bool _isDisposed = false;
  StreamSubscription<User?>? _authStateChangesSubscription;

  UserProvider() {
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (_isDisposed) return; // Check if provider is disposed
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
      if (_isDisposed) return; // Check if provider is disposed
      userData = userDoc.data();
      notifyListeners();
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    if (_isDisposed) return; // Check if provider is disposed
    _user = null;
    userData = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }
}
