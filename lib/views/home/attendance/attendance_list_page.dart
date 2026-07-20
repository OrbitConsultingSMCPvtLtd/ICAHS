import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/attendance_controller.dart';
import 'package:icahs_hwr/core/Utils/color_utils.dart';
import 'package:icahs_hwr/core/Utils/date_utils.dart';
import 'package:icahs_hwr/core/Utils/utils.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/models/batch_model.dart';
import 'package:icahs_hwr/views/home/attendance/attendance_detail_page.dart';
import 'package:icahs_hwr/views/home/attendance/mark_attendance_page.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AttendanceListPage extends StatefulWidget {
  const AttendanceListPage({super.key, required this.batch});

  final BatchModel batch;

  @override
  State<AttendanceListPage> createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  final AttendanceController _attendance = Get.find<AttendanceController>();

  @override
  void initState() {
    _loadingAttendance();
    super.initState();
  }

  void _loadingAttendance() async {
    await _attendance.loadInitialAttendanceRecords(widget.batch.hwrBatchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(child: _buildAttendanceList()),
        ],
      ),
      floatingActionButton: canCreateOrEdit()
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MarkAttendancePage(batch: widget.batch),
                  ),
                );
              },
              backgroundColor: MyColorPalette.purple,
              foregroundColor: MyColorPalette.white,
              label: Row(
                mainAxisSize: .min,
                spacing: 8,
                children: [Icon(LucideIcons.plus), Text("Add Attendance")],
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(
      context,
      foregroundColor: MyColorPalette.white,
      backgroundColor: MyColorPalette.purple,
      title: "Attendance",

      hasDivider: false,
    );
  }

  Widget _buildAttendanceList() {
    return Obx(() {
      if (_attendance.isLoading.value) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }

      if (_attendance.attendanceRecords.isEmpty) {
        return const Center(child: Text("No Records Found!"));
      }

      return RefreshIndicator(
        onRefresh: () async {
          _loadingAttendance();
        },
        child: ListView.builder(
          itemCount: _attendance.attendanceRecords.length,
          itemBuilder: (context, index) {
            var attd = _attendance.attendanceRecords[index];
            var stds = attd.totalStudents;
            return MyListTile(
              elevation: 0,
              borderRadius: 6,
              horizontalMargin: 8,
              title: formatDateToDDMMMMYYYY(attd.dated),
              sub1: "${stds.toString()} ${stds == 1 ? "student" : "students"}",
              trailing: Text(
                attd.attendanceStatus,
                style: TextStyle(
                  color: getColorFromStatus(
                    attd.attendanceStatus,
                    isBackground: false,
                  ),
                ),
              ),
              chipColor: getColorFromStatus(
                attd.attendanceStatus,
                isBackground: true,
              ),
              alignment: .center,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AttendanceDetailPage(
                    attnRecord: attd,
                    batch: widget.batch,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
