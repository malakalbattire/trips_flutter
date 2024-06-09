import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  static const String id = 'saved_screen';

  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('saved'),
        ),
      ),
    );
  }
}
