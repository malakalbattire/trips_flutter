import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('profile '),
        ),
      ),
    );
  }
}
