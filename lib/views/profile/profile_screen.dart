import 'package:animation_flutter/views/profile/edit_profile_screen.dart';
import 'package:animation_flutter/auth/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 240,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/bg.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topLeft,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 15,
                                right: 15,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          EditProfileScreen.id,
                                        );
                                      },
                                      icon: const Icon(Icons.settings),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 100,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xFFF1ECF7),
                                child: const Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (userProvider.userData != null)
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      color: const Color(0xFFF1ECF7),
                      child: Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 10),
                          Text(
                            userProvider.userData!['name'].toUpperCase(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      color: const Color(0xFFF1ECF7),
                      child: Row(
                        children: [
                          const Icon(Icons.email),
                          const SizedBox(width: 10),
                          Text(
                            '${userProvider.userData!['email']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, WelcomeScreen.id);
                    },
                    child: Row(
                      children: const [
                        Text('Sign Out'),
                        Icon(Icons.logout),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ProfileScreen extends StatelessWidget {
//   static const String id = 'profile_screen';
//   final String userId;
//
//   const ProfileScreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               alignment: Alignment.center,
//               width: double.infinity,
//               height: 240,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("images/bg.png"),
//                   fit: BoxFit.fitWidth,
//                   alignment: Alignment.topLeft,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: SizedBox(
//                           height: 50,
//                           child: Stack(
//                             children: [
//                               Positioned(
//                                 top: 15,
//                                 right: 15,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         Navigator.pushNamed(
//                                           context,
//                                           EditProfileScreen.id,
//                                         );
//                                       },
//                                       icon: const Icon(Icons.settings),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 40,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       clipBehavior: Clip.none,
//                       children: [
//                         Positioned(
//                           top: 100,
//                           child: Column(
//                             children: [
//                               CircleAvatar(
//                                 radius: 30,
//                                 backgroundColor: const Color(0xFFF1ECF7),
//                                 child: const Icon(
//                                   Icons.person,
//                                   size: 30,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(userId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//
//                 if (!snapshot.hasData || !snapshot.data!.exists) {
//                   return const Center(child: Text('User not found'));
//                 }
//
//                 var userData = snapshot.data!.data() as Map<String, dynamic>;
//
//                 return Padding(
//                   padding: const EdgeInsets.all(50.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.all(10),
//                         padding: const EdgeInsets.all(10),
//                         width: double.infinity,
//                         color: const Color(0xFFF1ECF7),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.person),
//                             const SizedBox(width: 10),
//                             Text(
//                               userData['name'].toUpperCase(),
//                               style: const TextStyle(fontSize: 20),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(10),
//                         padding: const EdgeInsets.all(10),
//                         width: double.infinity,
//                         color: const Color(0xFFF1ECF7),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.email),
//                             const SizedBox(width: 10),
//                             Text(
//                               '${userData['email']}',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       await FirebaseAuth.instance.signOut();
//                       Navigator.pushNamed(context, WelcomeScreen.id);
//                     },
//                     child: Row(
//                       children: const [
//                         Text('Sign Out'),
//                         Icon(Icons.logout),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
