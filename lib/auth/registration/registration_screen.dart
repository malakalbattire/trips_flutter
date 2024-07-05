import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animation_flutter/utilities/navigation_menu.dart';
import 'package:animation_flutter/utilities/constants.dart';
import 'package:animation_flutter/utilities/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegistrationScreen({super.key});
  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String fullName;
  String errorMessage = '';
  bool showSpinner = false;
  Map<String, bool> favs = {};
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
          'name': fullName,
          'email': email,
          'favs': favs,
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

  Future<void> getItems() async {
    await FirebaseFirestore.instance.collection("trips").get().then(
      (QuerySnapshot querySnapshot) {
        for (var element in querySnapshot.docs) {
          favs[element["title"].toString()] == false;
        }
      },
    );

    // await FirebaseFirestore.instance.collection("users").add({"favs": favs});
  }

  @override
  void initState() {
    getItems();
    // TODO: implement initState
    super.initState();
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
                  kSizedBox20,
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
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
