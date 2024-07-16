import 'package:flutter/material.dart';
import 'package:animation_flutter/models/admin/admin_screen.dart';
import 'package:animation_flutter/models/admin/users_details.dart';
import 'package:animation_flutter/views/home_screen.dart';
import 'package:animation_flutter/views/saved_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utilities/authentication_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationMenu extends StatelessWidget {
  static const String id = 'navigation_menu';
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final controller = Get.put(NavigationController());

    bool isAdmin = ifAdmin();

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 50.0,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: isAdmin
              ? [
                  const NavigationDestination(
                      icon: Icon(Icons.flight), label: 'Trips'),
                  const NavigationDestination(
                    icon: Icon(Icons.group),
                    label: 'Users',
                  ),
                  const NavigationDestination(
                      icon: Icon(Icons.person), label: 'Profile'),
                ]
              : [
                  const NavigationDestination(
                      icon: Icon(Icons.home), label: 'Home'),
                  const NavigationDestination(
                      icon: Icon(Icons.favorite), label: 'Saved'),
                  const NavigationDestination(
                      icon: Icon(Icons.person), label: 'Profile'),
                ],
        ),
      ),
      body: Obx(() {
        if (isAdmin) {
          if (controller.selectedIndex.value == 0) {
            return AdminScreen();
          } else if (controller.selectedIndex.value == 1) {
            return UsersDetails();
          } else {
            return const AuthenticationWrapper();
          }
        } else {
          if (controller.selectedIndex.value == 0) {
            return ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider(),
              child: Home(userId: userId),
            );
          } else if (controller.selectedIndex.value == 1) {
            return SavedScreen();
          } else {
            return const AuthenticationWrapper();
          }
        }
      }),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
}

bool ifAdmin() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null && currentUser.email == 'admin@gmail.com') {
    return true;
  } else {
    return false;
  }
}
