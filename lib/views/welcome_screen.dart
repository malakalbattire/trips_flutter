import 'package:flutter/material.dart';
import 'package:animation_flutter/views/login_screen.dart';
import 'package:animation_flutter/views/registration_screen.dart';
import 'package:animation_flutter/widgets/rounded_button.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
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
      ),
    );
  }
}
