import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/attendance_controller.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/core/Utils/color_utils.dart';
import 'package:icahs_hwr/core/Utils/date_utils.dart';
import 'package:icahs_hwr/core/Utils/utils.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/helper.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/models/attendance_model.dart';
import 'package:icahs_hwr/models/batch_model.dart';
import 'package:icahs_hwr/views/home/attendance/mark_attendance_page.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';
import 'package:icahs_hwr/widgets/my_stat_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AttendanceDetailPage extends StatefulWidget {
  const AttendanceDetailPage({
    super.key,
    required this.attnRecord,
    required this.batch,
  });

  final AttendanceModel attnRecord;
  final BatchModel batch;

  @override
  State<AttendanceDetailPage> createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  final AttendanceController _atten = Get.find<AttendanceController>();
  final AuthController _auth = Get.find<AuthController>();

  final ScrollController _scrollController = ScrollController();
  RxBool isLoadingMore = false.obs;

  void _scrollListenser() async {
    if (isLoadingMore.value || _atten.isStdLoading.value) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      isLoadingMore.value = true;

      await _atten.loadMoreStudentAttendanceRecords(
        widget.attnRecord.hwrBatchId,
        widget.attnRecord.hwrAttendanceId,
      );

      isLoadingMore.value = false;
    }
  }

  void loadingStudentAttendanceRecords() async {
    await _atten.loadStudentAttendanceRecords(
      widget.attnRecord.hwrBatchId,
      widget.attnRecord.hwrAttendanceId,
    );
  }

  void _handleDelete() async {
    final delete = await deleteDialog(
      context,
      title: "Delete?",
      content:
          "This Attendance record will be permanently deleted. Are you sure you want to delete it?",
      onTap: () async {
        var result = await _atten.deletAttendance(
          widget.attnRecord.hwrAttendanceId,
          widget.attnRecord.hwrBatchId,
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
    loadingStudentAttendanceRecords();
    _scrollController.addListener(_scrollListenser);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attn = widget.attnRecord;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          loadingStudentAttendanceRecords();
          setState(() {});
        },
        child: CustomScrollView(
          controller: ScrollController(),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: .min,
                children: [
                  const SizedBox(height: 10),
                  MyListTile(
                    leading: Icon(
                      CupertinoIcons.calendar_today,
                      color: MyColorPalette.purple,
                      size: 28,
                    ),
                    color: Colors.transparent,
                    title: formatDateToDDMMMMYYYY(attn.dated),
                    sub1: attn.batchName,
                    sub2: widget.batch.hospitalName,
                    trailing: Text(
                      attn.attendanceStatus,
                      style: TextStyle(
                        color: getColorFromStatus(
                          attn.attendanceStatus,
                          isBackground: false,
                        ),
                      ),
                    ),
                    chipColor: getColorFromStatus(
                      attn.attendanceStatus,
                      isBackground: true,
                    ),
                    elevation: 0,
                  ),
                  const SizedBox(height: 10),
                  _buildAttendanceStatCards(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            _buildStudentAttendanceList(),
          ],
        ),
      ),
      floatingActionButton: canCreateOrEdit()
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MarkAttendancePage(
                      pageTitle: "Update Attendance",
                      batch: widget.batch,
                      attendance: widget.attnRecord,
                      attendanceDetails: _atten.stdAttendanceRecords,
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
      foregroundColor: MyColorPalette.white,
      backgroundColor: MyColorPalette.purple,
      actions: _auth.user!.isSupervisor && widget.batch.isActive
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
      title: "Attendance Details",
      hasDivider: false,
    );
  }

  Widget _buildAttendanceStatCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: .spaceAround,
        spacing: 10,
        children: [
          Expanded(
            child: Obx(() {
              return MyStatCard(
                title: "Present",
                count: _atten.present.value == 0
                    ? widget.attnRecord.present.toString()
                    : _atten.present.value.toString(),
                elevation: 0,
                spacing: 10,
                alignment: .center,
                countFontSize: 36,
                color: MyColorPalette.lowOpacityGreen,
                titleColor: MyColorPalette.darkGreen,
                countColor: MyColorPalette.darkGreen,
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              return MyStatCard(
                title: "Absent",
                count: _atten.absent.value == 0
                    ? widget.attnRecord.absent.toString()
                    : _atten.absent.value.toString(),
                elevation: 0,
                spacing: 10,
                alignment: .center,
                countFontSize: 36,
                color: MyColorPalette.lowOpacityRed,
                titleColor: MyColorPalette.darkRed,
                countColor: MyColorPalette.darkRed,
              );
            }),
          ),
          Expanded(
            child: MyStatCard(
              title: "Total",
              count: widget.attnRecord.totalStudents.toString(),
              elevation: 0,
              spacing: 10,
              alignment: .center,
              countFontSize: 36,
              color: MyColorPalette.lowOpacityPurple,
              titleColor: MyColorPalette.darkPurple,
              countColor: MyColorPalette.darkPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentAttendanceList() {
    return Obx(() {
      if (_atten.isStdLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator.adaptive()),
        );
      }

      if (_atten.stdAttendanceRecords.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: Text("No Records Found!")),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          var attd = _atten.stdAttendanceRecords[index];
          return MyListTile(
            elevation: 0,
            borderRadius: 6,
            horizontalMargin: 8,
            leading: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/icons/profile.png'),
              ),
            ),
            alignment: .center,
            title:
                "${attd.studentName.toLowerCase().capitalize} (STU${attd.studentId})",
            sub2: attd.remarks,
            trailing: Center(
              child: Text(
                attd.studentStatus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: getColorFromStatus(
                    attd.studentStatus,
                    isBackground: false,
                  ),
                ),
              ),
            ),
            chipColor: getColorFromStatus(
              attd.studentStatus,
              isBackground: true,
            ),
            titleTextStyle: TextStyle(fontSize: 16),
          );
        }, childCount: _atten.stdAttendanceRecords.length),
      );
    });
  }
}
