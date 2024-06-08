import 'package:animation_flutter/Notification/notifications_screen.dart';
import 'package:animation_flutter/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'registration/registration_screen.dart';
import 'home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'notification/firebase_notifications.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseNotifications().initNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Malak's Trips",
      navigatorKey: navigatorKey,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        Home.id: (context) => Home(),
        NotificationScreen.id: (context) => NotificationScreen(),
      },
    );
  }
}
