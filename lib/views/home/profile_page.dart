import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/controllers/navigation_controller.dart';
import 'package:icahs_hwr/core/helper.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/widgets/my_input_label.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _auth = Get.find<AuthController>();
  final NavigationController _nav = Get.find<NavigationController>();

  void _handleLogout() async {
    final logout = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          "Logout?",
          style: TextStyle(
            color: MyColorPalette.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text("Are you sure you want to logout?"),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              "Go back",
              style: TextStyle(color: MyColorPalette.black),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              showSnackBar(
                "Success",
                "You have been logged out successfuly.",
                color: MyColorPalette.success,
              );

              if (!context.mounted) return;
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColorPalette.red,
            ),
            child: Text("Yes", style: TextStyle(color: MyColorPalette.white)),
          ),
        ],
      ),
    );

    if (logout == true) {
      _auth.logout();
      _nav.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.heightOf(context) / 3),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [
                Color.fromARGB(255, 83, 63, 255),
                Color.fromARGB(255, 96, 78, 255),
                Color.fromARGB(255, 126, 112, 255),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Positioned(
                bottom: -200,
                right: -200,
                child: IgnorePointer(
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        radius: 0.7,
                        colors: [
                          Color.fromARGB(80, 228, 84, 173),
                          Color.fromARGB(40, 228, 84, 173),
                          Color.fromARGB(15, 228, 84, 173),
                          Color.fromARGB(3, 228, 84, 173),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.4, 0.6, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -125,
                left: -125,
                child: IgnorePointer(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        radius: 0.7,
                        colors: [
                          Color.fromARGB(80, 228, 84, 173),
                          Color.fromARGB(40, 228, 84, 173),
                          Color.fromARGB(15, 228, 84, 173),
                          Color.fromARGB(3, 228, 84, 173),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.4, 0.6, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              Column(
                mainAxisSize: .max,
                mainAxisAlignment: .center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MyColorPalette.white,
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage('assets/icons/profile.png'),
                    ),
                  ),
                  Text(
                    _auth.user!.role,
                    style: TextStyle(fontSize: 26, color: MyColorPalette.white),
                  ),
                  const SizedBox(height: 5),
                  // Text(
                  //   _auth.user!.fullName,
                  //   style: TextStyle(fontSize: 16, color: MyColorPalette.white),
                  // ),
                  Text(
                    _auth.user!.username,
                    style: TextStyle(fontSize: 14, color: MyColorPalette.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: MyInputLabel(
                label: "Personal Information",
                isRequired: false,
                textColor: MyColorPalette.purple,
                fontSize: 20,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              padding: EdgeInsets.all(12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
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
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Full Name ",
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColorPalette.textGrey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _auth.user!.fullName,
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColorPalette.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    child: Divider(color: Color.fromRGBO(0, 0, 0, 0.1)),
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Username ",
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColorPalette.textGrey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _auth.user!.username,
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColorPalette.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            MyListTile(
              leading: Icon(Icons.logout_rounded, color: MyColorPalette.red),
              title: "Logout",
              trailingIsChip: false,
              trailing: IconButton(
                onPressed: _handleLogout,
                icon: Icon(Icons.chevron_right_rounded),
              ),
              horizontalMargin: 8,
              borderRadius: 8,
              alignment: .center,
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }
}
