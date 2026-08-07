import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/controllers/navigation_controller.dart';
import 'package:icahs_hwr/core/Utils/utils.dart';
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
    final logout = await deleteDialog(
      context,
      title: "Logout?",
      content: "Are you sure you want to logout?",
      onTap: () async {
        showSnackBar(
          "Success",
          "You have been logged out successfuly.",
          color: MyColorPalette.success,
        );

        if (!mounted) return;
        Navigator.pop(context, true);
      },
    );

    if (logout == true) {
      _auth.logout();
      _nav.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightFactor = Theme.of(context).platform == TargetPlatform.android ? 2.5 : 3 ;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.heightOf(context) / heightFactor),
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
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                    child: CircleAvatar(
                      radius: MediaQuery.heightOf(context) <= 413 ? 35 : 55,
                      backgroundImage: AssetImage('assets/icons/profile.png'),
                    ),
                  ),
                  Text(
                    _auth.user!.role,
                    style: TextStyle(fontSize: 26, color: MyColorPalette.white),
                  ),
                  const SizedBox(height: 5),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              _buildInfoContainer(
                title: "Personal Information",
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    _buildInfoRow("Full Name ", _auth.user!.fullName),
                    const SizedBox(
                      child: Divider(color: Color.fromRGBO(0, 0, 0, 0.1)),
                    ),
                    _buildInfoRow("Username ", _auth.user!.username),
                    const SizedBox(
                      child: Divider(color: Color.fromRGBO(0, 0, 0, 0.1)),
                    ),
                    _buildInfoRow("Email ", _auth.user!.email ?? "--"),
                    const SizedBox(
                      child: Divider(color: Color.fromRGBO(0, 0, 0, 0.1)),
                    ),
                    _buildInfoRow("Contact No.", _auth.user!.contactNo ?? "--"),
                  ],
                ),
              ),
              if (_auth.user!.isSupervisor)
                _buildInfoContainer(
                  title: "Supervisor Information",
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    children: [
                      _buildInfoRow(
                        "Hospital Name ",
                        _auth.user!.hospitalName ?? "--",
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

              const SizedBox(height: kBottomNavigationBarHeight + 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer({required String title, required Widget child}) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: MyInputLabel(
            label: title,
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
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: MyColorPalette.textGrey),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: MyColorPalette.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
