import 'package:flutter/material.dart';
import 'package:animation_flutter/login/login_screen.dart';
import 'package:animation_flutter/registration/registration_screen.dart';
import 'package:animation_flutter/shared/roundedButton.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 300.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                RoundedButton(
                  title: 'Log In',
                  colour: Colors.lightBlueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
                RoundedButton(
                    title: 'Register',
                    colour: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
