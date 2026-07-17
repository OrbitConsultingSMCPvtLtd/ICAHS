import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/batch_controller.dart';
import 'package:icahs_hwr/controllers/student_controller.dart';
import 'package:icahs_hwr/core/Utils/color_utils.dart';
import 'package:icahs_hwr/core/Utils/date_utils.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/models/batch_model.dart';
import 'package:icahs_hwr/views/home/attendance/attendance_list_page.dart';
import 'package:icahs_hwr/views/home/batches/batch_students_list_page.dart';
import 'package:icahs_hwr/views/home/behaviour%20reports/report_list_page.dart';
import 'package:icahs_hwr/views/home/evaluation/evaluation_list_page.dart';
import 'package:icahs_hwr/widgets/my_chip.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';
import 'package:icahs_hwr/widgets/my_stat_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BatchDetailPage extends StatefulWidget {
  const BatchDetailPage({super.key, required this.batchId});

  final String batchId;

  @override
  State<BatchDetailPage> createState() => _BatchDetailPageState();
}

class _BatchDetailPageState extends State<BatchDetailPage>
    with WidgetsBindingObserver {
  final BatchController _batchController = Get.find<BatchController>();
  final StudentController _studentController = Get.find<StudentController>();

  @override
  void initState() {
    super.initState();
    _batchController.getBatchDetails(widget.batchId);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _studentController.loadInitialStudents(widget.batchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          _batchController.getBatchDetails(widget.batchId);
        },
        child: Obx(() {
          if (_batchController.isDetailLoading.value) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (_batchController.batchDetail.value == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            var batch = _batchController.batchDetail.value!;
            return ListView(
              children: [
                if (!batch.isActive()) _buildCaution(),
                _buildBatchInfoCard(batch),
                _buildStatCards(batch),
                const SizedBox(height: 5),
                _buildRoutingCard(batch),
              ],
            );
          }
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(context, title: "Batch Details");
  }

  Widget _buildBatchInfoCard(BatchModel batch) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: MyColorPalette.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .start,
        children: [
          Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            spacing: 10,
            children: [
              Text(
                batch.batchName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColorPalette.darkPurple,
                ),
              ),
              Text(batch.hospitalName),

              Text(
                _getStartToEndDate(batch.startDate, batch.endDate),
                style: TextStyle(color: MyColorPalette.textGrey),
              ),
              Text(
                "Supervisor",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              Text(
                batch.supervisorName ?? "No Supervisor",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          MyChip(
            label: Text(
              batch.status == "Y" ? "Active" : "Inactive",
              style: TextStyle(
                color: getColorFromStatus(batch.status, isBackground: false),
              ),
            ),
            color: getColorFromStatus(batch.status, isBackground: true),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(BatchModel batch) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        // spacing: 2,
        children: [
          Row(
            // spacing: 2,
            children: [
              Expanded(
                child: MyStatCard(
                  title: "Students",
                  count: batch.totalStudents.toString(),
                  spacing: 15,
                  alignment: .center,
                  countColor: MyColorPalette.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BatchStudentsListPage(
                        batchId: batch.hwrBatchId,
                        batchName: batch.batchName,
                        totalStudents: batch.totalStudents,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MyStatCard(
                  title: "Today Attendance",
                  count: batch.attendance ?? "-- / --",
                  spacing: 15,
                  alignment: .center,
                  countColor: MyColorPalette.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AttendanceListPage(batch: batch),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            // spacing: 2,
            children: [
              Expanded(
                child: MyStatCard(
                  title: "Evaluations",
                  count: batch.totalEvaluations?.toString() ?? "--",
                  spacing: 15,
                  alignment: .center,
                  countColor: MyColorPalette.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EvaluationListPage(batchId: batch.hwrBatchId),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MyStatCard(
                  title: "Reports",
                  count: batch.totalReports?.toString() ?? "--",
                  spacing: 15,
                  alignment: .center,
                  countColor: MyColorPalette.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReportListPage(batchId: batch.hwrBatchId),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoutingCard(BatchModel batch) {
    final List<Map<String, dynamic>> items = [
      {
        "icon": LucideIcons.users,
        "title": "View Students",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BatchStudentsListPage(
              batchId: batch.hwrBatchId,
              batchName: batch.batchName,
              totalStudents: batch.totalStudents,
            ),
          ),
        ),
      },
      {
        "icon": LucideIcons.calendarCheck,
        "title": "Attendance",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendanceListPage(batch: batch)),
        ),
      },
      {
        "icon": LucideIcons.clipboardList,
        "title": "Evaluation",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EvaluationListPage(batchId: batch.hwrBatchId),
          ),
        ),
      },
      {
        "icon": LucideIcons.fileText,
        "title": "Reports",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportListPage(batchId: batch.hwrBatchId),
          ),
        ),
      },
      // {"icon": LucideIcons.squarePen, "title": "Edit Batch", "onTap": () {}},
    ];

    return Column(
      children: items.map((item) {
        return MyListTile(
          leading: Icon(item["icon"], color: MyColorPalette.purple),
          title: item["title"],
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          trailingIsChip: false,
          elevation: 1,
          onTap: item["onTap"],
        );
      }).toList(),
    );
  }

  Widget _buildCaution() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 252, 233, 211),
      ),
      child: Text(
        "⚠️ This is an inactive batch. It is available for viewing only.",
        style: TextStyle(color: MyColorPalette.darkOrange, fontSize: 12),
      ),
    );
  }

  String _getStartToEndDate(String start, String? end) {
    return "${formatDateToDDMMMMYYYY(start)} - ${end == null ? "present" : formatDateToDDMMMMYYYY(end)}";
  }
}
