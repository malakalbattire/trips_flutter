// import 'package:flutter/material.dart';
//
// class AllItems extends StatefulWidget {
//   @override
//   _AllItemsState createState() => _AllItemsState();
// }
//
// class _AllItemsState extends State<AllItems> {
//   List<String> items = [];
//   List<bool> bookmark = [];
//
//   @override
//   void initState() {
//     Map<String, bool> book = func.bookmarks;
//
//     items = book.keys.toList();
//     bookmark = book.values.toList();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("All Items"),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginPage()),
//                   (route) => false);
//             },
//             icon: Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(items[index]),
//               trailing: IconButton(
//                 onPressed: () async {
//                   await func.update(
//                       func.auth.currentUser!.email.toString(), items[index]);
//                   setState(() {
//                     bookmark[index] = !bookmark[index];
//                     print(bookmark[index]);
//                   });
//                 },
//                 icon: bookmark[index]
//                     ? Icon(Icons.bookmark)
//                     : Icon(Icons.bookmark_border_outlined),
//               ),
//             );
//           }),
//     );
//   }
// }
