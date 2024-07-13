import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animation_flutter/views/profile/profile_screen.dart';
import '../views/login_screen.dart';
import 'package:animation_flutter/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  static const String id = 'authentication_wrapper';

  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          return ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider(),
            child: ProfileScreen(userId: snapshot.data!.uid),
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
