import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animation_flutter/navigation_menu.dart';
import 'package:animation_flutter/shared/constants.dart';
import 'package:animation_flutter/shared/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'register_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String fullName;
  String errorMessage = '';
  bool showSpinner = false;

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userInfo =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userInfo.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': fullName, // Or retrieve from input
          'email': email,
        });
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            // await signIn(email, password);
            break;
          case 'invalid-email':
            setState(() {
              errorMessage = 'Invalid email address.';
            });
            break;
          case 'weak-password':
            setState(() {
              errorMessage = 'Password is too weak.';
            });
            break;
          default:
            setState(() {
              errorMessage = 'Sign-up failed. Please try again.';
            });
            break;
        }
      } else {
        setState(() {
          errorMessage = 'Sign-up failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset(
                        'images/logo.png',
                      ),
                    ),
                  ),
                  kSizedBox20,
                  TextField(
                    onChanged: (value) {
                      fullName = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter Your Full Name'),
                  ),
                  kSizedBox20,
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter Your Email.'),
                  ),
                  kSizedBox20,
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password.',
                    ),
                  ),
                  kSizedBox30,
                  RoundedButton(
                    title: 'Register',
                    colour: Colors.lightBlueAccent,
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      signUp(emailController.text, passwordController.text);
                      try {
                        // final user = await _auth.signInWithEmailAndPassword(
                        //     email: emailController.text,
                        //     password: passwordController.text);
                        // print(user);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('registered successfully! '),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushNamed(context, NavigationMenu.id);
                        setState(() {
                          //print(fullName);
                          showSpinner = false;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:animation_flutter/shared/constants.dart';
// import 'package:animation_flutter/navigation_menu.dart';
// import 'package:animation_flutter/shared/rounded_button.dart';
// //import 'package:firebase_auth/firebase_auth.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class RegistrationScreen extends StatefulWidget {
//   static const String id = 'register_screen';
//
//   const RegistrationScreen({super.key});
//
//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }
//
// class _RegistrationScreenState extends State<RegistrationScreen> {
//   late String email;
//   late String password;
//   late String fullName;
//   final auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   bool showSpinner = false;
//
//   // createUser() async {
//   //   print('object');
//   //   await FirebaseFirestore.instance
//   //       .collection('users')
//   //       .doc(currentUser!.uid)
//   //       .get();
//   //   print(currentUser!.uid);
//   // }
//
//   @override
//   void initState() {
//     //createUser();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: showSpinner,
//       child: Scaffold(
//         appBar: AppBar(),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 30.0, top: 0.0, right: 30.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Hero(
//                     tag: 'logo',
//                     child: SizedBox(
//                       height: 200.0,
//                       child: Image.asset(
//                         'images/logo.png',
//                       ),
//                     ),
//                   ),
//                   kSizedBox20,
//                   TextField(
//                     onChanged: (value) {
//                       fullName = value;
//                     },
//                     decoration: kTextFieldDecoration.copyWith(
//                         hintText: 'Enter Your Full Name'),
//                   ),
//                   kSizedBox20,
//                   TextField(
//                     keyboardType: TextInputType.emailAddress,
//                     onChanged: (value) {
//                       email = value;
//                     },
//                     decoration: kTextFieldDecoration.copyWith(
//                         hintText: 'Enter Your Email.'),
//                   ),
//                   kSizedBox20,
//                   TextField(
//                     obscureText: true,
//                     onChanged: (value) {
//                       password = value;
//                     },
//                     decoration: kTextFieldDecoration.copyWith(
//                       hintText: 'Enter your password.',
//                     ),
//                   ),
//                   kSizedBox30,
//                   RoundedButton(
//                     title: 'Register',
//                     colour: Colors.lightBlueAccent,
//                     onPressed: () async {
//                       // print(displayName);
//
//                       _firestore.collection('users').add({
//                         'fullName': fullName,
//                         'gmail': email,
//                       });
//                       setState(() {
//                         //print(fullName);
//                         showSpinner = true;
//                       });
//                       try {
//                         // print('last ${lastName}');
//                         // final newUser =
//                         //     await _auth.createUserWithEmailAndPassword(
//                         //         email: email, password: password);
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('registered successfully! '),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                         Navigator.pushNamed(context, NavigationMenu.id);
//                         setState(() {
//                           //print(fullName);
//                           showSpinner = false;
//                         });
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(e.toString()),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                       setState(() {
//                         showSpinner = false;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
