import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  static const String id = 'saved_screen';

  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //appBar: AppBar(),
      body: Center(
        child: Text('saved'),
      ),
    );
  }
}
