import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedScreen extends StatelessWidget {
  static const String id = 'saved_screen';
  final String userId;
  SavedScreen({required this.userId});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getMapField() async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? mapField =
            documentSnapshot.get('favs') as Map<String, dynamic>?;

        return mapField;
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching document: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Trips'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: getMapField(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Map field is null');
            } else {
              Map<String, dynamic> mapField = snapshot.data!;
              print(mapField);
              return ListView.builder(
                itemCount: mapField.length,
                itemBuilder: (context, index) {
                  String key = mapField.keys.elementAt(index);
                  dynamic value = mapField[key];
                  if (value == true) {
                    print(key);
                    return ListTile(
                      title: Text('$key'),
                    );
                  }

                  //  print(key);
                  return Text('data');
                },
              );
            }
          },
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// //import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// final userRef = FirebaseFirestore.instance.collection('users');
//
// class SavedScreen extends StatefulWidget {
//   static const String id = 'saved_screen';
//   const SavedScreen({super.key});
//
//   @override
//   State<SavedScreen> createState() => _SavedScreenState();
// }
//
// class _SavedScreenState extends State<SavedScreen> {
//   getFavTrips() async {
//     final QuerySnapshot snapshot =
//         await userRef.where('favs', isEqualTo: false).get();
//     print(snapshot.docs);
//     snapshot.docs.forEach((DocumentSnapshot doc) {
//       print(doc.data());
//     });
//   }
//
//   @override
//   void initState() {
//     print('object');
//     getFavTrips();
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [
//             Text('saved'),
//             // FutureBuilder(future: Fires, builder: builder)
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SavedScreen extends StatelessWidget {
//   static const String id = 'saved_screen';
//
//   const SavedScreen({super.key});
//   getFavTrips() async {
//     final QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       //appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [
//             Text('saved'),
//             // FutureBuilder(future: Fires, builder: builder)
//           ],
//         ),
//       ),
//     );
//   }
// }
