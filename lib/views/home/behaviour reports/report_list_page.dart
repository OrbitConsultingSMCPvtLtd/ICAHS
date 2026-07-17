import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/controllers/batch_controller.dart';
import 'package:icahs_hwr/controllers/report_controller.dart';
import 'package:icahs_hwr/core/Utils/color_utils.dart';
import 'package:icahs_hwr/core/Utils/date_utils.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/views/home/behaviour%20reports/create_report_page.dart';
import 'package:icahs_hwr/views/home/behaviour%20reports/report_details_page.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key, required this.batchId});

  final String batchId;

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  final ReportController _report = Get.find<ReportController>();
  final BatchController _batch = Get.find<BatchController>();
  final AuthController _auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    loadingReports();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _report.loadLovs();
    });
  }

  void loadingReports() async {
    await _report.loadInitialReports(widget.batchId);
  }

  void _handleOnTap(String batchId, String reportId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportDetailsPage(batchID: batchId, reportID: reportId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          loadingReports();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 250,
              pinned: true,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded),
              ),
              backgroundColor: MyColorPalette.purple,
              foregroundColor: MyColorPalette.white,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                expandedTitleScale: 1,
                background: Container(
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
                    // borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: -30,
                          top: -20,
                          child: IgnorePointer(
                            child: Container(
                              width: 270,
                              height: 270,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  radius: 0.7,
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
                        Positioned(
                          left: 0,
                          bottom: -10,
                          child: IgnorePointer(
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  radius: 0.4,
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
                        LottieBuilder.asset(
                          'assets/gifs/clipboard.json',
                          animate: true,
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                ),
                title: Text(
                  "Behaviour Report",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MyColorPalette.white,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              fillOverscroll: true,
              child: _buildReportsList(),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _auth.user!.isSupervisor && _batch.batchDetail.value!.isActive()
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateReportPage(
                      batchId: _batch.batchDetail.value!.hwrBatchId,
                      hospitalId: _batch.batchDetail.value!.hospitalId,
                    ),
                  ),
                );
              },
              backgroundColor: MyColorPalette.purple,
              foregroundColor: MyColorPalette.white,
              label: Row(
                mainAxisSize: .min,
                spacing: 8,
                children: [Icon(LucideIcons.plus), Text("New Report")],
              ),
            )
          : null,
    );
  }

  Widget _buildReportsList() {
    return Obx(() {
      if (_report.isLoading.value) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }

      if (_report.reports.isEmpty) {
        return const Center(child: Text("No Records Found!"));
      }

      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _report.reports.length,
        itemBuilder: (context, index) {
          var report = _report.reports[index];
          return MyListTile(
            elevation: 0,
            borderRadius: 6,
            horizontalMargin: 8,
            title:
                "${report.studentName.toLowerCase().capitalize} (STU${report.studentId})",
            sub2: formatDateToDDMMMMYYYY(report.reportDate),
            trailing: Text(
              report.severity,
              style: TextStyle(
                color: getColorFromStatus(report.severity, isBackground: false),
              ),
            ),
            chipColor: getColorFromStatus(report.severity, isBackground: true),
            alignment: .center,
            onTap: () {
              _handleOnTap(widget.batchId, report.reportId);
            },
          );
        },
      );
    });
  }
}
