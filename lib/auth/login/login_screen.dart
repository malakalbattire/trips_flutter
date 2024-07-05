import 'package:animation_flutter/utilities/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:animation_flutter/utilities/constants.dart';
import 'package:animation_flutter/utilities/rounded_button.dart';

Map<String, bool> favs = {};

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  //

  @override
  void initState() {
    //getItemsLogin();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign In')),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
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
                    title: 'Log In ',
                    colour: Colors.lightBlueAccent,
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        print(user);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('logged in successfully '),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushNamed(context, NavigationMenu.id);
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
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

// Future<void> getItemsLogin() async {
//   await FirebaseFirestore.instance
//       .collection("users")
//       .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
//       .get()
//       .then((QuerySnapshot querySnapshot) {
//     for (var element in querySnapshot.docs) {
//       favs = Map.from(element["favs"]);
//     }
//   });
// }
