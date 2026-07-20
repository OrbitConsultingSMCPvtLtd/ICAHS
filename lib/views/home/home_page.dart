import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/controllers/dashboard_controller.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/models/dashboard_stats.dart';
import 'package:icahs_hwr/widgets/my_stat_card.dart';
import 'package:marquee/marquee.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.navigateToBatches});

  final void Function()? navigateToBatches;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _auth = Get.find<AuthController>();
  final DashboardController _dashboard = Get.find<DashboardController>();

  @override
  void initState() {
    loadingDashBoard();
    super.initState();
  }

  void loadingDashBoard() async {
    await _dashboard.loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.user!;
    final screenWidth = MediaQuery.widthOf(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 26),
        title: Text(
          "Dashboard",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // extendBodyBehindAppBar: true,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 70,
            bottom: 0,
            child: Container(
              width: screenWidth * 2,
              height: screenWidth * 2,
              decoration: const BoxDecoration(
                color: Color.fromARGB(7, 0, 0, 255),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: screenWidth / 3,
            right: screenWidth / 3.5,
            child: IgnorePointer(
              child: Container(
                width: 270,
                height: 270,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    radius: 0.65,
                    colors: [
                      Color.fromARGB(238, 253, 252, 252),
                      Color.fromARGB(59, 253, 249, 249),
                      Color.fromARGB(15, 255, 255, 255),
                      Color.fromARGB(3, 255, 255, 255),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.4, 0.6, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: RefreshIndicator(
              onRefresh: () async {
                loadingDashBoard();
              },
              child: ListView(
                children: [
                  _buildEmpProfileCard(user.fullName, user.role),
                  const SizedBox(height: 5),
                  Container(
                    height: 30,
                    decoration: const BoxDecoration(
                      color: MyColorPalette.lowOpacityPurple,
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          MyColorPalette.darkPurple,
                          MyColorPalette.darkPurple,
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.1, 0.9, 1.0],
                      ),
                    ),
                    child: Center(
                      child: Marquee(
                        text: '✚  ICAHS Hospital Ward Rotation',
                        style: TextStyle(color: MyColorPalette.black),
                        fadingEdgeStartFraction: 0.3,
                        fadingEdgeEndFraction: 0.3,
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        blankSpace: 50.0,
                        velocity: 70.0,
                        startPadding: 50.0,
                        showFadingOnlyWhenScrolling: false,
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.ease,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.ease,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),
                  Obx(() {
                    if (_dashboard.isLoading.value) {
                      return SizedBox(
                        height: MediaQuery.heightOf(context) * 0.8,
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    return _buildStatCards(_dashboard.stats);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpProfileCard(String fullName, String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6D5DF6),
            Color.fromARGB(255, 96, 78, 255),
            Color.fromARGB(255, 126, 112, 255),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .center,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: .start,
              spacing: 2,
              children: [
                Text(
                  "Welcome back,",
                  style: TextStyle(
                    fontSize: 16,
                    color: MyColorPalette.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$role 👋",
                  style: TextStyle(
                    color: MyColorPalette.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Here's what's happening today.",
                  style: TextStyle(fontSize: 14, color: MyColorPalette.white),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -30,
                  top: -20,
                  child: IgnorePointer(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          radius: 0.65,
                          colors: [
                            Color.fromARGB(80, 255, 255, 255),
                            Color.fromARGB(40, 255, 255, 255),
                            Color.fromARGB(15, 255, 255, 255),
                            Color.fromARGB(3, 255, 255, 255),
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.4, 0.6, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                /// Decorative Circle
                Image.asset("assets/images/doctor2.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(DashboardStats stats) {
    return Column(
      // spacing: 6,
      children: [
        Row(
          // spacing: 6,
          children: [
            Expanded(
              child: MyStatCard(
                onTap: widget.navigateToBatches,
                leading: Image.asset(
                  'assets/icons/batches-icon.png',
                  width: 25,
                ),
                countPadding: EdgeInsets.symmetric(horizontal: 5),
                title: "My Batches",
                count: stats.batchesCount.toString(),
              ),
            ),
            Expanded(
              child: MyStatCard(
                leading: Image.asset(
                  'assets/icons/attendance-icon.png',
                  width: 25,
                ),
                countPadding: EdgeInsets.symmetric(horizontal: 5),
                title: "Attendance",
                count: "${stats.presentCount} / ${stats.totalAttendanceCount}",
              ),
            ),
          ],
        ),
        Row(
          // spacing: 6,
          children: [
            Expanded(
              child: MyStatCard(
                leading: Image.asset(
                  'assets/icons/evaluation-icon.png',
                  width: 25,
                ),
                countPadding: EdgeInsets.symmetric(horizontal: 5),
                title: "Evaluations",
                count: stats.evaluationsCount.toString(),
              ),
            ),
            Expanded(
              child: MyStatCard(
                leading: Image.asset('assets/icons/report-icon.png', width: 25),
                title: "Reports",
                count: stats.reportsCount.toString(),
                countPadding: EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
