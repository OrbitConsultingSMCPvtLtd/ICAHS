import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/controllers/batch_controller.dart';
import 'package:icahs_hwr/controllers/report_controller.dart';
import 'package:icahs_hwr/core/Utils/color_utils.dart';
import 'package:icahs_hwr/core/Utils/date_utils.dart';
import 'package:icahs_hwr/core/Utils/utils.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/helper.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/views/home/behaviour%20reports/create_report_page.dart';
import 'package:icahs_hwr/widgets/my_chip.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReportDetailsPage extends StatefulWidget {
  const ReportDetailsPage({
    super.key,
    required this.batchID,
    required this.reportID,
  });
  final String batchID;
  final String reportID;

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  final ReportController _reportController = Get.find<ReportController>();
  final AuthController _auth = Get.find<AuthController>();
  final BatchController _batch = Get.find<BatchController>();

  void _handleDelete() async {
    final delete = await deleteDialog(
      context,
      title: "Delete?",
      content:
          "This Report record will be permanently deleted. Are you sure you want to delete it?",
      onTap: () async {
        var result = await _reportController.deletReport(
          widget.batchID,
          widget.reportID,
        );

        showSnackBar(
          result['status'].toString().toLowerCase().capitalize!,
          result['message'],
          color: result['status'] == "SUCCESS"
              ? MyColorPalette.success
              : MyColorPalette.error,
        );

        if (!mounted) return;
        Navigator.pop(context, true);
      },
    );

    if (delete == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    _reportController.loadReportDetails(widget.batchID, widget.reportID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (_reportController.isDetailLoading.value) {
          return Center(child: CircularProgressIndicator.adaptive());
        }

        if (_reportController.reportDetail.value == null) {
          return Center(child: CircularProgressIndicator.adaptive());
        }

        return Column(
          crossAxisAlignment: .start,
          children: [
            const SizedBox(height: 5),
            MyListTile(
              leading: Image.asset('assets/icons/student-icon.png', width: 25),
              title:
                  "${_reportController.reportDetail.value!.studentName.toLowerCase().capitalize} (STU${_reportController.reportDetail.value!.studentId})",
              sub2: _reportController.reportDetail.value!.batchName,
              sub3: _reportController.reportDetail.value!.hospitalName,
              elevation: 1,
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: MyColorPalette.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(25, 0, 0, 0),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: .min,
                children: [
                  _buildReportIssueCard(
                    formatDateToDDMMMMYYYY(
                      _reportController.reportDetail.value!.reportDate,
                    ),
                    _reportController.reportDetail.value!.issueTypeName ?? "--",
                  ),
                  _buildSeverityChipRow(
                    context,
                    _reportController.reportDetail.value!.severity,
                  ),
                  Row(
                    mainAxisAlignment: .start,
                    crossAxisAlignment: .center,
                    spacing: 20,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Action Required",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _reportController
                                  .reportDetail
                                  .value!
                                  .actionRequiredName ??
                              "--",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildColumn(
              "Issue Details",
              _reportController.reportDetail.value!.issueDetails,
              tag: "issue",
            ),
            const SizedBox(height: 10),
            _buildColumn(
              "Recommended Action",
              _reportController.reportDetail.value!.recommendedAction,
              tag: 'action',
            ),
            const SizedBox(height: 20),
            _buildReportedByRow(
              _reportController.reportDetail.value!.reportedBy ?? "--",
            ),
          ],
        );
      }),
      floatingActionButton: canCreateOrEdit()
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateReportPage(
                      report: _reportController.reportDetail.value,
                      batchId: widget.batchID,
                      hospitalId:
                          _reportController.reportDetail.value!.hospitalId!,
                    ),
                  ),
                );
              },
              backgroundColor: MyColorPalette.purple,
              foregroundColor: MyColorPalette.white,
              child: Icon(LucideIcons.pencil),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(
      context,
      title: "Report Details",
      icon: Hero(
        tag: "report",
        child: Image.asset('assets/icons/report-icon.png', width: 25),
      ),
      foregroundColor: MyColorPalette.white,
      backgroundColor: MyColorPalette.purple,
      actions: _auth.user!.isSupervisor && _batch.batchDetail.value!.isActive
          ? [
              IconButton(
                onPressed: _handleDelete,
                icon: Icon(
                  Icons.delete_rounded,
                  size: 28,
                  color: MyColorPalette.red,
                ),
              ),
            ]
          : null,
      hasActionsPadding: false,
      hasDivider: false,
    );
  }

  Widget _buildReportIssueCard(String reportDate, String issueType) {
    return Row(
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,
      spacing: 20,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            spacing: 10,
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Text(
                "Report Date",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(reportDate),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            spacing: 10,
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Text(
                "Issue Type",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(issueType),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityChipRow(BuildContext context, String severity) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: .start,
        crossAxisAlignment: .center,
        spacing: 20,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Severity",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            flex: 3,
            child: SizedBox(
              width: MediaQuery.widthOf(context) * 0.25,
              child: MyChip(
                label: Text(
                  severity,
                  style: TextStyle(
                    color: getColorFromStatus(severity, isBackground: false),
                  ),
                ),
                color: getColorFromStatus(severity, isBackground: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, String? detail, {required String tag}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: MyColorPalette.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: 8,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              detail ??
                  (tag == "issue"
                      ? "No Details Found."
                      : "No Actions Recommended."),
              style: TextStyle(
                color: detail == null
                    ? MyColorPalette.textGrey.withAlpha(185)
                    : MyColorPalette.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportedByRow(String reportedBy) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: .start,
        crossAxisAlignment: .center,
        spacing: 20,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Reported By",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            flex: 3,
            child: Text(reportedBy, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
