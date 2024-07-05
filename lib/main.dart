import 'package:animation_flutter/auth/welcome/welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/login/login_screen.dart';
import 'auth/registration/registration_screen.dart';
import 'views/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utilities/navigation_menu.dart';
import 'views/saved/saved.dart';
import 'package:animation_flutter/notification/notifications_screen.dart';
import 'package:animation_flutter/utilities/authentication_wrapper.dart';
import 'views/profile/edit_profile_screen.dart';
import 'views/saved/favorites_provider.dart';
import 'views/profile/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final uId = FirebaseAuth.instance.currentUser!.uid;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY",
        appId: 'YOUR_APP_ID',
        messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
        projectId: 'YOUR_PROJECT_ID',
        storageBucket: "YOUR_STORAGE_BUCKET",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // Add UserProvider here
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
      },
    );
  }
}
