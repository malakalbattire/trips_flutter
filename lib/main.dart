import 'package:animation_flutter/Notification/notifications_screen.dart';
import 'package:animation_flutter/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'registration/registration_screen.dart';
import 'home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'notification/firebase_notifications.dart';
import 'login/login_screen.dart';
import 'navigation_menu.dart';
import 'saved/saved.dart';
import 'profile/profile.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseNotifications().initNotifications();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    late int _selectedIndex = 0;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Malak's Trips",
      navigatorKey: navigatorKey,
      initialRoute: WelcomeScreen.id,
      routes: {
        NavigationMenu.id: (context) => NavigationMenu(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        Home.id: (context) => Home(),
        NotificationScreen.id: (context) => NotificationScreen(),
        SavedScreen.id: (context) => SavedScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
      },
    );
  }
}
