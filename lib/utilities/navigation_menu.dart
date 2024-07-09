import 'package:flutter/material.dart';
import 'package:animation_flutter/admin/admin_screen.dart';
import 'package:animation_flutter/admin/users_details.dart';
import 'package:animation_flutter/views/home/home.dart';
import 'package:animation_flutter/views/saved/saved.dart';
import 'package:get/get.dart';
import 'authentication_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationMenu extends StatelessWidget {
  static const String id = 'navigation_menu';
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
            return Home();
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
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  if (currentUserEmail == 'admin@gmail.com') {
    return true;
  } else {
    return false;
  }
}
