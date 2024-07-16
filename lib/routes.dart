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

final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
Map<String, WidgetBuilder> getRoutes() {
  return {
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
  };
}
