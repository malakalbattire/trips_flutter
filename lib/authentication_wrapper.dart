import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animation_flutter/profile/profile_screen.dart';
import 'auth/login/login_screen.dart';

class AuthenticationWrapper extends StatelessWidget {
  static const String id = 'authentication_wrapper';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          return ProfileScreen(userId: snapshot.data!.uid);
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
