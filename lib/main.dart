import 'package:animation_flutter/auth/welcome/welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth/login/login_screen.dart';
import 'auth/registration/registration_screen.dart';
import 'views/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'notification/firebase_notifications.dart';
import 'navigation_menu.dart';
import 'views/saved/saved.dart';
import 'package:animation_flutter/notification/notifications_screen.dart';
import 'package:animation_flutter/authentication_wrapper.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'views/profile/edit_profile_screen.dart';

final uId = FirebaseAuth.instance.currentUser!.uid;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyAnGg5J15m8Rp5OJa5N7GrHPNZSjdQIdec",
      appId: '1:219285846961:web:af750662b58f2c9f38db90',
      messagingSenderId: "219285846961",
      projectId: 'trips-flutter-fef44',
      storageBucket: "trips-flutter-fef44.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
    await FirebaseNotifications().initNotifications();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Malak's Trips",
      navigatorKey: navigatorKey,
      initialRoute: WelcomeScreen.id,
      routes: {
        NavigationMenu.id: (context) => const NavigationMenu(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        Home.id: (context) => const Home(),
        NotificationScreen.id: (context) => const NotificationScreen(),
        SavedScreen.id: (context) => SavedScreen(),
        //Fav.id: (context) => Fav(),
        AuthenticationWrapper.id: (context) => const AuthenticationWrapper(),
        EditProfileScreen.id: (context) => const EditProfileScreen(),
      },
    );
  }
}
