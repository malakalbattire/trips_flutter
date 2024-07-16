import 'package:animation_flutter/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animation_flutter/widgets/navigation_menu.dart';
import 'package:animation_flutter/views/welcome_screen.dart';
import 'package:animation_flutter/views/login_screen.dart';
import 'package:animation_flutter/views/registration_screen.dart';
import 'package:animation_flutter/views/home_screen.dart';
import 'package:animation_flutter/views/notifications_screen.dart';
import 'package:animation_flutter/views/saved_screen.dart';
import 'package:animation_flutter/utilities/authentication_wrapper.dart';
import 'package:animation_flutter/views/profile/edit_profile_screen.dart';
import 'package:animation_flutter/models/admin/admin_screen.dart';
import 'package:animation_flutter/models/trips/add_trips_screen.dart';
import 'package:animation_flutter/models/admin/users_details.dart';
import 'package:provider/provider.dart';

final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
Map<String, WidgetBuilder> getRoutes() {
  return {
    NavigationMenu.id: (context) => NavigationMenu(),
    WelcomeScreen.id: (context) => const WelcomeScreen(),
    LoginScreen.id: (context) => LoginScreen(),
    RegistrationScreen.id: (context) => RegistrationScreen(),
    Home.id: (context) => ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
          child: Home(userId: userId),
        ),
    NotificationScreen.id: (context) => NotificationScreen(),
    SavedScreen.id: (context) => SavedScreen(),
    AuthenticationWrapper.id: (context) => AuthenticationWrapper(),
    EditProfileScreen.id: (context) => EditProfileScreen(),
    AdminScreen.id: (context) => AdminScreen(),
    AddTripsScreen.id: (context) => AddTripsScreen(),
    UsersDetails.id: (context) => UsersDetails(),
  };
}
