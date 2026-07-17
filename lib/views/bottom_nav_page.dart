import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/navigation_controller.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/views/home/batches/batch_list_page.dart';
import 'package:icahs_hwr/views/home/home_page.dart';
import 'package:icahs_hwr/views/home/profile_page.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  final NavigationController navController = Get.put(NavigationController());

  void goToBatchListPage() {
    navController.goToBatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: navController.selectedIndex.value,
          children: [
            HomePage(navigateToBatches: goToBatchListPage),
            const BatchListPage(),
            const ProfilePage(),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: MyColorPalette.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(25, 0, 0, 0),
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Obx(() {
            return NavigationBar(
              backgroundColor: MyColorPalette.white,
              selectedIndex: navController.selectedIndex.value,
              onDestinationSelected: (value) =>
                  navController.selectedIndex.value = value,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              labelTextStyle: WidgetStatePropertyAll(
                TextStyle(
                  color: MyColorPalette.darkPurple,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              destinations: const [
                NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.home,
                    color: MyColorPalette.textGrey,
                  ),
                  selectedIcon: Icon(
                    CupertinoIcons.house_fill,
                    color: MyColorPalette.darkBlue,
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.list_bullet_below_rectangle,
                    color: MyColorPalette.textGrey,
                  ),
                  selectedIcon: Icon(
                    CupertinoIcons.list_bullet_indent,
                    color: MyColorPalette.darkBlue,
                  ),
                  label: 'Batches',
                ),
                NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.person,
                    color: MyColorPalette.textGrey,
                  ),
                  selectedIcon: Icon(
                    CupertinoIcons.person_fill,
                    color: MyColorPalette.darkBlue,
                  ),
                  label: 'Profile',
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
