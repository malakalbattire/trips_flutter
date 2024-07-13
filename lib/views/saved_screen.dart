import 'package:animation_flutter/widgets/saved_stream_builder.dart';
import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  static const String id = 'saved_screen';

  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
      ),
      body: const SavedStreamBuilder(),
    );
  }
}
