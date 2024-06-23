import 'package:flutter/material.dart';
import 'package:animation_flutter/fav/get_items.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
class Fav extends StatefulWidget {
  static const String id = 'fav';

  const Fav({super.key});

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetItems(),
    );
  }
}
