import 'package:flutter/material.dart';
import 'package:animation_flutter/shared/constants.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class TripDetails extends StatefulWidget {
  static const String id = 'trip_details';
  const TripDetails({super.key});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

String? fullName;
// Future _getUserInfo() async {
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .get()
//       .then((snapshot) async {
//     if (snapshot.exists) {
//       fullName = snapshot.data()!['fullName'];
//       print('full === $fullName');
//       // setState(() {
//       //   fullName = snapshot.data()!['fullName'];
//       //   print('full === ${fullName}');
//       // });
//     } else {
//       print('else full ==$fullName');
//     }
//   });
// }

class _TripDetailsState extends State<TripDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              kSizedBox20,
              // StreamBuilder<DocumentSnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection('trips')
              //       .doc('uid')
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     List<ListTile> tripsWidgets = [];
              //     if (snapshot.hasData) {
              //       final trips = snapshot.data?.docs.reversed.toList();
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
