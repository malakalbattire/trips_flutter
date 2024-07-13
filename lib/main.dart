import 'package:animation_flutter/models/admin/users_details.dart';
import 'package:animation_flutter/views/welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'views/registration_screen.dart';
import 'views/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widgets/navigation_menu.dart';
import 'views/saved_screen.dart';
import 'package:animation_flutter/views/notifications_screen.dart';
import 'package:animation_flutter/utilities/authentication_wrapper.dart';
import 'views/profile/edit_profile_screen.dart';
import 'providers/favorites_provider.dart';
import 'providers/user_provider.dart';
import 'models/admin/admin_screen.dart';
import 'models/trips/add_trips_screen.dart';
import 'views/login_screen.dart';
import 'package:animation_flutter/utilities/firebase_notifications.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  debugPaintSizeEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAnGg5J15m8Rp5OJa5N7GrHPNZSjdQIdec",
        appId: '1:219285846961:web:af750662b58f2c9f38db90',
        messagingSenderId: "219285846961",
        projectId: 'trips-flutter-fef44',
        storageBucket: "trips-flutter-fef44.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  FirebaseNotifications firebaseNotifications = FirebaseNotifications();
  await firebaseNotifications.initNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
        AuthenticationWrapper.id: (context) => const AuthenticationWrapper(),
        EditProfileScreen.id: (context) => const EditProfileScreen(),
        AdminScreen.id: (context) => AdminScreen(),
        AddTripsScreen.id: (context) => const AddTripsScreen(),
        UsersDetails.id: (context) => UsersDetails(),
      },
    );
  }
}
