import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetItems extends StatefulWidget {
  const GetItems({super.key});

  @override
  State<GetItems> createState() => _GetItemsState();
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

Map<String, bool> fav = {};

Future<void> getitmeslogin() async {
  await firestore
      .collection("users")
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var element in querySnapshot.docs) {
      fav = Map.from(element["fav"]);
      print(fav);
    }
  });
}

Future<void> getitems() async {
  await firestore.collection("trips").get().then((QuerySnapshot querySnapshot) {
    for (var element in querySnapshot.docs) {
      fav[element["title"].toString()] = false;
    }
  });

  await firestore
      .collection("users")
      .add({"email": FirebaseAuth.instance.currentUser!.email, "fav": fav});
}

class _GetItemsState extends State<GetItems> {
  @override
  void initState() {
    getitmeslogin();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
