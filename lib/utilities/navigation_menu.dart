import 'package:flutter/material.dart';
import 'package:animation_flutter/views/home/home.dart';
import 'package:animation_flutter/views/saved/saved.dart';
import 'package:get/get.dart';
import 'authentication_wrapper.dart';

class NavigationMenu extends StatelessWidget {
  static const String id = 'navigation_menu';
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 50.0,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.favorite), label: 'Saved'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.selectedIndex.value == 0) {
          return Home();
        } else if (controller.selectedIndex.value == 1) {
          return SavedScreen();
        } else {
          return const AuthenticationWrapper();
        }
      }),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
}

// class NavigationMenu extends StatelessWidget {
//   static const String id = 'navigation_menu';
//   const NavigationMenu({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(NavigationController());
//
//     return Scaffold(
//       bottomNavigationBar: Obx(
//         () => NavigationBar(
//           height: 50.0,
//           elevation: 0,
//           selectedIndex: controller.selectedIndex.value,
//           onDestinationSelected: (index) =>
//               controller.selectedIndex.value = index,
//           destinations: const [
//             NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
//             NavigationDestination(icon: Icon(Icons.favorite), label: 'Saved'),
//             NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
//           ],
//         ),
//       ),
//       body: Obx(() => controller.screens[controller.selectedIndex.value]),
//     );
//   }
// }
//
// class NavigationController extends GetxController {
//   final Rx<int> selectedIndex = 0.obs;
//   final screens = [
//     Home(),
//     SavedScreen(),
//     const AuthenticationWrapper(),
//   ];
// }
